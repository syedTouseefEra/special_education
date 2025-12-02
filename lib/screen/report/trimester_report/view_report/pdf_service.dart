import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' hide PdfDocument;
import 'package:pdfx/pdfx.dart';
import 'package:special_education/components/pdf_generate/build_field_row.dart';
import 'package:special_education/constant/assets.dart';
import 'package:special_education/screen/report/report_dashboard_provider.dart';
import 'package:special_education/screen/report/trimester_report/view_report/view_pdf_report_data_model.dart';

// NOTE: change the type of reportData to match your actual model type
class PdfService {
  /// Pass in the original pdf bytes (if server returned an actual PDF)
  /// and the parsed report data (list from API). If originalPdfBytes is null,
  /// this will build a PDF from scratch using reportData[0].
  static Future<Uint8List> stampPdfWithStar({
    Uint8List? originalPdfBytes,
    String title = 'Report Card',
    required List<ViewPDFReportDataModel> reportData,
  }) async {
    final bd = await rootBundle.load(ImgAssets.yellowStar);
    final starBytes = bd.buffer.asUint8List();

    // If no original PDF, build a PDF from scratch using reportData
    if (originalPdfBytes == null) {
      return _generatePdfFromScratch(title: title, starBytes: starBytes, reportData: reportData);
    }

    final pdfDoc = await PdfDocument.openData(originalPdfBytes);
    final outPdf = pw.Document();

    // Overlay each page with star images and optionally textual data from reportData
    for (int i = 1; i <= pdfDoc.pagesCount; i++) {
      final page = await pdfDoc.getPage(i);
      final pageImage = await page.render(
        width: page.width,
        height: page.height,
        format: PdfPageImageFormat.png,
      );
      await page.close();

      final pngBytes = pageImage?.bytes;
      final format = PdfPageFormat(
        pageImage!.width!.toDouble(),
        pageImage.height!.toDouble(),
      );

      final w = format.width;
      final h = format.height;

      // star sizes
      final small = w * 0.10;
      final large = w * 0.18;

      // Choose which report row to show on which page (example: put first item on every page,
      // or map pages <-> reportData items). Here we use first item for overlay text.
      final model = reportData.isNotEmpty ? reportData.first : null;

      outPdf.addPage(
        pw.Page(
          pageFormat: format,
          build: (ctx) {
            return pw.Stack(
              children: [
                // Background original page as image
                pw.Positioned.fill(
                  child: pw.Image(
                    pw.MemoryImage(pngBytes!),
                    fit: pw.BoxFit.cover,
                  ),
                ),

                // top-left small star
                pw.Positioned(
                  left: w * 0.05,
                  top: h * 0.03,
                  child: pw.Image(pw.MemoryImage(starBytes), width: small),
                ),

                // top-right small star
                pw.Positioned(
                  left: w - (w * 0.05) - small,
                  top: h * 0.03,
                  child: pw.Image(pw.MemoryImage(starBytes), width: small),
                ),

                // bottom-left large star
                pw.Positioned(
                  left: w * 0.05,
                  top: h - (h * 0.05) - large,
                  child: pw.Image(pw.MemoryImage(starBytes), width: large),
                ),

                // bottom-right large star
                pw.Positioned(
                  left: w - (w * 0.05) - large,
                  top: h - (h * 0.05) - large,
                  child: pw.Image(pw.MemoryImage(starBytes), width: large),
                ),

                // Example overlay text block (top center)
                if (model != null)
                  pw.Positioned(
                    left: w * 0.15,
                    top: h * 0.05 + small,
                    child: pw.Container(
                      width: w * 0.7,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text("Student: ${model.studentName ?? 'N/A'}",
                              style: pw.TextStyle(fontSize: 14.sp, fontWeight: pw.FontWeight.bold)),
                          pw.Text("DOB: ${model.dob ?? 'N/A'}", style: pw.TextStyle(fontSize: 12.sp)),
                          pw.Text("PID: ${model.pidNumber ?? 'N/A'}", style: pw.TextStyle(fontSize: 12.sp)),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      );
    }

    return outPdf.save();
  }

  static Future<Uint8List> _generatePdfFromScratch({
    required String title,
    required Uint8List starBytes,
    required List<ViewPDFReportDataModel> reportData,
  }) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final model = reportData.isNotEmpty ? reportData.first : null;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(0),
        build: (pw.Context context) {
          return [
            pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: PdfColors.pdfColor,
                    width: 10.sp,
                  ),
                ),
                child: pw.Column(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // header with stars (example)
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Center(child: pw.Image(pw.MemoryImage(starBytes), width: 40)),
                              pw.SizedBox(height: 10.sp),
                              pw.Center(child: pw.Image(pw.MemoryImage(starBytes), width: 40)),
                            ],
                          ),

                          pw.SizedBox(height: 10.sp),
                          pw.Center(
                            child: pw.Container(
                              width: 400.sp,
                              decoration: pw.BoxDecoration(
                                color: PdfColors.pdfColor,
                              ),
                              child: pw.Center(
                                child: pw.Padding(
                                  padding: pw.EdgeInsets.symmetric(vertical: 5.sp),
                                  child: pw.Text(
                                    model?.instituteName.toString() ?? 'HAMAARE SITAARE',
                                    style: pw.TextStyle(fontSize: 35.sp, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // ... rest of your prebuilt layout
                          pw.SizedBox(height: 20.sp),
                          pw.Center(
                            child: pw.Padding(
                              padding: pw.EdgeInsets.symmetric(vertical: 5.sp),
                              child: pw.Text(
                                model?.instituteAdddress.toString() ?? 'HAMAARE SITAARE',
                                style: pw.TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: pw.FontWeight.normal,
                                  color: PdfColors.black, // optional better contrast
                                ),
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 20.sp),
                          pw.Center(
                            child: pw.Padding(
                              padding: pw.EdgeInsets.symmetric(vertical: 5.sp,horizontal: 100.sp),
                              child: pw.Container(
                                decoration: pw.BoxDecoration(
                                  color: PdfColors.pdfColor,
                                  borderRadius: pw.BorderRadius.circular(5.sp),
                                ),
                                child: pw.Center(
                                  child: pw.Padding(
                                    padding: pw.EdgeInsets.symmetric(vertical: 5.sp),
                                    child: pw.Text(
                                      'STUDENT PROGRESS CARD',
                                      style: pw.TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white, // optional better contrast
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // fields from model (replace hardcoded values)
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Divider(thickness: 1.sp, color: PdfColors.pdfColor),
                          pw.SizedBox(height: 10.sp),
                          buildFieldRow(label: "CHILD'S NAME:  ", value: model?.studentName ?? "Syed Touseef", width: 20.sp),
                          buildFieldRow(label: "DATE OF BIRTH:", value: model?.dob ?? "05-10-2018", width: 19.sp),
                          buildFieldRow(label: "PID:", value: model?.pidNumber.toString() ?? "12345", width: 110.sp),
                          buildFieldRow(label: "DIAGNOSIS:", value: model?.diagnosis ?? "Autism Spectrum Disorder", width: 50.sp),

                          pw.Divider(thickness: 1.sp, color: PdfColors.pdfColor),
                          pw.SizedBox(height: 10.sp),
                          buildFieldRow(label: "DATE OF ADMISSION IN WELLNESS WARD:", value: model?.dateOfAdmission ?? "05-10-2024", width: 15.sp),
                          buildFieldRow(label: "LEARNING PROGRAM START DATE:", value: model?.programStartDate ?? "05-10-2018", width: 65.sp),
                          buildFieldRow(label: "PROGRESS REPORT TIMEFRAME :", value: model?.timeFrame ?? "12345", width: 75.sp),
                          pw.Divider(thickness: 1.sp, color: PdfColors.pdfColor),
                          pw.SizedBox(height: 10.sp),
                          buildFieldRow(label: "MOTHER'S NAME:", value: model?.motherName ?? "NA"),
                          buildFieldRow(label: "FATHER'S NAME:       ", value: model?.fatherName ?? "NA", width: 33.sp),
                          buildFieldRow(
                            label: "ADDRESS:",
                            value: "${model?.addressLine1 ?? ''} ${model?.addressLine2 ?? ''}".trim().isNotEmpty
                                ? "${model?.addressLine1 ?? ''} ${model?.addressLine2 ?? ''}".trim()
                                : "Era Hospital, Sector 3 Sarfarazganj Lucknow",
                            width: 82.sp,
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }
}

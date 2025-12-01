import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' hide PdfDocument;
import 'package:pdfx/pdfx.dart';
import 'package:special_education/components/pdf_generate/build_field_row.dart';
import 'package:special_education/constant/assets.dart';

class PdfService {
  static Future<Uint8List> stampPdfWithStar({
    Uint8List? originalPdfBytes,
    String title = 'Report Card ',
  }) async {
    // Load the star asset on main isolate
    final bd = await rootBundle.load(ImgAssets.yellowStar);
    final starBytes = bd.buffer.asUint8List();

    // If no PDF provided → generate simple page
    if (originalPdfBytes == null) {
      return _generatePdfFromScratch(title: title, starBytes: starBytes);
    }

    // Open PDF using pdfx
    final pdfDoc = await PdfDocument.openData(originalPdfBytes);

    final outPdf = pw.Document();

    for (int i = 1; i <= pdfDoc.pagesCount; i++) {
      final page = await pdfDoc.getPage(i);

      // Render page to PNG using pdfx
      final pageImage = await page.render(
        width: page.width,
        height: page.height,
        format: PdfPageImageFormat.png,
      );

      await page.close();

      final pngBytes = pageImage?.bytes;

      // Create a page with the SAME dimensions
      final format = PdfPageFormat(
        pageImage!.width!.toDouble(),
        pageImage.height!.toDouble(),
      );

      final w = format.width;
      final h = format.height;

      // star sizes
      final small = w * 0.10;
      final large = w * 0.18;

      outPdf.addPage(
        pw.Page(
          pageFormat: format,
          build: (ctx) {
            return pw.Stack(
              children: [
                // Background original page
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
  }) async {
    final pdf = pw.Document();
    final now = DateTime.now();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(
          0,
        ),

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
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Center(
                                child: pw.Image(
                                  pw.MemoryImage(starBytes),
                                  width: 40,
                                ),
                              ),
                              pw.SizedBox(height: 10.sp),
                              pw.Center(
                                child: pw.Image(
                                  pw.MemoryImage(starBytes),
                                  width: 40,
                                ),
                              ),
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
                                  padding: pw.EdgeInsets.symmetric(
                                    vertical: 5.sp,
                                  ),
                                  child: pw.Text(
                                    "HAMAARE SITAARE",
                                    style: pw.TextStyle(
                                      fontSize: 35.sp,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 5.sp),
                          pw.Center(
                            child: pw.Text(
                              'A Special Learning House',
                              style: pw.TextStyle(
                                fontSize: 20.sp,
                                color: PdfColors.black,
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 10.sp),
                          pw.Center(
                            child: pw.Text(
                              'Wellness Ward, ERA s Lucknow Medical College',
                              style: pw.TextStyle(
                                fontSize: 20.sp,
                                color: PdfColors.black,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 20.sp),
                          pw.Center(
                            child: pw.Container(
                              width: 400.sp,
                              decoration: pw.BoxDecoration(
                                color: PdfColors.pdfColor,
                              ),
                              child: pw.Center(
                                child: pw.Padding(
                                  padding: pw.EdgeInsets.symmetric(
                                    vertical: 5.sp,
                                  ),
                                  child: pw.Text(
                                    "STUDENT PROGRESS CARD",
                                    style: pw.TextStyle(
                                      fontSize: 25.sp,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Divider(
                            thickness: 1.sp,
                            color: PdfColors.pdfColor,
                          ),
                          pw.SizedBox(height: 10.sp),
                          buildFieldRow(
                            label: "CHILD'S NAME:  ",
                            value: "Syed Touseef",
                            width: 20.sp,
                          ),
                          buildFieldRow(
                            label: "DATE OF BIRTH:",
                            value: "05-10-2018",
                            width: 19.sp,
                          ),
                          buildFieldRow(
                            label: "PID:",
                            value: "12345",
                            width: 110.sp,
                          ),
                          buildFieldRow(
                            label: "DIAGNOSIS:",
                            value: "Autism Spectrum Disorder",
                            width: 50.sp,
                          ),

                          pw.Divider(
                            thickness: 1.sp,
                            color: PdfColors.pdfColor,
                          ),
                          pw.SizedBox(height: 10.sp),
                          buildFieldRow(
                            label: "DATE OF ADMISSION IN WELLNESS WARD:",
                            value: "05-10-2024",
                            width: 15.sp,
                          ),
                          buildFieldRow(
                            label: "LEARNING PROGRAM START DATE:",
                            value: "05-10-2018",
                            width: 65.sp,
                          ),
                          buildFieldRow(
                            label: "PROGRESS REPORT TIMEFRAME :",
                            value: "12345",
                            width: 75.sp,
                          ),
                          pw.Divider(
                            thickness: 1.sp,
                            color: PdfColors.pdfColor,
                          ),
                          pw.SizedBox(height: 10.sp),
                          buildFieldRow(
                            label: "MOTHER'S NAME:",
                            value: "XYZXYZ AASS",
                          ),
                          buildFieldRow(
                            label: "FATHER'S NAME:       ",
                            value: "FDHDYW WTYEQW ",
                            width: 33.sp,
                          ),
                          buildFieldRow(
                            label: "ADDRESS:",
                            value:
                                "Era Hospital, Sector 3 Sarfarazganj Lucknow ",
                            width: 82  .sp,
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

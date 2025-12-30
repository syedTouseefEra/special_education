
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' hide PdfDocument;
import 'package:pdfx/pdfx.dart';
import 'package:special_education/components/pdf_generate/build_field_row.dart';
import 'package:special_education/constant/assets.dart';
import 'package:special_education/screen/report/trimester_report/view_report/view_pdf_report_data_model.dart';

class PdfService {
  /// Main entrypoint
  static Future<Uint8List> stampPdfWithStar({
    Uint8List? originalPdfBytes,
    String title = 'Report Card',
    required List<ViewPDFReportDataModel> reportData,
  }) async {
    final img1 = await rootBundle.load(ImgAssets.headerReportView);
    final headerReportView = img1.buffer.asUint8List();
    final img2 = await rootBundle.load(ImgAssets.bottomReportView);
    final bottomReportView = img2.buffer.asUint8List();



    if (originalPdfBytes == null) {
      return _generatePdfFromScratch(
        title: title,
        headerReportView: headerReportView,
        bottomReportView: bottomReportView,
        reportData: reportData,
      );
    }

    final pdfDoc = await PdfDocument.openData(originalPdfBytes);
    final outPdf = pw.Document();
    final model = reportData.isNotEmpty ? reportData.first : null;

    for (int i = 1; i <= pdfDoc.pagesCount; i++) {
      final page = await pdfDoc.getPage(i);
      final pageImage = await page.render(
        width: page.width,
        height: page.height,
        format: PdfPageImageFormat.png,
      );
      await page.close();

      final pngBytes = pageImage!.bytes;
      final format = PdfPageFormat(pageImage.width!.toDouble(), pageImage.height!.toDouble());
      final w = format.width;
      final h = format.height;
      final small = w * 0.10;
      final large = w * 0.18;

      outPdf.addPage(
        pw.Page(
          pageFormat: format,
          build: (ctx) {
            final children = <pw.Widget>[
              // original page as full-page background
              pw.Positioned.fill(
                child: pw.Image(pw.MemoryImage(pngBytes), fit: pw.BoxFit.cover),
              ),
            ];

            if (i == 1) {
              children.add(
                pw.Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: pw.Container(height: h * 0.08, color: PdfColors.red),
                ),
              );

              children.add(
                pw.Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: pw.Container(height: h * 0.08, color: PdfColors.red),
                ),
              );


              // optional: small decorative red dot (left middle)
              children.add(
                pw.Positioned(
                  left: w * 0.05,
                  top: h * 0.6,
                  child: pw.Container(height: 20.sp, width: 20.sp, decoration: pw.BoxDecoration(color: PdfColors.red)),
                ),
              );

              // optional: corner moon images if you want (keep them last so they're on top)
              // children.addAll([
              //   pw.Positioned(left: w * 0.05, bottom: h * 0.02, child: pw.SizedBox(width: large, height: large, child: pw.Image(pw.MemoryImage(moon), fit: pw.BoxFit.contain))),
              //   pw.Positioned(right: w * 0.05, bottom: h * 0.02, child: pw.SizedBox(width: large, height: large, child: pw.Image(pw.MemoryImage(moon), fit: pw.BoxFit.contain))),
              // ]);
            } // end if first page

            return pw.Stack(children: children);
          },
        ),
      );
    } // end for pages

    await pdfDoc.close();
    return outPdf.save();
  }


  // ------------------------
  // Build a two-page PDF from scratch (header + progress page)
  // ------------------------
  static Future<Uint8List> _generatePdfFromScratch({
    required String title,
    required Uint8List headerReportView,
    required Uint8List bottomReportView,
    required List<ViewPDFReportDataModel> reportData,
  }) async {
    final pdf = pw.Document();
    final model = reportData.isNotEmpty ? reportData.first : null;

    // Page 1: header / student info
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return [
            pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: PdfColors.pdfColor,
                  width: 10.sp,
                ),
              ),
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [

                    // ================= HEADER IMAGE (DYNAMIC) =================
                    pw.LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints!.maxWidth+40;
                        final height = width * (190 / 600);

                        return pw.Center(
                          child: pw.Image(
                            pw.MemoryImage(headerReportView),
                            width: width,
                            height: height,
                            fit: pw.BoxFit.contain,
                          ),
                        );
                      },
                    ),

                    pw.SizedBox(height: 8.sp),

                    // ================= TITLE =================
                    pw.Center(
                      child: pw.Container(
                        padding: pw.EdgeInsets.symmetric(
                          vertical: 6.sp,
                          horizontal: 30.sp,
                        ),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.pdfColor,
                          borderRadius: pw.BorderRadius.circular(6.sp),
                        ),
                        child: pw.Text(
                          'STUDENT PROGRESS CARD',
                          style: pw.TextStyle(
                            fontSize: 20.sp,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ),

                    pw.SizedBox(height: 5.sp),
                    pw.Divider(color: PdfColors.pdfColor, thickness: 0.7.sp),

                    // ================= STUDENT DETAILS =================
                    buildFieldRow(
                      label: "CHILD'S NAME:",
                      value: _nullSafe(model?.studentName, fallback: "NA"),
                      width: 20.sp,
                    ),
                    buildFieldRow(
                      label: "DATE OF BIRTH:",
                      value: _nullSafe(model?.dob, fallback: "NA"),
                      width: 19.sp,
                    ),
                    buildFieldRow(
                      label: "PID:",
                      value: _nullSafe(model?.pidNumber?.toString(), fallback: "NA"),
                      width: 110.sp,
                    ),
                    buildFieldRow(
                      label: "DIAGNOSIS:",
                      value: _nullSafe(model?.diagnosis, fallback: "NA"),
                      width: 50.sp,
                    ),

                    pw.Divider(color: PdfColors.pdfColor, thickness: 0.7.sp),

                    buildFieldRow(
                      label: "DATE OF ADMISSION IN WELLNESS WARD:",
                      value: _nullSafe(model?.dateOfAdmission, fallback: "NA"),
                      width: 15.sp,
                    ),
                    buildFieldRow(
                      label: "LEARNING PROGRAM START DATE:",
                      value: _nullSafe(model?.programStartDate, fallback: "NA"),
                      width: 65.sp,
                    ),
                    buildFieldRow(
                      label: "PROGRESS REPORT TIMEFRAME:",
                      value: _nullSafe(model?.timeFrame, fallback: "NA"),
                      width: 75.sp,
                    ),

                    pw.Divider(color: PdfColors.pdfColor, thickness: 0.7.sp),

                    buildFieldRow(
                      label: "MOTHER'S NAME:",
                      value: _nullSafe(model?.motherName, fallback: "NA"),
                    ),
                    buildFieldRow(
                      label: "FATHER'S NAME:",
                      value: _nullSafe(model?.fatherName, fallback: "NA"),
                      width: 33.sp,
                    ),
                    buildFieldRow(
                      label: "ADDRESS:",
                      value: _buildAddress(model),
                      width: 82.sp,
                    ),

                    pw.SizedBox(height: 20.sp),

                    // ================= BOTTOM IMAGE =================
                    pw.LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints!.maxWidth;
                        final height = width * (90 / 600);

                        return pw.Padding(
                          padding: pw.EdgeInsets.only(top: 10.sp),
                          child: pw.Center(
                            child: pw.Image(
                              pw.MemoryImage(bottomReportView),
                              width: width,
                              height: height,
                              fit: pw.BoxFit.fill,
                            ),
                          ),
                        );
                      },
                    ),

                  ],
                ),
              ),
            ),
          ];
        },
      ),
    );


    // Page 2: progress table
    pdf.addPage(await buildProgressPagePdf(reportData));

    return pdf.save();
  }

  static Future<pw.Page> buildProgressPagePdf(List<ViewPDFReportDataModel> reportData) async {
    final model = reportData.isNotEmpty ? reportData.first : null;

    // Extract areas from model.skillQuality (tolerant to typed model or parsed JSON)
    final List<Map<String, dynamic>> areas = _extractAreasFromModel(model);

    // Extract performance map from model.trimesterPerformance
    final Map<String, dynamic> perf = _extractPerfFromModel(model);

    final dot = await rootBundle.load(ImgAssets.dot); // or sharedImage asset
    final dotImage = dot.buffer.asUint8List();

    // Styles
    final headerStyle = pw.TextStyle(fontSize: 11.sp, fontWeight: pw.FontWeight.bold);
    final smallStyle = pw.TextStyle(fontSize: 12.sp);
    final bigStarStyle = pw.TextStyle(fontSize: 14.sp, fontWeight: pw.FontWeight.bold);

    // Build table rows
    List<pw.TableRow> buildRows() {
      final rows = <pw.TableRow>[];

      // header row
      rows.add(pw.TableRow(
        decoration: pw.BoxDecoration(color: PdfColors.grey300),
        children: [
          pw.Padding(padding: pw.EdgeInsets.all(6.sp), child: pw.Text('LEARNING AREAS', style: headerStyle)),
          pw.Padding(padding: pw.EdgeInsets.all(6.sp), child: pw.Text('MILESTONES\nACHIEVED', style: headerStyle)),
          pw.Padding(padding: pw.EdgeInsets.all(6.sp), child: pw.Text("TEACHER'S REMARK", style: headerStyle)),
          pw.Padding(padding: pw.EdgeInsets.all(6.sp), child: pw.Text('STARS\nCOLLECTED', style: headerStyle, textAlign: pw.TextAlign.center)),
        ],
      ));

      for (final a in areas) {
        final left = pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text(a['title'] ?? '', style: pw.TextStyle(fontSize: 10.sp, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4.sp),
          ...((a['bullets'] as List<String>).map((b) => pw.Row(

              children: [
            pw.Padding(padding: pw.EdgeInsets.only(bottom: 0.sp,right: 4.sp),child: pw.Center(child: pw.Image(pw.MemoryImage(dotImage), width: 10,height: 5)),),
            pw.Expanded(child: pw.Text(b, style: smallStyle)),
          ]))),
        ]);

        final milestonesWidget = pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: (a['milestones'] as List<String>).map((m) => pw.Text(m, style: smallStyle)).toList(),
        );

        final remarkWidget = pw.Container(padding: pw.EdgeInsets.symmetric(vertical: 4.sp, horizontal: 6.sp), child: pw.Text(a['teacherRemark'] ?? '', style: smallStyle));

        final starsWidget = pw.Container(height: 50.sp, alignment: pw.Alignment.center, child: pw.Text('${a['stars']}', style: bigStarStyle));

        rows.add(pw.TableRow(verticalAlignment: pw.TableCellVerticalAlignment.middle, children: [
          pw.Padding(padding: pw.EdgeInsets.all(6.sp), child: left),
          pw.Padding(padding: pw.EdgeInsets.all(6.sp), child: milestonesWidget),
          pw.Padding(padding: pw.EdgeInsets.all(6.sp), child: remarkWidget),
          pw.Padding(padding: pw.EdgeInsets.all(6.sp), child: starsWidget),
        ]));
      }
      return rows;
    }

    pw.Widget buildPerformanceBox() {
      final header = pw.Row(children: [
        pw.Expanded(flex: 4, child: pw.Container(padding: pw.EdgeInsets.all(6.sp), child: pw.Text('Performance Zone', style: headerStyle))),
        pw.Expanded(flex: 3, child: pw.Container(padding: pw.EdgeInsets.all(6.sp), child: pw.Text('Score on the scale of 1-5 (where 1 is lowest & 5 is highest)', style: headerStyle))),
        pw.Expanded(flex: 3, child: pw.Container(padding: pw.EdgeInsets.all(6.sp), child: pw.Text("Teacher's Remark", style: headerStyle))),
      ]);

      final rows = <pw.Widget>[header, pw.Divider()];

      perf.forEach((k, v) {
        rows.add(pw.Column(children: [
          pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Expanded(flex: 4, child: pw.Container(padding: pw.EdgeInsets.all(6.sp), child: pw.Text(k, style: smallStyle))),
            pw.Expanded(flex: 3, child: pw.Container(padding: pw.EdgeInsets.all(6.sp), child: pw.Text('${v ?? ''}', style: smallStyle))),
            pw.Expanded(flex: 3, child: pw.Container(padding: pw.EdgeInsets.all(6.sp), child: pw.Text('', style: smallStyle))),
          ]),
          pw.Divider(),
        ]));
      });

      return pw.Container(margin: pw.EdgeInsets.only(top: 8.sp), decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black, width: 0.7)), child: pw.Column(children: rows));
    }

    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(16.sp),
      build: (pw.Context ctx) {
        return pw.Container(
          decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black, width: 1.5)),
          padding: pw.EdgeInsets.all(8.sp),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
            pw.Expanded(
              child: pw.Container(
                decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black, width: 0.7)),
                child: pw.Table(
                  columnWidths: {
                    0: const pw.FlexColumnWidth(3.6),
                    1: const pw.FlexColumnWidth(2.6),
                    2: const pw.FlexColumnWidth(2.6),
                    3: const pw.FlexColumnWidth(1.0),
                  },
                  border: pw.TableBorder(horizontalInside: pw.BorderSide(width: 0.5)),
                  children: buildRows(),
                ),
              ),
            ),
            buildPerformanceBox(),
          ]),
        );
      },
    );
  }

  static List<Map<String, dynamic>> _extractAreasFromModel(ViewPDFReportDataModel? model) {
    if (model == null) return _sampleAreas();

    final raw = _safeGet(model.skillQuality);
    if (raw == null) return _sampleAreas();

    final list = <Map<String, dynamic>>[];
    try {
      for (final entry in raw) {
        String title = '';
        String teacherRemark = '';
        int stars = 0;
        List<String> bullets = [];
        List<String> milestones = [];

        if (entry is Map) {
          // name/title
          title = (entry['name'] ?? entry['title'] ?? '').toString();

          // remarks
          teacherRemark = (entry['remarks'] ?? '').toString();

          // star value: prefer selectedStar then star (tolerant to string/int)
          final starRaw = entry['selectedStar'] ?? entry['star'] ?? 0;
          if (starRaw is int) {
            stars = starRaw;
          } else {
            stars = int.tryParse(starRaw?.toString() ?? '') ?? 0;
          }

          // qualities array -> bullets & milestones
          if (entry['quality'] is List) {
            bullets = List<String>.from((entry['quality'] as List).map((q) => q['name']?.toString() ?? ''));

            milestones = List<String>.from((entry['quality'] as List).map((q) {
              final r = q['ratingId'];
              if (r == null) return 'Not Applicable';
              switch (r) {
                case 0:
                  return 'Not Applicable';
                case 1:
                  return 'Poor';
                case 2:
                  return 'Average';
                case 3:
                  return 'Good';
                case 4:
                  return 'Excellent';
                default:
                  return r.toString();
              }
            }));
          }
        } else {
          try {
            final name = entry.name ?? entry.title ?? '';
            title = name.toString();
          } catch (_) {}
          try {
            teacherRemark = (entry.remarks ?? '').toString();
          } catch (_) {}
          try {
            final starVal = entry.selectedStar ?? entry.star ?? 0;
            stars = (starVal is int) ? starVal : int.tryParse(starVal?.toString() ?? '') ?? 0;
          } catch (_) {}
          try {
            final q = entry.quality as List;
            bullets = List<String>.from(q.map((x) => (x.name ?? '').toString()));
            milestones = List<String>.from(q.map((x) {
              final r = x.ratingId;
              if (r == null) return 'Not Applicable';
              switch (r) {
                case 0:
                  return 'Not Applicable';
                case 1:
                  return 'Poor';
                case 2:
                  return 'Average';
                case 3:
                  return 'Good';
                case 4:
                  return 'Excellent';
                default:
                  return r.toString();
              }
            }));
          } catch (_) {}
        }

        final formattedTitle = _formatTitleWithStar(title, stars);

        list.add({
          'title': formattedTitle,
          'bullets': bullets,
          'milestones': milestones,
          'teacherRemark': teacherRemark,
          'stars': stars,
        });
      }
    } catch (_) {
      return _sampleAreas();
    }

    return list.isNotEmpty ? list : _sampleAreas();
  }

  static String _formatTitleWithStar(String rawTitle, int starCount) {
    final base = (rawTitle).toString().trim().toUpperCase();
    if (base.isEmpty) return base;
    if (starCount == 0) return base;
    return '$base (${starCount.toString()} Star Max.)';
  }

  static Map<String, dynamic> _extractPerfFromModel(ViewPDFReportDataModel? model) {
    if (model == null) return _defaultPerformance();
    final raw = _safeGet(model.trimesterPerformance);
    if (raw == null) return _defaultPerformance();

    final map = <String, dynamic>{};
    try {
      for (final entry in raw) {
        if (entry is Map) {
          final name = (entry['name'] ?? entry['title'] ?? '').toString();
          final ratingId = entry['ratingId'] ?? entry['rating'] ?? 0;
          map[name] = ratingId;
        } else {
          try {
            final name = (entry.name ?? '').toString();
            final ratingId = entry.ratingId ?? 0;
            map[name] = ratingId;
          } catch (_) {}
        }
      }
    } catch (_) {
      return _defaultPerformance();
    }
    return map.isNotEmpty ? map : _defaultPerformance();
  }

  static dynamic _safeGet(dynamic v) {
    if (v == null) return null;
    return v;
  }

  static String _nullSafe(dynamic v, {String fallback = ''}) {
    if (v == null) return fallback;
    final s = v.toString();
    return s.trim().isEmpty ? fallback : s;
  }

  static String _buildAddress(ViewPDFReportDataModel? model) {
    if (model == null) return "Era Hospital, Sector 3 Sarfarazganj Lucknow";
    final a1 = _nullSafe(model.addressLine1);
    final a2 = _nullSafe(model.addressLine2);
    final joined = [a1, a2].where((e) => e.isNotEmpty).join(' ').trim();
    return joined.isNotEmpty ? joined : "Era Hospital, Sector 3 Sarfarazganj Lucknow";
  }

  static Map<String, dynamic> _defaultPerformance() {
    return {
      'Attention (Concentration/Focus)': 1,
      'Memory (Retention & Recall)': 1,
      'Learning Interest/Engagement': 1,
      'Command following/Responsiveness': 1,
    };
  }

  static List<Map<String, dynamic>> _sampleAreas() {
    return [
      {
        "title": "COLORING (4 Stars Max.)",
        "bullets": ["Color Holding", "Free Hand", "Large Space", "Closed Space"],
        "milestones": ["Poor", "Average", "Good", "Excellent"],
        "teacherRemark": "Testing one",
        "stars": 1,
      },
      {
        "title": "WRITTEN (8 Stars Max.)",
        "bullets": [
          "Pencil Holding",
          "Tracing",
          "Standing Line",
          "Sleeping Line",
          "Slanting Line",
          "Curve",
          "Pattern Tracing",
          "Letter Formation"
        ],
        "milestones": ["Good", "Good", "Not Applicable", "Not Applicable", "Not Applicable", "Not Applicable", "Not Applicable", "Not Applicable"],
        "teacherRemark": "",
        "stars": 8,
      },
      {
        "title": "ORAL (4 Stars Max.)",
        "bullets": ["English Letters (A-Z)", "Numbers (1-100)"],
        "milestones": ["Not Applicable", "Not Applicable"],
        "teacherRemark": "",
        "stars": 4,
      },
      {
        "title": "ENGLISH LETTERS RECOGNITION (5 Stars Max.)",
        "bullets": ["Letters", "Number", "Colors", "Shapes", "Objects"],
        "milestones": ["Not Applicable", "Not Applicable", "Not Applicable", "Not Applicable", "Not Applicable"],
        "teacherRemark": "",
        "stars": 5,
      },
      {
        "title": "RECITATION/ RHYMES (2 Stars Max.)",
        "bullets": ["With Prompt", "Without Prompt"],
        "milestones": ["Good", "Poor"],
        "teacherRemark": "second last remark testing",
        "stars": 2,
      },
      {
        "title": "ART/DRAWING (2 Stars Max.)",
        "bullets": ["With Prompt", "Without Prompt"],
        "milestones": ["Poor", "Average"],
        "teacherRemark": "Not Available",
        "stars": 2,
      },
    ];
  }
}


import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
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
    // existing emoji images
    final img1 = await rootBundle.load(ImgAssets.smileEmoji);
    final smileEmoji = img1.buffer.asUint8List();
    final img2 = await rootBundle.load(ImgAssets.moon);
    final moon = img2.buffer.asUint8List();

    // load the two top images and the shared bottom image from assets
    final bData = await rootBundle.load(ImgAssets.ballons);
    final balloon = bData.buffer.asUint8List();
    final rData = await rootBundle.load(ImgAssets.rainbow);
    final rainbow = rData.buffer.asUint8List();
    final sData = await rootBundle.load(ImgAssets.flower); // or sharedImage asset
    final sharedImage = sData.buffer.asUint8List();

    // If there is no original PDF, build from scratch (two pages)
    if (originalPdfBytes == null) {
      return _generatePdfFromScratch(
        title: title,
        smileEmoji: smileEmoji,
        moon: moon,
        balloon: balloon,
        rainbow: rainbow,
        reportData: reportData,
      );
    }

    // Otherwise overlay the decorations on each page of the provided PDF
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
              // top red bar (behind images)
              children.add(
                pw.Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: pw.Container(height: h * 0.08, color: PdfColors.red),
                ),
              );

              // bottom red bar (behind bottom images)
              children.add(
                pw.Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: pw.Container(height: h * 0.08, color: PdfColors.red),
                ),
              );

              // TOP LEFT: balloon + rainbow pair
              children.add(
                pw.Positioned(
                  left: w * 0.05,
                  top: h * 0.02,
                  child: pw.Row(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.SizedBox(width: small, height: small, child: pw.Image(pw.MemoryImage(balloon), fit: pw.BoxFit.contain)),
                      pw.SizedBox(width: 6),
                      pw.SizedBox(width: small, height: small, child: pw.Image(pw.MemoryImage(rainbow), fit: pw.BoxFit.contain)),
                    ],
                  ),
                ),
              );

              // TOP RIGHT: same pair (use right for stable placement)
              children.add(
                pw.Positioned(
                  right: w * 0.05,
                  top: h * 0.02,
                  child: pw.Row(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.SizedBox(width: small, height: small, child: pw.Image(pw.MemoryImage(balloon), fit: pw.BoxFit.contain)),
                      pw.SizedBox(width: 6),
                      pw.SizedBox(width: small, height: small, child: pw.Image(pw.MemoryImage(rainbow), fit: pw.BoxFit.contain)),
                    ],
                  ),
                ),
              );

              // BOTTOM CENTER: the shared image, placed ABOVE the bottom red bar
              children.add(
                pw.Positioned(
                  left: w * 0.15,
                  right: w * 0.15,
                  bottom: h * 0.02 + (h * 0.08),
                  child: pw.SizedBox(
                    height: h * 0.18,
                    child: pw.Image(pw.MemoryImage(sharedImage), fit: pw.BoxFit.contain),
                  ),
                ),
              );

              // BOTTOM LEFT: balloon
              children.add(
                pw.Positioned(
                  left: w * 0.05,
                  bottom: h * 0.05,
                  child: pw.SizedBox(width: large, height: large, child: pw.Image(pw.MemoryImage(balloon), fit: pw.BoxFit.contain)),
                ),
              );

              // BOTTOM RIGHT: rainbow
              children.add(
                pw.Positioned(
                  right: w * 0.05,
                  bottom: h * 0.05,
                  child: pw.SizedBox(width: large, height: large, child: pw.Image(pw.MemoryImage(rainbow), fit: pw.BoxFit.contain)),
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
              children.addAll([
                pw.Positioned(left: w * 0.05, bottom: h * 0.02, child: pw.SizedBox(width: large, height: large, child: pw.Image(pw.MemoryImage(moon), fit: pw.BoxFit.contain))),
                pw.Positioned(right: w * 0.05, bottom: h * 0.02, child: pw.SizedBox(width: large, height: large, child: pw.Image(pw.MemoryImage(moon), fit: pw.BoxFit.contain))),
              ]);
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
    required Uint8List smileEmoji,
    required Uint8List moon,
    required Uint8List balloon,
    required Uint8List rainbow,
    required List<ViewPDFReportDataModel> reportData,
  }) async {
    final pdf = pw.Document();
    final model = reportData.isNotEmpty ? reportData.first : null;

    // Page 1: header / student info
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(0),
        build: (pw.Context context) {
          return [
            pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(
                decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.pdfColor, width: 10.sp)),
                child: pw.Column(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      // header stars & institute name
                      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                        pw.Center(child: pw.Image(pw.MemoryImage(smileEmoji), width: 40)),
                        pw.SizedBox(height: 10.sp),
                        pw.Center(child: pw.Image(pw.MemoryImage(moon), width: 40)),
                      ]),
                      pw.SizedBox(height: 10.sp),
                      pw.Center(
                        child: pw.Container(
                          width: 400.sp,
                          decoration: pw.BoxDecoration(color: PdfColors.pdfColor),
                          child: pw.Center(
                            child: pw.Padding(
                              padding: pw.EdgeInsets.symmetric(vertical: 5.sp),
                              child: pw.Text(_nullSafe(model?.instituteName, fallback: 'Hamaare Sitaare'),
                                  style: pw.TextStyle(fontSize: 35.sp, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                            ),
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 10.sp),
                      pw.Center(
                        child: pw.Text(_nullSafe(model?.instituteAdddress, fallback: 'Wellness Ward, Era Lucknow Medical College'),
                            style: pw.TextStyle(fontSize: 16.sp, color: PdfColors.black, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center),
                      ),
                      pw.SizedBox(height: 10.sp),
                      pw.Center(
                        child: pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 5.sp, horizontal: 100.sp),
                          child: pw.Container(
                            decoration: pw.BoxDecoration(color: PdfColors.pdfColor, borderRadius: pw.BorderRadius.circular(5.sp)),
                            child: pw.Center(
                              child: pw.Padding(
                                padding: pw.EdgeInsets.symmetric(vertical: 5.sp),
                                child: pw.Text('STUDENT PROGRESS CARD',
                                    style: pw.TextStyle(fontSize: 20.sp, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),

                  // student fields
                  pw.Expanded(
                    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Divider(thickness: 1.sp, color: PdfColors.pdfColor),
                      pw.SizedBox(height: 10.sp),
                      buildFieldRow(label: "CHILD'S NAME:  ", value: _nullSafe(model?.studentName, fallback: "NA"), width: 20.sp),
                      buildFieldRow(label: "DATE OF BIRTH:", value: _nullSafe(model?.dob, fallback: "NA"), width: 19.sp),
                      buildFieldRow(label: "PID:", value: _nullSafe(model?.pidNumber?.toString(), fallback: "NA"), width: 110.sp),
                      buildFieldRow(label: "DIAGNOSIS:", value: _nullSafe(model?.diagnosis, fallback: "NA"), width: 50.sp),
                      pw.Divider(thickness: 1.sp, color: PdfColors.pdfColor),
                      pw.SizedBox(height: 10.sp),
                      buildFieldRow(label: "DATE OF ADMISSION IN WELLNESS WARD:", value: _nullSafe(model?.dateOfAdmission, fallback: "NA"), width: 15.sp),
                      buildFieldRow(label: "LEARNING PROGRAM START DATE:", value: _nullSafe(model?.programStartDate, fallback: "NA"), width: 65.sp),
                      buildFieldRow(label: "PROGRESS REPORT TIMEFRAME :", value: _nullSafe(model?.timeFrame, fallback: "NA"), width: 75.sp),
                      pw.Divider(thickness: 1.sp, color: PdfColors.pdfColor),
                      pw.SizedBox(height: 10.sp),
                      buildFieldRow(label: "MOTHER'S NAME:", value: _nullSafe(model?.motherName, fallback: "NA")),
                      buildFieldRow(label: "FATHER'S NAME:       ", value: _nullSafe(model?.fatherName, fallback: "NA"), width: 33.sp),
                      buildFieldRow(label: "ADDRESS:", value: _buildAddress(model), width: 82.sp),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                        pw.Center(child: pw.Padding(padding: pw.EdgeInsets.only(left: 10.sp),child: pw.Image(pw.MemoryImage(balloon), width: 80.sp,height: 90.sp))),

                            pw.Image(
                              pw.MemoryImage(rainbow),
                              width: 100.sp,
                              height: 100.sp,
          fit: pw.BoxFit.contain,

                            )


                          ]
                      ),
                      // pw.SizedBox(height: 95),
                      // pw.Container(
                      //   height: 20,
                      //   width: double.infinity,
                      //   color: PdfColors.red,
                      // ),
                    ]),
                  ),
                ]),
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
    final headerStyle = pw.TextStyle(fontSize: 9.sp, fontWeight: pw.FontWeight.bold);
    final smallStyle = pw.TextStyle(fontSize: 10.sp);
    final bigStarStyle = pw.TextStyle(fontSize: 15.sp, fontWeight: pw.FontWeight.bold);

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
          pw.Text(a['title'] ?? '', style: pw.TextStyle(fontSize: 8.sp, fontWeight: pw.FontWeight.bold)),
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
        // entry could be a Map or a typed object
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

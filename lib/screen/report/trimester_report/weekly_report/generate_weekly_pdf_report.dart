import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'weekly_pdf_report_data_model.dart';

Future<pw.Document> generateIEPPdf(
  List<WeeklyPdfReportDataModel> reportData,
) async {
  final pdf = pw.Document();

  if (reportData.isEmpty) return pdf;

  final student = reportData.first;

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(15),
      build: (context) => [

        pw.SizedBox(height: 0),
        _headerSection(student),

        pw.SizedBox(height: 8),

        /// ===== PRE-ASSESSMENT =====
        _preAssessmentSection(student),

        pw.SizedBox(height: 8),

        /// ===== LEARNING OBJECTIVES =====
        _learningObjectiveSection(student),

        pw.SizedBox(height: 5),

        /// ===== WEEKLY TABLE =====
        _weeklyGoalTable(student),
      ],
    ),
  );

  return pdf;
}

/// ======================
/// HEADER SECTION
/// ======================
pw.Widget _headerSection(WeeklyPdfReportDataModel student) {
  return pw.Container(
    padding: pw.EdgeInsets.all(8),
    decoration: pw.BoxDecoration(border: pw.Border.all()),
    child: pw.Column(
      children: [
        pw.Text(
          "INDIVIDUALISED EDUCATION PROGRAM",
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              "Name: ${student.firstName} ${student.lastName}",
              style: pw.TextStyle(fontSize: 14),
            ),
            pw.Text(
              "Age: ${student.age}",
              style: pw.TextStyle(fontSize: 14),
            ),
          ],
        ),
        pw.SizedBox(height: 4),

        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              "Diagnosis: ${student.diagnosis}",
              style: pw.TextStyle(fontSize: 14),
            ),
            pw.Text(
              "PID: ${student.pidNumber}",
              style: pw.TextStyle(fontSize: 14),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              "Gender: ${student.gender}",
              style: pw.TextStyle(fontSize: 14),
            ),
            pw.Text(
              "D.O.A: ${student.dateOfAdmission}",
              style: pw.TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    ),
  );
}

/// ======================
/// PRE-ASSESSMENT
/// ======================
pw.Widget _preAssessmentSection(WeeklyPdfReportDataModel student) {
  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.all(8),
    decoration: pw.BoxDecoration(border: pw.Border.all()),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "PRE-ASSESSMENT :",
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          "Psycho-Motor Skill :",
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),

        ...student.skillList!.expand((skill) {
          return skill.skillRating!.map((s) {
            return pw.Padding(
              padding: pw.EdgeInsets.only(bottom: 5),
              child: pw.RichText(
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text: "${s.name}: ",
                      style: pw.TextStyle(
                        fontSize: 13,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black,
                      ),
                    ),

                    pw.TextSpan(
                      text: _ratingText(s.ratingId ?? 0),
                      style: pw.TextStyle(
                        fontSize: 13,
                        fontWeight: pw.FontWeight.normal,
                        color: PdfColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        }).toList(),
      ],
    ),
  );
}

/// ======================
/// LEARNING OBJECTIVE
/// ======================
pw.Widget _learningObjectiveSection(WeeklyPdfReportDataModel student) {
  final goals = student.learningObjective?.first.longTermGoal ?? [];

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        "Learning Objective :",
        style: pw.TextStyle(
          fontSize: 15,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      pw.SizedBox(height: 8),
      pw.Table(
        border: pw.TableBorder.all(),
        columnWidths: {
          0: const pw.FlexColumnWidth(1.3),
          1: const pw.FlexColumnWidth(6),
          2: const pw.FlexColumnWidth(1),
          3: const pw.FlexColumnWidth(1),
        },
        children: [
          pw.TableRow(
            children: [
              /// ✅ LEFT LABEL — TOP LEFT
              pw.Container(
                alignment: pw.Alignment.bottomLeft,
                padding: const pw.EdgeInsets.all(6),
                child: pw.Text(
                  "Long Term Goals :",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),

              /// GOALS CONTENT
              pw.Padding(
                padding: const pw.EdgeInsets.all(6),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: goals.map((g) {
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 5),
                      child: pw.Text(
                        _cleanHtml(g.longTermGoal),
                        style: const pw.TextStyle(fontSize: 11),
                      ),
                    );
                  }).toList(),
                ),
              ),

              /// EMPTY CELLS
              // pw.SizedBox(),
              // pw.SizedBox(),
            ],
          ),


        ],
      ),
    ],
  );
}




/// ======================
/// WEEKLY TABLE
/// ======================
pw.Widget _weeklyGoalTable(WeeklyPdfReportDataModel student) {
  final weeklyGoals = student.learningObjective?.first.weeklyGoal;

  return pw.Table(
    border: pw.TableBorder.all(),
    columnWidths: {
      0: const pw.FlexColumnWidth(1.2),
      1: const pw.FlexColumnWidth(2),
      2: const pw.FlexColumnWidth(2),
      3: const pw.FlexColumnWidth(1.5),
      4: const pw.FlexColumnWidth(1.5),
    },
    children: [
      _tableHeader(),
      ...weeklyGoals!.map((w) {
        return pw.TableRow(
          children: [
            _cell("Week ${w.weekCount}\n(${w.durationDate})"),
            _cell(_cleanHtml(w.goals)),
            _cell(_cleanHtml(w.intervention)),
            _cell(_cleanHtml(w.learningBarriers)),
            _cell(_cleanHtml(w.learningOutcome)),
          ],
        );
      }),
    ],
  );
}

/// ======================
/// HELPERS
/// ======================
pw.TableRow _tableHeader() {
  return pw.TableRow(
    children: [
      _headerCell("TIMEFRAME"),
      _headerCell("GOALS"),
      _headerCell("INTERVENTION"),
      _headerCell("LEARNING PARTNERS"),
      _headerCell("OUTCOME"),
    ],
  );
}

pw.Widget _headerCell(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(6),
    child: pw.Text(
      text,
      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
    ),
  );
}

pw.Widget _cell(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(6),
    child: pw.Text(text, style: const pw.TextStyle(fontSize: 12)),
  );
}

String _ratingText(int rating) {
  switch (rating) {
    case 1:
      return "Poor";
    case 2:
      return "Average";
    case 3:
      return "Good";
    case 4:
      return "Excellent";
    default:
      return "Not Applicable";
  }
}

String _cleanHtml(String? value) {
  if (value == null) return "-";
  return value.replaceAll(RegExp(r'<[^>]*>'), '');
}

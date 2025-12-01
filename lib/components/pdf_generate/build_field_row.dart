

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' hide PdfDocument;

pw.Widget buildFieldRow({
  required String label,
  required String value,
  double? width,
}) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(horizontal: 30.sp, vertical: 6.sp),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 15.sp,
            fontWeight: pw.FontWeight.bold,
          ),
        ),

        pw.SizedBox(width: (width ?? 30).sp),

        pw.Expanded(
          child: pw.Container(
            color: PdfColors.placeHolderColor,
            child: pw.Padding(
              padding: pw.EdgeInsets.symmetric(
                horizontal: 20.sp,
                vertical: 5.sp,
              ),
              child: pw.Text(
                value,
                style: pw.TextStyle(fontSize: 14.sp,color: PdfColors.pdfColor),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

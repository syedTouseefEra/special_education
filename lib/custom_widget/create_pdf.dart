
import 'package:pdf/widgets.dart' as pw;

import 'dart:io';

Future<void> showHelloWorldPdf() async {
  final pdf = pw.Document();
  print("Document PDF");
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Center(
        child: pw.Text('Hello World!'),
      ),
    ),
  );

  final file = File('example.pdf');
  await file.writeAsBytes(await pdf.save());
}

// lib/widgets/pdf_preview_fullscreen.dart
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:special_education/screen/report/trimester_report/view_report/pdf_service.dart';
import 'package:special_education/screen/report/trimester_report/view_report/view_pdf_report_data_model.dart';


class PdfPreviewFullScreen extends StatefulWidget {
  final String title;
  final Uint8List? templatePdfBytes;
  final List<ViewPDFReportDataModel> reportData;   // <-- ADD THIS

  const PdfPreviewFullScreen({
    super.key,
    this.title = 'Report Card',
    this.templatePdfBytes,
    required this.reportData,   // <-- MAKE REQUIRED
  });


  @override
  State<PdfPreviewFullScreen> createState() => _PdfPreviewFullScreenState();
}

class _PdfPreviewFullScreenState extends State<PdfPreviewFullScreen> {
  Uint8List? _pdfBytes;
  bool _isGenerating = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Enter immersive fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _ensurePdfReady();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _ensurePdfReady({bool force = false}) async {
    if (_pdfBytes != null && !force) return;
    setState(() {
      _isGenerating = true;
      _error = null;
    });

    try {
      // Call your PdfService — pass templatePdfBytes if you have one.
      final bytes = await PdfService.stampPdfWithStar(
        originalPdfBytes: widget.templatePdfBytes,
        title: widget.title,
        reportData: widget.reportData,   // <-- FIX
      );


      if (!mounted) return;
      setState(() {
        _pdfBytes = bytes;
      });
    } catch (e, st) {
      debugPrint('PDF generation error: $e\n$st');
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  void _sharePdf() {
    if (_pdfBytes == null) return;
    Printing.sharePdf(bytes: _pdfBytes!, filename: '${widget.title}.pdf');
  }

  @override
  Widget build(BuildContext context) {
    // Determine preview width to encourage full-bleed display
    final screenW = MediaQuery.of(context).size.width;

    return Scaffold(

      // No bottomNavigationBar here — this route should replace the app chrome visually
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.title, style: const TextStyle(color: Colors.black)),
        actions: [
          if (_pdfBytes != null)
            IconButton(
              tooltip: 'Share PDF',
              icon: const Icon(Icons.share),
              onPressed: _sharePdf,
            ),
          IconButton(
            tooltip: 'Regenerate',
            icon: const Icon(Icons.refresh),
            onPressed: () => _ensurePdfReady(force: true),
          ),
        ],
      ),

      // Make the body fill entire screen
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Preview area
            if (_pdfBytes != null)
              Positioned.fill(
                child: PdfPreview(
                  maxPageWidth: screenW, // encourage full-width preview
                  allowPrinting: true,
                  allowSharing: false, // we use custom share action
                  canChangePageFormat: false,
                  build: (PdfPageFormat format) async => _pdfBytes!,
                ),
              )
            else if (_error != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Error generating PDF:\n$_error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
            else
            // Empty placeholder while waiting for loader to show
              const SizedBox.shrink(),

            // Loading overlay
            if (_isGenerating)
              Container(
                color: Colors.black45,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Preparing preview...', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

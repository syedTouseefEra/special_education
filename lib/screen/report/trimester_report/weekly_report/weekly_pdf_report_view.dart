import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';

import 'generate_weekly_pdf_report.dart';
import 'weekly_pdf_report_data_model.dart';

class WeeklyReportPdfView extends StatelessWidget {
  final List<WeeklyPdfReportDataModel> reportData;

  const WeeklyReportPdfView({
    super.key,
    required this.reportData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.sp),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomHeaderView(
                        courseName: "",
                        moduleName: "Weekly Report",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.sp,),
                      child: IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () async {
                          final pdf = await generateIEPPdf(reportData);
                          await Share.shareXFiles([
                            XFile.fromData(
                              await pdf.save(),
                              mimeType: 'application/pdf',
                              name: 'Weekly_IEP_Report.pdf',
                            )
                          ]);
                        },
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 0.7.sp),
              ],
            ),
          ),

          body: LayoutBuilder(
            builder: (context, constraints) {
              return PdfPreview(
                canChangePageFormat: false,
                canChangeOrientation: false,
                canDebug: false,
                allowPrinting: false,
                allowSharing: false,
        
                // 🔥 forces page to fill screen width → height scales automatically
                maxPageWidth: constraints.maxWidth,
        
                build: (format) async {
                  final pdf = await generateIEPPdf(reportData);
                  return pdf.save();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}


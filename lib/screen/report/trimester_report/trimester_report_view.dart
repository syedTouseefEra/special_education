import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/constant/assets.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/create_pdf.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/screen/report/trimester_report/view_report/pdf_preview_page.dart';
import 'package:special_education/screen/report/report_dashboard_provider.dart';
import 'package:special_education/screen/report/trimester_report/generate_trimester_report/learning_area_report_view.dart';
import 'package:special_education/screen/report/trimester_report/trimester_report_data_model.dart';
import 'package:special_education/utils/navigation_utils.dart';

class TrimesterReportView extends StatefulWidget {
  final TrimesterReportDataModal student;
  const TrimesterReportView({super.key, required this.student});

  @override
  State<TrimesterReportView> createState() => _TrimesterReportState();
}

class _TrimesterReportState extends State<TrimesterReportView> {
  late final List<dynamic> trimesters;
  late final ReportDashboardProvider provider;

  @override
  void initState() {
    super.initState();
    trimesters = widget.student.trimester ?? <dynamic>[];
    provider = Provider.of<ReportDashboardProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomAppBar(enableTheming: false),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomHeaderView(
                    courseName: '',
                    moduleName: "Trimester Report",
                  ),
                  SizedBox(height: 5.sp),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gradientColorOne,
                          AppColors.gradientColorTwo,
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15.sp),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 90.sp,
                                width: 90.sp,
                                decoration: BoxDecoration(
                                  color: AppColors.themeColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                  image:
                                      widget.student.image != null &&
                                          widget.student.image!.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            '${ApiServiceUrl.urlLauncher}uploads/${widget.student.image}',
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : const DecorationImage(
                                          image: AssetImage(ImgAssets.user),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              SizedBox(width: 20.sp),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomContainer(
                                      borderRadius: 0,
                                      text: '${widget.student.studentName}'
                                          .trim(),
                                      containerColor: AppColors.yellow,
                                      padding: 1,
                                      innerPadding: EdgeInsets.symmetric(
                                        vertical: 5.sp,
                                        horizontal: 15.sp,
                                      ),
                                    ),
                                    SizedBox(height: 5.sp),
                                    CustomText(
                                      text: 'Age- ${widget.student.age}',
                                    ),
                                    CustomText(
                                      text: 'PID- ${widget.student.pidNumber}',
                                    ),
                                    CustomText(
                                      text:
                                          'Gender- ${widget.student.gender ?? 'NA'}',
                                    ),
                                    CustomText(
                                      text:
                                          'D.O.B- ${widget.student.age == ' Years' ? "NA" : widget.student.age}',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.sp),
                          CustomContainer(
                            width: MediaQuery.sizeOf(context).width,
                            borderRadius: 10.sp,
                            text: 'Diagnosis- GD',
                            textAlign: TextAlign.center,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.gradientColorTwo,
                                AppColors.gradientColorFour,
                              ],
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                            ),
                            padding: 0.sp,
                            innerPadding: EdgeInsets.symmetric(
                              vertical: 8.sp,
                              horizontal: 35.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.sp),
                  Padding(
                    padding: EdgeInsets.all(0.sp),
                    child: Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: trimesters.length,
                          separatorBuilder: (_, __) => SizedBox(height: 8.sp),
                          itemBuilder: (context, index) {
                            final t = trimesters[index];
                            final int id =
                                (t.trimesterId ?? t['trimesterId']) is int
                                ? (t.trimesterId ?? t['trimesterId']) as int
                                : int.tryParse(
                                        (t.trimesterId ?? t['trimesterId'])
                                            .toString(),
                                      ) ??
                                      (index + 1);
                            final String reportStatus =
                                (t.reportStatus ?? t['reportStatus'])
                                    ?.toString() ??
                                'Report';
                            final String durationDate =
                                (t.durationDate ?? t['durationDate'])
                                    ?.toString() ??
                                '--';
                            final String? endDate = (t.endDate ?? t['endDate'])
                                ?.toString();
                            final String status =
                                (t.status ?? t['status'])?.toString() ?? '';

                            final bool isView =
                                reportStatus.toLowerCase().contains('view') ||
                                reportStatus.toLowerCase().contains(
                                  'view report',
                                );
                            final String buttonText = isView
                                ? 'View Report'
                                : reportStatus;
                            final Color buttonColor = isView
                                ? AppColors.green
                                : AppColors.yellow;

                            String formatDuration(String start, String? end) {
                              final s = start.isNotEmpty ? start : '--';
                              final e = (end == null || end.isEmpty)
                                  ? '--'
                                  : end;
                              return '3 Months ($s - $e)';
                            }

                            return Padding(
                              padding: EdgeInsets.all(5.sp),
                              child: Container(
                                width: MediaQuery.sizeOf(context).width,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(0.r),
                                  border: Border.all(
                                    color: AppColors.textGrey,
                                    width: 0.8.sp,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10.sp),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CustomText(
                                            text: 'Trimester $id',
                                            fontSize: 16.sp,
                                            color: AppColors.themeColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          SizedBox(width: 8.sp),
                                          CustomText(
                                            text: '|',
                                            color: AppColors.grey,
                                            fontSize: 18.sp,
                                          ),
                                          SizedBox(width: 12.sp),
                                          CustomText(
                                            text: '. $status',
                                            color: AppColors.yellow,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 3.sp),
                                      Visibility(
                                        visible: status == 'Ongoing',
                                        child: CustomText(
                                          text:
                                              "Reports will be generated after 90 days from starting date.",
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Visibility(
                                        visible: status == 'Ongoing',
                                        child: SizedBox(height: 3.sp),
                                      ),
                                      Divider(
                                        thickness: 0.7.sp,
                                        color: AppColors.black,
                                      ),
                                      SizedBox(height: 3.sp),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            text: 'Duration:',
                                            fontSize: 13.5.sp,
                                            color: AppColors.grey,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          SizedBox(width: 5.sp),
                                          Expanded(
                                            child: CustomText(
                                              text: formatDuration(
                                                durationDate,
                                                endDate,
                                              ),
                                              fontSize: 13.sp,
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15.sp),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              provider.studentId = widget
                                                  .student
                                                  .studentId
                                                  .toString();
                                              provider.trimesterId =
                                                  trimesters[index].trimesterId
                                                      .toString();
                                              provider.startDate = durationDate;
                                              provider.endDate = endDate!;

                                              if (buttonText ==
                                                      'Generate Report' &&
                                                  status == 'Completed') {
                                                // 👉 Open Learning Area Report
                                                NavigationHelper.push(
                                                  context,
                                                  LearningAreaReportView(
                                                    studentId: widget
                                                        .student
                                                        .studentId
                                                        .toString(),
                                                    studentName: widget
                                                        .student
                                                        .studentName
                                                        .toString(),
                                                  ),
                                                );
                                              } else if (buttonText ==
                                                      'View Report' &&
                                                  status == 'Completed') {
                                                final success = await provider
                                                    .getTrimesterReportPDFData(
                                                      context,
                                                      widget.student.studentId
                                                          .toString(),widget.student.trimester![index].trimesterId.toString()
                                                    );

                                                if (!context.mounted) return;

                                                if (success &&
                                                    provider.trimesterReportData !=
                                                        null &&
                                                    provider
                                                        .trimesterReportData!
                                                        .isNotEmpty) {
                                                  NavigationHelper.pushFullScreen(
                                                    context,
                                                    const PdfPreviewFullScreen(),
                                                  );
                                                } else {
                                                  showSnackBar(
                                                    "Failed to load profile",
                                                    context,
                                                  );
                                                }
                                              } else {
                                                // 👉 For other statuses
                                                showSnackBar(
                                                  "Report will be shown after some time",
                                                  context,
                                                );
                                              }
                                            },
                                            child: CustomContainer(
                                              text: buttonText,
                                              borderRadius: 10.r,
                                              containerColor:
                                                  status == 'Ongoing'
                                                  ? buttonColor.withOpacity(0.5)
                                                  : buttonColor,
                                              textAlign: TextAlign.center,
                                              innerPadding:
                                                  EdgeInsets.symmetric(
                                                    vertical: 7.sp,
                                                    horizontal: 15.sp,
                                                  ),
                                              padding: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

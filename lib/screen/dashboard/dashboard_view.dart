import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/custom_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dashboard_provider.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final tooltip = TooltipBehavior(enable: true);

    return ChangeNotifierProvider(
      create: (_) => DashboardProvider()
        ..loadCachedWeekGoalData()
        ..getDashboardWeekData()
        ..loadCachedLongGoalData()
        ..getDashboardLongGoalData()
        ..loadCachedStudentListData()
        ..getDashboardStudentListData(),
      child: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          final List<_ChartData> weekChartData = [];
          final List<_ChartData> longChartData = [];
          final List<Color> colors = [AppColors.green, AppColors.yellow, AppColors.red];

          /// --- Weekly Goal Data ---
          if (provider.weekData != null) {
            for (int i = 0; i < provider.weekData!.length; i++) {
              final week = provider.weekData![i];
              weekChartData.add(
                _ChartData(
                  'Week ${week.weekCount ?? (i + 1)}',
                  week.completionPercentage ?? 0,
                  colors[i % colors.length],
                ),
              );
            }
          }

          /// --- Long Goal Data ---
          if (provider.longGoalData != null) {
            for (int i = 0; i < provider.longGoalData!.length; i++) {
              final goal = provider.longGoalData![i];
              longChartData.add(
                _ChartData(
                  'Goal ${goal.goalCount ?? (i + 1)}',
                  goal.completionPercentage ?? 0,
                  colors[i % colors.length],
                ),
              );
            }
          }

          return Container(
            color: AppColors.themeColor,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: AppColors.white,
                appBar: CustomAppBar(enableTheming: false),
                body: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.sp,
                      horizontal: 10.sp,
                    ),
                    child: Column(
                      children: [
                        /// --- Header Row ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "Dashboard",
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'DMSerif',
                              color: AppColors.themeColor,
                            ),
                            CustomContainer(
                              text: "Add Student",
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Inter',
                              borderRadius: 15,
                              innerPadding: EdgeInsets.symmetric(
                                vertical: 4.sp,
                                horizontal: 10.sp,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10.sp),

                        /// --- Weekly Goal Report ---
                        _buildChartSection(
                          title: 'Weekly Goal Report',
                          chartData: weekChartData,
                          tooltip: tooltip,
                          yMax: 100,
                        ),

                        SizedBox(height: 20.sp),

                        /// --- Long Goal Report ---
                        _buildChartSection(
                          title: 'Long Goal Report',
                          chartData: longChartData,
                          tooltip: tooltip,
                          yMax: 100,
                        ),

                        SizedBox(height: 20.sp),

                        provider.studentData != null &&
                            provider.studentData!.isNotEmpty
                            ? Column(
                          children: provider.studentData!
                              .map(
                                (student) => CustomViewCard(
                              student: student,
                              onViewPressed: () {
                                debugPrint(
                                    'Viewing student: ${student.studentName}');
                              },
                            ),
                          )
                              .toList(),
                        )
                            : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CustomText(
                            text: "No student data available",
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),

                        SizedBox(height: 30.sp),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// --- Chart Section Builder ---
  Widget _buildChartSection({
    required String title,
    required List<_ChartData> chartData,
    required TooltipBehavior tooltip,
    required double yMax,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          /// Title Bar
          Container(
            width: double.infinity,
            height: 55.sp,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomText(
                  text: title,
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ),

          /// Chart or Empty State
          chartData.isEmpty
              ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomText(
              text: "No data available",
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          )
              : SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: yMax,
              interval: 20,
            ),
            tooltipBehavior: tooltip,
            series: <CartesianSeries<_ChartData, String>>[
              ColumnSeries<_ChartData, String>(
                dataSource: chartData,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                pointColorMapper: (_ChartData data, _) => data.color,
                name: 'Completion %',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Chart Data Model
class _ChartData {
  _ChartData(this.x, double? y, this.color) : y = y ?? 0;
  final String x;
  final double y;
  final Color color;
}

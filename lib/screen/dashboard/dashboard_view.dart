import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/custom_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_ChartData> goldData = [
      _ChartData('CHN', 12),
      _ChartData('GER', 15),
      _ChartData('RUS', 30),
      _ChartData('BRZ', 6.4),
      _ChartData('IND', 14),
    ];

    final TooltipBehavior tooltip = TooltipBehavior(enable: true);

    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomAppBar(enableTheming: false),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.sp, horizontal: 10.sp),
              child: Column(
                children: [
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
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: AppColors.borderColor),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 55.sp,
                          decoration: BoxDecoration(
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
                                text: 'Weakly Goal Report',
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ),
                        SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          primaryYAxis: NumericAxis(
                            minimum: 0,
                            maximum: 40,
                            interval: 10,
                          ),
                          tooltipBehavior: tooltip,
                          series: <CartesianSeries<_ChartData, String>>[
                            ColumnSeries<_ChartData, String>(
                              dataSource: goldData,
                              xValueMapper: (_ChartData data, _) => data.x,
                              yValueMapper: (_ChartData data, _) => data.y,
                              name: 'Gold',
                              color: const Color.fromRGBO(8, 142, 255, 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.sp),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: AppColors.borderColor),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 55.sp,
                          decoration: BoxDecoration(
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
                                text: 'Weakly Goal Report',
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ),
                        SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          primaryYAxis: NumericAxis(
                            minimum: 0,
                            maximum: 40,
                            interval: 10,
                          ),
                          tooltipBehavior: tooltip,
                          series: <CartesianSeries<_ChartData, String>>[
                            ColumnSeries<_ChartData, String>(
                              dataSource: goldData,
                              xValueMapper: (_ChartData data, _) => data.x,
                              yValueMapper: (_ChartData data, _) => data.y,
                              name: 'Gold',
                              color: const Color.fromRGBO(8, 142, 255, 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.sp,),
                  CustomViewCard(),
                  SizedBox(height: 30.sp,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}

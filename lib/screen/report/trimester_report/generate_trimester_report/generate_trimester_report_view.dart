import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/screen/report/report_dashboard_provider.dart';
import 'package:special_education/screen/report/trimester_report/generate_trimester_report/generate_trimester_report_data_modal.dart';
import 'package:special_education/screen/report/trimester_report/trimester_report_data_model.dart';


class GenerateTrimesterReportView extends StatefulWidget {
  final String studentName;
  final String studentId;

  const GenerateTrimesterReportView({
    super.key,
    required this.studentName,
    required this.studentId,
  });

  @override
  State<GenerateTrimesterReportView> createState() =>
      _GenerateTrimesterReportViewState();
}

class _GenerateTrimesterReportViewState
    extends State<GenerateTrimesterReportView> {
  late ReportDashboardProvider _provider;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _provider = Provider.of<ReportDashboardProvider>(context, listen: false);
      _fetchData();
      _initialized = true;
    }
  }

  Future<void> _fetchData() async {
    // You may want to show errors using ScaffoldMessenger in the provider,
    // but here we call the provider methods and react to bool result if needed.
    final bool trimesterOk =
    await _provider.getTrimesterReportData(context, widget.studentId);
    final bool learningOk =
    await _provider.getLearningAreasData(context, widget.studentId);

    // If both failed, show a message (optional)
    if (!trimesterOk && !learningOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load report data.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: CustomAppBar(enableTheming: false),
          body: Column(
            children: [
              CustomHeaderView(
                courseName: widget.studentName,
                moduleName: "Learning Areas",
              ),
              Consumer<ReportDashboardProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.error != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              provider.error!,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => _fetchData(),
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final trimester = provider.trimesterReportData;
                  final learningAreas = provider.learningAreasData;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Trimester reports: ${trimester?.length ?? 0}",

                        ),
                        const SizedBox(height: 8),
                        if (trimester != null && trimester.isNotEmpty)
                          ...trimester.map((t) => _buildTrimesterTile(t)).toList()
                        else
                          const Text("No trimester data available."),

                        const SizedBox(height: 16),
                        Text(
                          "Learning areas: ${learningAreas?.length ?? 0}",

                        ),
                        const SizedBox(height: 8),
                        if (learningAreas != null && learningAreas.isNotEmpty)
                          ...learningAreas
                              .map((l) => _buildLearningAreaTile(l))
                              .toList()
                        else
                          const Text("No learning areas data available."),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrimesterTile(TrimesterReportDataModal t) {
    // Adapt as per your model fields
    return Card(
      child: ListTile(
        title: Text(t.studentName ?? "Trimester item"),
        subtitle: Text(t.studentId.toString() ?? ""),
      ),
    );
  }

  Widget _buildLearningAreaTile(TrimesterGenerateReportDataModel l) {
    // Adapt as per your model fields
    return Card(
      child: ListTile(
        title: Text(l.selectedStar.toString() ?? "Learning area"), // replace with real field
        subtitle: Text(l.qualityId.toString() ?? ""), // replace with real field
      ),
    );
  }
}

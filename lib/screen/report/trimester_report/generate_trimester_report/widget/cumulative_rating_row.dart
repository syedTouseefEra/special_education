import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/screen/report/trimester_report/performance_report/widget/progress_bar_widget.dart';

class CumulativeRatingRow extends StatefulWidget {
  final int initial;
  final ValueChanged<int>? onChanged;

  const CumulativeRatingRow({super.key, this.initial = 0, this.onChanged});

  @override
  State<CumulativeRatingRow> createState() => _CumulativeRatingRowState();
}

class _CumulativeRatingRowState extends State<CumulativeRatingRow> {
  late int selected;

  final List<Color> ratingColors = [
    const Color(0xFFFF0000), // 1 - Red
    const Color(0xFFFF7A00), // 2 - Orange
    const Color(0xFFFFD100), // 3 - Yellow
    const Color(0xFF2ECC40), // 4 - Light Green
    const Color(0xFF007F00), // 5 - Dark Green
  ];

  @override
  void initState() {
    super.initState();
    selected = widget.initial.clamp(0, 5);
  }

  @override
  Widget build(BuildContext context) {
    double circleDiameter = 22.sp;
    const double circleSpacing = 0.0; // gap between circle and segment (both sides)
    const double segmentHeight = 8.0;
    const double minSegmentWidth = 0.0; // don't shrink segments too small

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;

        // There are 5 circles and 4 segments
        const int circleCount = 5;
        const int segmentCount = circleCount - 1;

        // total space taken by the circles
        final double totalCircleWidth = circleCount * circleDiameter;

        // total horizontal margins between circle and segments:
        // each segment has margins on its two sides but since segments are between circles,
        // for simplicity assume circleSpacing * segmentCount (gap between circle and segment on each side summed)
        final double totalMargins = segmentCount * circleSpacing;

        // Compute available width for all segments combined
        double availableForSegments =
            maxWidth - totalCircleWidth - totalMargins;

        // If some padding or internal parent paddings exist, you might subtract them too.
        // Protect against negative value
        if (availableForSegments < (segmentCount * minSegmentWidth)) {
          availableForSegments = segmentCount * minSegmentWidth;
        }

        final double segmentWidth = (availableForSegments / segmentCount)
            .clamp(minSegmentWidth, availableForSegments);

        // Build children sequentially: circle, segment, circle, segment, ...
        final List<Widget> children = <Widget>[];

        for (int i = 0; i < circleCount; i++) {
          children.add(
            GestureDetector(
              onTap: () {
                setState(() {
                  selected = i + 1;
                });
                if (widget.onChanged != null) widget.onChanged!(selected);
              },
              child: SizedBox(
                width: circleDiameter,
                height: circleDiameter,
                child: ProgressBar(
                  text: '${i + 1}',
                  color: ratingColors[i],
                  isSelected: selected == i + 1,
                  onTap: () {
                    setState(() {
                      selected = i + 1;
                    });
                    if (widget.onChanged != null) widget.onChanged!(selected);
                  },
                ),
              ),
            ),
          );

          // Add segment after the circle, except after the last circle
          if (i < circleCount - 1) {
            children.add(
              // add margin around segment using SizedBox
              Container(
                margin: EdgeInsets.symmetric(horizontal: circleSpacing / 2),
                width: segmentWidth,
                height: segmentHeight,
                decoration: BoxDecoration(
                  color: (i < selected - 1)
                      ? ratingColors[selected - 1] // cumulative fill color
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(segmentHeight / 2),
                ),
              ),
            );
          }
        }

        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        );
      },
    );
  }

}

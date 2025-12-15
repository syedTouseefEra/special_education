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

  final List<Color> ratingColors = const [
    Color(0xFFFF0000), // 1 - Red
    Color(0xFFFF7A00), // 2 - Orange
    Color(0xFFFFD100), // 3 - Yellow
    Color(0xFF2ECC40), // 4 - Light Green
    Color(0xFF007F00), // 5 - Dark Green
  ];

  @override
  void initState() {
    super.initState();
    selected = widget.initial.clamp(0, 5);
  }

  List<Color> _segmentGradientColorsForSelected() {
    switch (selected) {
      case 2:
      // 2 -> #FD292D and #F17020
        return const [Color(0xFFFD292D), Color(0xFFF17020)];
      case 3:
      // 3 -> #FD292D , #F17020 and #F1B920
        return const [Color(0xFFFD292D), Color(0xFFF17020), Color(0xFFF1B920)];
      case 4:
      // 4 -> #FD292D , #F17020 , #F1B920 and #14C744
        return const [
          Color(0xFFFD292D),
          Color(0xFFF17020),
          Color(0xFFF1B920),
          Color(0xFF14C744),
        ];
      case 5:
      // 5 -> #FD292D , #F17020 , #F1B920 , #14C744 and #006019
        return const [
          Color(0xFFFD292D),
          Color(0xFFF17020),
          Color(0xFFF1B920),
          Color(0xFF14C744),
          Color(0xFF006019),
        ];
      default:
      // for 0 or 1 we won't use gradient (only grey bar)
        return const [Color(0xFFE9E9E9), Color(0xFFE9E9E9)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final double circleDiameter = 22.sp;
    const double trackHeight = 8.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;

        const int circleCount = 5;

        // Track runs from center of first circle to center of last circle
        final double trackInset = circleDiameter / 2;

        // Total drawable track width between first and last circle centers
        final double fullTrackWidth = maxWidth - (2 * trackInset);

        // Fraction of the track to fill (0 for 0/1, 1.0 for 5)
        final double fillFraction =
        selected <= 1 ? 0 : (selected - 1) / (circleCount - 1);

        // Stops for the gradient (evenly spaced)
        final gradientColors = _segmentGradientColorsForSelected();
        final List<double> stops = List.generate(
          gradientColors.length,
              (index) =>
          gradientColors.length == 1
              ? 1.0
              : index / (gradientColors.length - 1),
        );

        return SizedBox(
          width: maxWidth,
          height: circleDiameter,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Base grey track behind everything
              Positioned(
                left: trackInset,
                right: trackInset,
                top: (circleDiameter - trackHeight) / 2,
                child: Container(
                  height: trackHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9E9E9),
                    borderRadius: BorderRadius.circular(trackHeight / 2),
                  ),
                ),
              ),

              // Colored filled part from 1 to selected
              if (fillFraction > 0)
                Positioned(
                  left: trackInset,
                  top: (circleDiameter - trackHeight) / 2,
                  child: Container(
                    width: fullTrackWidth * fillFraction,
                    height: trackHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(trackHeight / 2),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: gradientColors,
                        stops: stops,
                      ),
                    ),
                  ),
                ),

              // Circles on top
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(circleCount, (index) {
                  final int value = index + 1;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = value;
                      });
                      widget.onChanged?.call(selected);
                    },
                    child: SizedBox(
                      width: circleDiameter,
                      height: circleDiameter,
                      child: ProgressBar(
                        text: '$value',
                        color: ratingColors[index],
                        isSelected: selected == value,
                        onTap: () {
                          setState(() {
                            selected = value;
                          });
                          widget.onChanged?.call(selected);
                        },
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

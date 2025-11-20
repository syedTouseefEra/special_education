import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/assets.dart';

class InteractiveStarRating extends StatefulWidget {
  final int apiStarCount;
  final int maxDisplay;
  final double size;
  final ValueChanged<int>? onChanged;
  final bool showInitialFilled;

  const InteractiveStarRating({
    super.key,
    required this.apiStarCount,
    this.maxDisplay = 10,
    this.size = 20,
    this.onChanged,
    this.showInitialFilled = false,
  });

  @override
  State<InteractiveStarRating> createState() => _InteractiveStarRatingState();
}

class _InteractiveStarRatingState extends State<InteractiveStarRating> {
  late final int totalStars;
  late int selectedCount;

  @override
  void initState() {
    super.initState();

    final int raw = widget.apiStarCount;
    final int capped = raw.clamp(0, widget.maxDisplay);
    totalStars = (capped >= 5 || raw > 0) ? capped : 5;
    selectedCount = widget.showInitialFilled ? raw.clamp(0, totalStars) : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalStars, (index) {
        final bool isFilled = index < selectedCount;
        return GestureDetector(
          onTap: () {
            final int newCount = index + 1;
            setState(() => selectedCount = newCount);
            if (widget.onChanged != null) widget.onChanged!(newCount);
          },
          child: Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Image.asset(
              isFilled ? ImgAssets.yellowStar : ImgAssets.greyStar,
              width: widget.size.w,
            ),
          ),
        );
      }),
    );
  }
}

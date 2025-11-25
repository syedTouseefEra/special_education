import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/assets.dart';

class InteractiveStarRating extends StatefulWidget {
  /// total number of stars (JSON: star)
  final int star;

  /// initially filled yellow stars (JSON: selectedStar)
  final int selectedStar;

  final double size;
  final ValueChanged<int>? onChanged;

  const InteractiveStarRating({
    super.key,
    required this.star,
    required this.selectedStar,
    this.size = 20,
    this.onChanged,
  });

  @override
  State<InteractiveStarRating> createState() => _InteractiveStarRatingState();
}

class _InteractiveStarRatingState extends State<InteractiveStarRating> {
  late int filledStars;

  @override
  void initState() {
    super.initState();
    // number of yellow stars at start (cannot be less than 0 or more than total)
    filledStars = widget.selectedStar.clamp(0, widget.star);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.star, (index) {
        // all stars up to `filledStars` are yellow
        final bool isFilled = index < filledStars;

        return GestureDetector(
          onTap: () {
            final int newValue = index + 1; // 1..star
            setState(() => filledStars = newValue);
            widget.onChanged?.call(newValue);
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

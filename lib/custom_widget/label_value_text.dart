
import 'package:flutter/material.dart';
import 'package:special_education/utils/text_case_utils.dart';

class LabelValueText extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final bool isRow;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final TextCase? labelCase;
  final TextCase? valueCase;

  const LabelValueText({
    super.key,
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.isRow = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.spacing = 4.0,
    this.labelCase,
    this.valueCase,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Text(applyTextCase(label, labelCase), style: labelStyle),
      SizedBox(width: isRow ? spacing : 0, height: isRow ? 0 : spacing),
      Flexible(
        fit: FlexFit.loose,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Text(
            textAlign: TextAlign.end,
            applyTextCase(value, valueCase),
            style: valueStyle,
          ),
        ),
      ),
    ];

    return isRow
        ? Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    )
        : Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}


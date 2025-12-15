
import 'package:flutter/material.dart';
import 'package:special_education/utils/text_case_utils.dart';

class LabelValueText extends StatelessWidget {
  final String label;
  final dynamic value;
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
    final Widget valueWidget;

    if (value is String) {
      valueWidget = Text(
        applyTextCase(value as String, valueCase),
        style: valueStyle,
        textAlign: TextAlign.end,
      );
    }
    else if (value is Widget) {
      valueWidget = value as Widget;
    }
    else {
      valueWidget = Text(
        value.toString(),
        style: valueStyle,
        textAlign: TextAlign.end,
      );
    }

    final children = <Widget>[
      Text(applyTextCase(label, labelCase), style: labelStyle),

      SizedBox(width: isRow ? spacing : 0, height: isRow ? 0 : spacing),

      Flexible(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: valueWidget,
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
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}



import 'package:flutter/material.dart';

class AutoHideTextGroup extends StatelessWidget {
  final String? primaryText;
  final String? secondaryText;
  final TextStyle? primaryStyle;
  final TextStyle? secondaryStyle;
  final int maxLines;

  const AutoHideTextGroup({
    super.key,
    required this.primaryText,
    required this.secondaryText,
    this.primaryStyle,
    this.secondaryStyle,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final defaultStyle = DefaultTextStyle.of(context).style;

        final primarySpan = TextSpan(
          text: primaryText,
          style: primaryStyle ?? defaultStyle,
        );
        final secondarySpan = TextSpan(
          text: secondaryText,
          style: secondaryStyle ?? defaultStyle,
        );

        final primaryPainter = TextPainter(
          text: primarySpan,
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final secondaryPainter = TextPainter(
          text: secondarySpan,
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final bothFit =
            !primaryPainter.didExceedMaxLines &&
            !secondaryPainter.didExceedMaxLines;

        return bothFit
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  primaryText ?? 'Loading...',
                  style: primaryStyle,
                  maxLines: maxLines,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                ),
                Text(
                  secondaryText ?? 'Loading...',
                  style: secondaryStyle,
                  maxLines: maxLines,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                ),
              ],
            )
            : const SizedBox.shrink();
      },
    );
  }
}

import 'package:dishedout/models/user_model.dart';
import 'package:dishedout/shared/widgets/Avatar.dart';
import 'package:flutter/material.dart';

class AutoHideTextGroup extends StatelessWidget {
  final UserModel? user;
  final String? primaryText;
  final String? secondaryText;
  final TextStyle? primaryStyle;
  final TextStyle? secondaryStyle;
  final int maxLines;

  const AutoHideTextGroup({
    super.key,
    required this.user,
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

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child:
              bothFit
                  ? Column(
                    key: const ValueKey(true),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        primaryText ?? 'Loading...',
                        style: primaryStyle,
                        maxLines: maxLines,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      Row(
                        children: [
                          Avatar(user: user, radius: 14),
                          SizedBox(width: 7),
                          Text(
                            secondaryText ?? 'Loading...',
                            style: secondaryStyle,
                            maxLines: maxLines,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                        ],
                      ),
                    ],
                  )
                  : const SizedBox(key: ValueKey(false)),
        );
      },
    );
  }
}

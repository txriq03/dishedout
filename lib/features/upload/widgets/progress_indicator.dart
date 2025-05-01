import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double previousProgress;
  final double currentProgress;

  const ProgressIndicatorWidget({
    super.key,
    required this.previousProgress,
    required this.currentProgress,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: previousProgress, end: currentProgress),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return LinearProgressIndicator(
          semanticsLabel: 'Progress',
          semanticsValue: currentProgress.toString(),
          borderRadius: BorderRadius.circular(15),
          value: value,
          color: Colors.deepOrange.shade400,
          backgroundColor: Colors.grey[900],
        );
      },
    );
  }
}

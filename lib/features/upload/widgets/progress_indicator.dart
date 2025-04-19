import 'package:flutter/material.dart';

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 15,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: previousProgress, end: currentProgress),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey[900],
              color: Colors.deepOrange,
            );
          },
        ),
      ),
    );
  }
}

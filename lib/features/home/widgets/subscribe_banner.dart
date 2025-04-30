import 'package:flutter/material.dart';

class SubscribeBanner extends StatelessWidget {
  const SubscribeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Text('Become a premium member', style: TextStyle(fontSize: 18)),
    );
  }
}

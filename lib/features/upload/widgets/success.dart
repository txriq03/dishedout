import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondaryContainer.withAlpha(100),
                  blurRadius: 25,
                ),
              ],
            ),
            child: Icon(Icons.check_rounded, color: Colors.black, size: 50),
          ),
          SizedBox(height: 20),
          Text("Upload Successful", style: TextStyle(fontSize: 21)),
        ],
      ),
    );
  }
}

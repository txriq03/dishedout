import 'package:flutter/material.dart';

class UserUploads extends StatefulWidget {
  const UserUploads({super.key});

  @override
  State<UserUploads> createState() => _UserUploadsState();
}

class _UserUploadsState extends State<UserUploads> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[900],
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }
}

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
            width: 250,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[900],
              image: DecorationImage(
                image: AssetImage(
                  'assets/pancake.jpg',
                ), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Add a gradient overlay at the bottom
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 60, // Adjust the height of the dark overlay
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(
                          12,
                        ), // Match the container's border radius
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 1),
                        ],
                      ),
                    ),
                  ),
                ),
                // Add text on top of the gradient
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Product name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 10),
          Container(
            width: 250,
            height: 300,
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

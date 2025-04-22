import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishedout/features/product/screens/product_page.dart';
import 'package:dishedout/services/user_service.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String uid;
  final UserService _userService = UserService(FirebaseFirestore.instance);

  PostCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductPage()),
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Icon(Icons.error, color: Colors.red));
            },
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.8), // Dark gradient color
                  Colors.transparent, // Transparent color
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                FutureBuilder<String?>(
                  future: _userService.getDisplayName(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        'Loading user...',
                        softWrap: false,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 16,
                          overflow: TextOverflow.clip,
                        ),
                      );
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return const Text(
                        'Unknown user',
                        softWrap: false,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 16,
                          overflow: TextOverflow.clip,
                        ),
                      );
                    }
                    return Text(
                      snapshot.data ?? 'Unknown user',
                      softWrap: false,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 16,
                        overflow: TextOverflow.clip,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

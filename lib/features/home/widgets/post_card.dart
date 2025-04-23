import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishedout/features/product/screens/product_page.dart';
import 'package:dishedout/models/post_model.dart';
import 'package:dishedout/models/user_model.dart';
import 'package:dishedout/services/user_service.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final Post post;
  // final UserService _userService = UserService(FirebaseFirestore.instance);
  PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  UserModel? user;
  final UserService userService = UserService(FirebaseFirestore.instance);

  @override
  initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final fetchedUser = await userService.getUser(widget.post.uid);
    setState(() {
      user = fetchedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(post: widget.post, user: user),
          ),
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            widget.post.imageUrl,
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
                  widget.post.name,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                // Show display name
                Text(
                  user?.displayName ?? 'Loading...',
                  softWrap: false,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 16,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

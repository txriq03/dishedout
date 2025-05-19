import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishedout/features/home/widgets/post_card.dart';
import 'package:dishedout/models/post_model.dart';
import 'package:dishedout/services/post_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UploadsCarousel extends StatefulWidget {
  const UploadsCarousel({super.key});

  @override
  State<UploadsCarousel> createState() => _UploadsCarouselState();
}

class _UploadsCarouselState extends State<UploadsCarousel> {
  final CarouselController controller = CarouselController(initialItem: 0);
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  late final PostService _postService = PostService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: _postService.getPosts(), // Get list of posts
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          ); // Show loading indicator
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading posts: ${snapshot.error}'),
          ); // Show error message
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // If posts are empty
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
            child: Center(
              child: Text(
                'No posts available :(',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
          );
        }

        final posts = snapshot.data!;

        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400, minHeight: 200),
          child: CarouselView(
            itemExtent: 250,
            shrinkExtent: 250,
            controller: controller,
            children:
                posts.map((post) {
                  return PostCard(post: post);
                }).toList(),
          ),
        );
      },
    );
  }
}

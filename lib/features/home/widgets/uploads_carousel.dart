import 'package:dishedout/features/home/widgets/post_card.dart';
import 'package:dishedout/models/post.dart';
import 'package:dishedout/services/post_service.dart';
import 'package:flutter/material.dart';

class UploadsCarousel extends StatefulWidget {
  const UploadsCarousel({super.key});

  @override
  State<UploadsCarousel> createState() => _UploadsCarouselState();
}

class _UploadsCarouselState extends State<UploadsCarousel> {
  final CarouselController controller = CarouselController(initialItem: 0);
  final PostService _postService = PostService();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return ConstrainedBox(
    //   constraints: const BoxConstraints(maxHeight: 400, minHeight: 200),
    //   child: CarouselView.weighted(
    //     controller: controller,
    //     itemSnapping: true,
    //     flexWeights: [8, 2],
    //     children: [
    //       Image.asset('assets/pancake.jpg', fit: BoxFit.cover),
    //       Image.asset('assets/meat.jpg', fit: BoxFit.cover),
    //       Image.asset('assets/spices.jpg', fit: BoxFit.cover),
    //     ],
    //   ),
    // );
    return FutureBuilder<List<Post>>(
      future: _postService.getPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading posts: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No posts available'));
        }

        final posts = snapshot.data!;

        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400, minHeight: 200),
          child: CarouselView.weighted(
            controller: controller,
            itemSnapping: true,
            flexWeights: [8, 2],
            children:
                posts.map((post) {
                  return PostCard(
                    imageUrl: post.imageUrl,
                    title: post.name,
                    description: post.description,
                    uid: post.uid,
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}

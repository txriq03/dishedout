import 'package:dishedout/features/home/widgets/autohide_text_group.dart';
import 'package:dishedout/features/product/screens/product_page.dart';
import 'package:dishedout/models/post_model.dart';
import 'package:dishedout/models/user_model.dart';
import 'package:dishedout/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  UserModel? user;
  final UserService userService = UserService();

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
          Hero(
            tag: 'post-image-${widget.post.id}',
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: widget.post.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.7), // Dark gradient color
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
                AutoHideTextGroup(
                  user: user,
                  primaryText: widget.post.name,
                  secondaryText: user?.displayName,
                  primaryStyle: TextStyle(fontSize: 24),
                  secondaryStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.5),
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

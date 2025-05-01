import 'package:dishedout/models/post_model.dart';
import 'package:dishedout/models/user_model.dart';
import 'package:dishedout/services/post_service.dart';
import 'package:dishedout/shared/widgets/avatar.dart';
import 'package:dishedout/shared/widgets/live_tracking_map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductPage extends StatefulWidget {
  final Post post;
  final UserModel? user;

  const ProductPage({super.key, required this.post, required this.user});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late String postStatus;
  final PostService postService = PostService();

  @override
  void initState() {
    super.initState();
    postStatus = widget.post.status;
  }

  Future<void> onClaimItem(BuildContext context) async {
    final LatLng lenderLocation = LatLng(
      widget.post.latitude,
      widget.post.longitude,
    );

    await postService.claimItem(context, widget.post);
    setState(() {
      postStatus = 'claimed';
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveTrackingMap(lenderLocation: lenderLocation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: ElevatedButton(
          onPressed:
              postStatus == 'available' ? () => onClaimItem(context) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            postStatus == 'available'
                ? 'Claim item'
                : postStatus == 'claimed'
                ? 'Claimed'
                : 'Unavailable',
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(forceMaterialTransparency: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 400,
                width: double.infinity,
                child: Hero(
                  tag: 'post-image-${widget.post.id}',
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: widget.post.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 400,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(
                        context,
                      ).scaffoldBackgroundColor.withValues(alpha: 1),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                ),
                Text(
                  widget.post.description,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Posted by',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Avatar(user: widget.user),
                          SizedBox(width: 10),
                          Text(
                            widget.user!.displayName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        color: Theme.of(context).colorScheme.primary,
                        icon: Icon(Icons.call_rounded),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        color: Theme.of(context).colorScheme.primary,
                        icon: Icon(Icons.chat_rounded),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

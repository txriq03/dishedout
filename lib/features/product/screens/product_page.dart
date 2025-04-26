import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishedout/models/post_model.dart';
import 'package:dishedout/models/user_model.dart';
import 'package:dishedout/services/post_service.dart';
import 'package:dishedout/shared/widgets/avatar.dart';
import 'package:dishedout/shared/widgets/live_tracking_map.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProductPage extends StatelessWidget {
  final Post post;
  final UserModel? user;
  final postService = PostService(
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
  );

  ProductPage({super.key, required this.post, required this.user});

  void claimItem(BuildContext context) async {
    final LatLng lenderLocation = LatLng(post.latitude, post.longitude);

    await postService.updateStatus(context, post.id, 'claimed');

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
          onPressed: () {
            claimItem(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text('Claim item'),
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
                child: Image.network(
                  post.imageUrl,
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
                    return const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    );
                  },
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
                  post.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                ),
                Text(
                  post.description,
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
                          Avatar(user: user),
                          SizedBox(width: 10),
                          Text(
                            user!.displayName,
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

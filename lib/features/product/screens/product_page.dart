import 'package:dishedout/models/post_model.dart';
import 'package:dishedout/shared/widgets/Avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductPage extends StatelessWidget {
  final Post post;
  const ProductPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor:
            Theme.of(context).bottomSheetTheme.backgroundColor,
      ),
    );
    return Scaffold(
      bottomSheet: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: ElevatedButton(
          onPressed: () {},
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
                // Avatar(user: post.user),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

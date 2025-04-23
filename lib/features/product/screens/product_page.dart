import 'package:dishedout/models/post.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final Post post;
  const ProductPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(forceMaterialTransparency: true),
      body: Column(
        children: [
          Container(
            height: 250,
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
        ],
      ),
    );
  }
}

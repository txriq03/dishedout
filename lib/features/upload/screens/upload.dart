import 'package:dishedout/features/upload/widgets/image_upload.dart';
import 'package:flutter/material.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 15,
                  child: LinearProgressIndicator(
                    value: 0.2,
                    backgroundColor: Colors.grey[900],
                    color: Colors.deepOrange,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(child: ImageUpload()),
            ],
          ),
        ),
      ),
    );
  }
}

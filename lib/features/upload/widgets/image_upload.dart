import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:io';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.shortestSide;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Upload Image',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _image != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _image!,
                      height: size,
                      width: size,
                      fit: BoxFit.cover,
                    ),
                  )
                  : GestureDetector(
                    onTap: _captureImage,
                    child: SizedBox(
                      width: size,
                      height: size,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        color: Colors.grey[800]!,
                        dashPattern: [6, 3],
                        radius: const Radius.circular(12),
                        strokeWidth: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: size * 0.2,
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                                Text(
                                  'Tap to take photo',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white.withValues(alpha: 0.3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _captureImage,
                child: const Text('Capture from Camera'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 50,
        width: 50,
        child: FloatingActionButton(
          onPressed: () {
            // Handle upload action here
          },
          shape: const CircleBorder(side: BorderSide.none),
          backgroundColor:
              _image != null
                  ? Colors.deepOrange.shade300.withValues(alpha: 0.3)
                  : Colors.grey[900],
          foregroundColor:
              _image != null ? Colors.deepOrange : Colors.grey[800],
          disabledElevation: 0,
          child: const Icon(Icons.chevron_right_rounded, size: 24.0),
        ),
      ),
    );
  }
}

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
    return Center(
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
              ? Image.file(_image!, height: 200, width: 200, fit: BoxFit.cover)
              : DottedBorder(
                borderType: BorderType.RRect,
                color: Colors.grey[800]!,
                dashPattern: [6, 3],
                radius: const Radius.circular(12),
                strokeWidth: 2,
                child: Container(
                  width: size,
                  height: size - 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
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
    );
  }
}

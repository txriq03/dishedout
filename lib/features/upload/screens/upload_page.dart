import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishedout/features/upload/widgets/image_upload.dart';
import 'package:dishedout/features/upload/widgets/progress_indicator.dart';
import 'package:dishedout/features/upload/widgets/success.dart';
import 'package:dishedout/features/upload/widgets/upload_form.dart';
import 'package:dishedout/services/post_service.dart';
import 'package:dishedout/shared/widgets/navbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';

// Enum for handling what step of upload we use
enum Step { takePhoto, fillForm, success }

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  Step _currentStep = Step.takePhoto;
  File? _image;
  double _previousProgress = 0.0;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final PostService _postService = PostService();

  // Address field variables
  double? _lat;
  double? _lng;
  final TextEditingController _addressController = TextEditingController();

  // Form key and controllers for the form step
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Widget with loading indicator for when user uploads a post
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // Submit post to Firestore
  void _submitPost() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();
      final addressDescription = _addressController.text.trim();
      final lat = _lat;
      final lng = _lng;
      if (_image != null) {
        _showLoadingDialog(context); // Show loading dialog

        await _postService.uploadPost(
          imageFile: _image!,
          name: name,
          description: description,
          addressDescription: addressDescription,
          lat: lat,
          lng: lng,
        );
        setState(() {
          _currentStep = Step.success;
        });
      }

      Navigator.of(context).pop(); // Close loading dialog

      // Navigate to the home page after successful upload
      if (_currentStep == Step.success) {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Navbar()),
          );
        });
      }
    }
  }

  void _nextStep() {
    _previousProgress = _getProgress();
    setState(() {
      switch (_currentStep) {
        case Step.takePhoto:
          _currentStep = Step.fillForm;
          break;
        case Step.fillForm:
          _submitPost();
          break;
        case Step.success:
          break;
      }
    });
  }

  double _getProgress() {
    switch (_currentStep) {
      case Step.takePhoto:
        return 0.33;
      case Step.fillForm:
        return 0.66;
      case Step.success:
        return 1.0;
    }
  }

  // Callback to update _image variable
  void _updateImage(File? image) {
    setState(() {
      _image = image;
    });
  }

  // What widget is shown based on the current step
  Widget _getStepWidget() {
    switch (_currentStep) {
      case Step.takePhoto:
        return ImageUpload(onImageSelected: _updateImage);
      case Step.fillForm:
        return UploadForm(
          formKey: _formKey,
          nameController: _nameController,
          descriptionController: _descriptionController,
          lat: _lat,
          lng: _lng,
          addressController: _addressController,
          onLatLngChanged: (newLat, newLng) {
            setState(() {
              _lat = newLat;
              _lng = newLng;
            });
          },
        );
      case Step.success:
        return SuccessPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor:
            Theme.of(context).colorScheme.surfaceContainer,
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            children: [
              ProgressIndicatorWidget(
                previousProgress: _previousProgress,
                currentProgress: _getProgress(),
              ),
              const SizedBox(height: 20),
              Expanded(child: _getStepWidget()),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child:
            _currentStep != Step.success
                ? FloatingActionButton(
                  onPressed: _image != null ? _nextStep : null,
                  elevation: 0,
                  shape: const CircleBorder(side: BorderSide.none),
                  backgroundColor:
                      _image != null
                          ? Colors.deepOrange.shade300.withValues(alpha: 0.3)
                          : Colors.grey[900],
                  foregroundColor:
                      _image != null ? Colors.deepOrange : Colors.grey[800],
                  child: const Icon(Icons.chevron_right_rounded, size: 24.0),
                )
                : null,
      ),
    );
  }
}

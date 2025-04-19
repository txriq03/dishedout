import 'package:dishedout/features/upload/widgets/image_upload.dart';
import 'package:dishedout/features/upload/widgets/upload_form.dart';
import 'package:flutter/material.dart';
import 'dart:io';

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

  // Handles next step after button pressed
  void _nextStep() {
    _previousProgress = _getProgress();
    setState(() {
      switch (_currentStep) {
        case Step.takePhoto:
          _currentStep = Step.fillForm;
          break;
        case Step.fillForm:
          _currentStep = Step.success;
          break;
        case Step.success:
          // Handle success step if needed
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
        return UploadForm();
      case Step.success:
        return const Text('Success!');
    }
  }

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
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: _previousProgress, end: _getProgress()),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor: Colors.grey[900],
                        color: Colors.deepOrange,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(child: _getStepWidget()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _image != null ? _nextStep : null,
        elevation: 0,
        shape: const CircleBorder(side: BorderSide.none),
        backgroundColor:
            _image != null
                ? Colors.deepOrange.shade300.withValues(alpha: 0.3)
                : Colors.grey[900],
        foregroundColor: _image != null ? Colors.deepOrange : Colors.grey[800],
        child: const Icon(Icons.chevron_right_rounded, size: 24.0),
      ),
    );
  }
}

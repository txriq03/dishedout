import 'package:dishedout/features/upload/widgets/image_upload.dart';
import 'package:dishedout/features/upload/widgets/progress_indicator.dart';
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

  // Form key and controllers for the form step
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Handles next step after button pressed
  void _nextStep() {
    _previousProgress = _getProgress();
    setState(() {
      switch (_currentStep) {
        case Step.takePhoto:
          _currentStep = Step.fillForm;
          break;
        case Step.fillForm:
          if (_formKey.currentState?.validate() ?? false) {
            // Handle form submission logic here
            final name = _nameController.text;
            final description = _descriptionController.text;
            print('Food Name: $name');
            print('Description: $description');
            _currentStep = Step.success;
          }
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
        return UploadForm(
          formKey: _formKey,
          nameController: _nameController,
          descriptionController: _descriptionController,
        );
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

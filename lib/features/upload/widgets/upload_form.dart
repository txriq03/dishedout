import 'package:flutter/material.dart';

// AIzaSyCZkhmv5mPQnRNkFHXPDMdaTvtTUEH04Ws
class UploadForm extends StatelessWidget {
  final GlobalKey<FormState> formKey; // Key to validate the form
  final TextEditingController nameController; // Controller for the name field
  final TextEditingController
  descriptionController; // Controller for the description field

  const UploadForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Fill in food details",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 12),
          const Text(
            'Food Name',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 8),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: nameController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              hintText: 'Cheese burger',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a food name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Description',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              hintText: 'Enter a description of the food',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

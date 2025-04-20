import 'package:flutter/material.dart';

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

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      // Perform submission logic
      final name = nameController.text;
      final description = descriptionController.text;

      // For now, just print the values
      print('Food Name: $name');
      print('Description: $description');

      // You can add further logic here, like sending data to a server
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Fill in food details",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Food Name',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: nameController,
            cursorColor: Colors.deepOrange,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              hintText: 'Enter the name of the food',
            ),
            style: const TextStyle(color: Colors.white),
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
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: descriptionController,
            cursorColor: Colors.deepOrange,
            maxLines: 4,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              hintText: 'Enter a description of the food',
            ),
            style: const TextStyle(color: Colors.white),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

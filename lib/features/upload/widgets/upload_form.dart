import 'package:dishedout/features/upload/widgets/address_field.dart';
import 'package:flutter/material.dart';

// AIzaSyCZkhmv5mPQnRNkFHXPDMdaTvtTUEH04Ws
class UploadForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final double? lat;
  final double? lng;
  final TextEditingController addressController;
  final void Function(double?, double?) onLatLngChanged;

  const UploadForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.lat,
    required this.lng,
    required this.addressController,
    required this.onLatLngChanged,
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
          AddressField(
            lat: lat,
            lng: lng,
            addressController: addressController,
            onLatLngChanged: onLatLngChanged,
          ),
        ],
      ),
    );
  }
}

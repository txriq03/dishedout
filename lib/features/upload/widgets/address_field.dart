import 'package:dishedout/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

class AddressField extends StatefulWidget {
  double? lat;
  double? lng;
  final TextEditingController addressController;
  final void Function(double? lat, double? lng)? onLatLngChanged;

  AddressField({
    super.key,
    required this.lat,
    required this.lng,
    required this.addressController,
    this.onLatLngChanged,
  });

  @override
  State<AddressField> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressField> {
  // final TextEditingController _addressController = TextEditingController();
  // double? lat;
  // double? lng;
  final FocusNode _addressFocusNode = FocusNode();
  final String googleApiKey = AppConstants.googleApiKey;

  @override
  void dispose() {
    _addressFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GooglePlaceAutoCompleteTextField(
          focusNode: _addressFocusNode,
          boxDecoration: BoxDecoration(
            border: Border.all(color: Colors.grey[800]!),
            borderRadius: BorderRadius.circular(20),
          ),
          textEditingController: widget.addressController,
          googleAPIKey: googleApiKey,
          inputDecoration: const InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          debounceTime: 500,
          countries: ["gb"], // Optional: restrict to country code
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (prediction) {
            final lat = double.tryParse(prediction.lat ?? '');
            final lng = double.tryParse(prediction.lng ?? '');

            widget.onLatLngChanged?.call(lat, lng);
          },
          itemClick: (prediction) {
            widget.addressController.text = prediction.description!;
            widget.addressController.selection = TextSelection.fromPosition(
              TextPosition(offset: widget.addressController.text.length),
            );
          },
        ),
        const SizedBox(height: 20),
        if (widget.lat != null && widget.lng != null) ...[
          Text('Latitude: ${widget.lat}'),
          Text('Longitude: ${widget.lng}'),
        ],
      ],
    );
  }
}

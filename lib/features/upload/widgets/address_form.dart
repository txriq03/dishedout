import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';

const String GoogleApiKey = 'AIzaSyCZkhmv5mPQnRNkFHXPDMdaTvtTUEH04Ws';

class AddressForm extends StatefulWidget {
  const AddressForm({super.key});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final TextEditingController _addressController = TextEditingController();
  double? lat;
  double? lng;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GooglePlaceAutoCompleteTextField(
          textEditingController: _addressController,
          googleAPIKey: GoogleApiKey,
          inputDecoration: const InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          debounceTime: 500,
          countries: ["gb"], // Optional: restrict to country code
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (prediction) {
            setState(() {
              lat = double.tryParse(prediction.lat ?? '');
              lng = double.tryParse(prediction.lng ?? '');
            });
          },
          itemClick: (prediction) {
            _addressController.text = prediction.description!;
            _addressController.selection = TextSelection.fromPosition(
              TextPosition(offset: _addressController.text.length),
            );
          },
        ),
        const SizedBox(height: 20),
        if (lat != null && lng != null) ...[
          Text('Latitude: $lat'),
          Text('Longitude: $lng'),
        ],
      ],
    );
  }
}

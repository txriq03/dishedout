import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const SearchWidget({super.key, this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Colors.grey[400]),
      cursorColor: Colors.deepOrange,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[900],
        hintText: 'Search...',
        hintStyle: TextStyle(color: Colors.grey[700]),
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

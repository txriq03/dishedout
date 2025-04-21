import 'package:dishedout/features/upload/screens/upload.dart';
import 'package:dishedout/features/home/screens/homepage.dart';
import 'package:dishedout/features/profile/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [HomePage(), UploadPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    // Necessary to get rid of the mismatch color below navbar
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor:
            Theme.of(
              context,
            ).colorScheme.surfaceContainer, // Change this to your desired color
        systemNavigationBarIconBrightness:
            Brightness.dark, // Adjust icon brightness
      ),
    );

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        // indicatorColor: Colors.deepOrange.shade400,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_rounded, color: Colors.grey[800]),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_a_photo_rounded, color: Colors.grey[800]),
            label: 'Upload',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded, color: Colors.grey[800]),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

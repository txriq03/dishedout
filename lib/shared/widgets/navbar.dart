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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Color.fromARGB(
          255,
          27,
          27,
          27,
        ), // Match the BottomNavigationBar color
        systemNavigationBarIconBrightness:
            Brightness.light, // Adjust icon brightness
      ),
    );

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        height: 50,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: const Color.fromARGB(255, 27, 27, 27),
        indicatorColor: Colors.deepOrange.shade400,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_rounded, size: 28, color: Colors.grey[800]),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.add_a_photo_rounded,
              size: 28,
              color: Colors.grey[800],
            ),
            label: 'Upload',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded, size: 28, color: Colors.grey[800]),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

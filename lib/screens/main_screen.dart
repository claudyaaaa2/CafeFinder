import 'package:flutter/material.dart';
import 'home_page.dart'; // Import halaman Home yang sudah kita buat
import 'explore_screen.dart'; // Import halaman Explore
import 'profile_screen.dart'; // Import halaman Profile

class MainScreen extends StatefulWidget {
  final String username;
  const MainScreen({super.key, required this.username});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Ini adalah isi dari FrameLayout (fragment_container)
    final List<Widget> pages = [
      HomePage(username: widget.username),       // Index 0: Tab Home
      const ExploreScreen(),                     // Index 1: Tab Explore
      ProfileScreen(username: widget.username),  // Index 2: Tab Profile
    ];

    return Scaffold(
      // Slot Body menggantikan FrameLayout
      body: pages[_selectedIndex],
      
      // Slot ini menggantikan BottomNavigationView di XML
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -2))
          ],
        ),
        // Kita bungkus dengan Theme agar bisa mengatur warna splash/ripple saat diklik
        child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: const Color(0xFF4E342E), // Sesuai android:background="#4E342E"
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white, // Sesuai app:itemTextColor & itemIconTint
            unselectedItemColor: Colors.white54, // Ikon yang tidak aktif dibuat agak transparan
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.home_outlined),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.home),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.explore_outlined),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.explore),
                ),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.person_outline),
                ),
                activeIcon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.person),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
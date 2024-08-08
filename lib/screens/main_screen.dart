import 'dart:io';

import 'package:buddymensia/colors.dart';
import 'package:buddymensia/models/user.dart';
import 'package:buddymensia/screens/guessme/guess_me_screen.dart';
import 'package:buddymensia/screens/home/add_post_screen.dart';
import 'package:buddymensia/screens/home/home_screen.dart';
import 'package:buddymensia/screens/profile/profile_screen.dart';
import 'package:buddymensia/screens/safezone/safezone_screen.dart';
import 'package:buddymensia/services/auth_services.dart';
import 'package:buddymensia/services/jadwal_services.dart';
import 'package:buddymensia/services/post_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const GuessMeScreen(),
    const SafezoneScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image != null ? File(image.path) : null;
    });
    if (_imageFile != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddPostScreen(
                image: _imageFile!,
              )));
    }
  }

  @override
  void initState() {
    Provider.of<AuthService>(context, listen: false).getUser();
    Provider.of<PostServices>(context, listen: false).fetchData();
    Provider.of<JadwalServices>(context, listen: false).fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthService authProvider = Provider.of<AuthService>(context);
    User? user = authProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.hijauTuaSecondary,
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: _widgetOptions[_selectedIndex],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 6.0,
          child: SizedBox(
            height: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.home),
                  color: _selectedIndex == 0
                      ? Colors.teal
                      : Colors.teal.withOpacity(0.5),
                  onPressed: () => _onItemTapped(0),
                ),
                IconButton(
                  icon: const Icon(Icons.dashboard),
                  color: _selectedIndex == 1
                      ? Colors.teal
                      : Colors.teal.withOpacity(0.5),
                  onPressed: () => _onItemTapped(1),
                ),
                const SizedBox(width: 48.0),
                IconButton(
                  icon: const Icon(Icons.location_on),
                  color: _selectedIndex == 2
                      ? Colors.teal
                      : Colors.teal.withOpacity(0.5),
                  onPressed: () => _onItemTapped(2),
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  color: _selectedIndex == 3
                      ? Colors.teal
                      : Colors.teal.withOpacity(0.5),
                  onPressed: () => _onItemTapped(3),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          margin: const EdgeInsets.only(top: 4),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(12),
          child: Container(
            height: 48,
            width: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.hijauTuaSecondary,
                  blurRadius: 3,
                  spreadRadius: 2,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: FloatingActionButton(
              onPressed: _pickImageFromGallery,
              backgroundColor: AppColors.hijauTuaSecondary,
              shape: const CircleBorder(),
              elevation: 6.0,
              child: const Icon(Icons.add, size: 36),
            ),
          ),
        ),
      ),
    );
  }
}

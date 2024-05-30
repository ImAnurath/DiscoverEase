import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:discover_ease/widgets/bottom_navbar.dart';
import 'package:discover_ease/screens/edit_profile_screen.dart';
import 'package:discover_ease/pages/entry_page.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _profileImage = "assets/profile_images/im1.png";
  String _fullName = "";
  String _email = "";

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    print("Full Name: ${prefs.getString('full_name')}");
    print("Email: ${prefs.getString('email')}");
    setState(() {
      _fullName = prefs.getString('full_name') ?? "";
      _email = prefs.getString('email') ?? "";
    });
  }

  void _updateProfileImage(String newImage) {
    setState(() {
      _profileImage = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(isDark ? Icons.sunny : Icons.dark_mode_outlined, color: Colors.black87),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/city/profile.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image(
                        image: AssetImage(_profileImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _fullName, // Display full name
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w400, color: Colors.black87),
                  ),
                  Text(
                    _email, // Display email
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 30),
                  const Divider(height: 0, thickness: 1, color: Colors.black87),
                  const SizedBox(height: 10),
                  ProfileMenu(
                    editProfileScreen: EditProfileScreen(
                      onUpdateProfileImage: _updateProfileImage,
                      fullName: _fullName,
                      email: _email,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  final Widget editProfileScreen;

  const ProfileMenu({Key? key, required this.editProfileScreen}) : super(key: key);

  void _logout(BuildContext context) async {
    try {
      await Firebase.initializeApp();
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout Successful!', style: TextStyle(color: Colors.black87))),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const EntryPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out: $e', style: TextStyle(color: Colors.black87))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => editProfileScreen,
              ),
            );
          },
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
            mouseCursor: MaterialStateProperty.all<MouseCursor>(SystemMouseCursors.click),
            foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.green;
              }
              return Colors.black;
            }),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.settings,
                    size: 20,
                    color: Colors.black87,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Profile Settings",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.black87),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 0, thickness: 1, color: Colors.black87),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {},
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
            mouseCursor: MaterialStateProperty.all<MouseCursor>(SystemMouseCursors.click),
            foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.green;
              }
              return Colors.black;
            }),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.star,
                    size: 20,
                    color: Colors.black87,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Favorites",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.black87),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 0, thickness: 1, color: Colors.black87),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutPage()),
            );
          },
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
            mouseCursor: MaterialStateProperty.all<MouseCursor>(SystemMouseCursors.click),
            foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return Colors.blue;
              }
              return Colors.black;
            }),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info,
                    size: 20,
                    color: Colors.black87,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "About",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.black87),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 0, thickness: 1, color: Colors.black87),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => _logout(context),
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
            mouseCursor: MaterialStateProperty.all<MouseCursor>(SystemMouseCursors.click),
            foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return const Color.fromARGB(255, 116, 9, 9);
              }
              return Colors.black;
            }),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.logout,
                    size: 20,
                    color: Colors.black87,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Log Out",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.black87),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 0, thickness: 1, color: Colors.black87),
        const SizedBox(height: 8),
      ],
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "About",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/city/city16.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  SizedBox(height: 20),
                  Text(
                    "DiscoverEase",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "DiscoverEase is an advanced mobile application designed to expand exploration of cities' hidden treasures. This fascinating application brings together and offers users comprehensive information about its historical and cultural riches, transportation alternatives, unique performances, friendly cafes and various events on a single platform. DiscoverEase provides personalized recommendations and enables efficient route planning to give users a unique and amazing travel experience.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

import 'package:discover_ease/widgets/post_app_bar.dart';
import 'package:discover_ease/widgets/post_bottom_navbar.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/travel.jpg"), fit: BoxFit.cover, opacity: 0.7)
      ),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: PostAppBar(),
        ),
        bottomNavigationBar: PostBottomNavBaar(),
      ),
    );
    
  }
}
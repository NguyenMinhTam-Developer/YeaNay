import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yea_nay/configs/theme_config.dart';
import 'package:yea_nay/presentation/controllers/auth_controller.dart';
import 'package:yea_nay/presentation/screens/my_post_screen.dart';

import 'create_post_screen.dart';
import 'home_page.dart';
import 'my_vote_screen.dart';
import 'profile_page.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = '/main';

  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _widgetOptions = [
    const HomeScreen(),
    const MyPostScreen(),
    const MyVoteScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    Get.put(AuthController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _widgetOptions.elementAt(_currentIndex)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(CreatePostScreen.routeName),
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Get.theme.colorScheme.onPrimary,
        child: const Icon(Icons.add_circle_outline_sharp),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 10,
        shape: const CircularNotchedRectangle(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: SizeConfig.padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _onBottomNavigationTap(0),
                icon: Icon(Icons.home_rounded, color: _getIconColor(0)),
              ),
              IconButton(
                onPressed: () => _onBottomNavigationTap(1),
                icon: Icon(Icons.favorite_rounded, color: _getIconColor(1)),
              ),
              const IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.more,
                  color: Colors.transparent,
                ),
              ),
              IconButton(
                onPressed: () => _onBottomNavigationTap(2),
                icon: Icon(Icons.receipt_long_rounded, color: _getIconColor(2)),
              ),
              IconButton(
                onPressed: () => Get.to(() => const ProfileScreen()),
                icon: const Icon(Icons.person_rounded),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onBottomNavigationTap(int index) => setState(() => _currentIndex = index);

  Color _getIconColor(int index) => index == _currentIndex ? Get.theme.colorScheme.primary : Get.theme.iconTheme.color!;
}

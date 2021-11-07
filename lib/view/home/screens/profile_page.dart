import 'package:flutter/material.dart';
import '../widgets/body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: AppBar(
      //   title: const Text("Profile"),
      // ),
      body: Body(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            const Spacer(),

            // App Logo
            Image.asset('assets/icons/yeanay.png', height: 40),

            const Spacer(),

            // Sign In Methods
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SocialMediaButton(
                  onTap: () {
                    _authController.signInWithGoogle();
                  },
                  svgPath: 'assets/icons/google.svg',
                ),
                const SizedBox(width: 16),
                SocialMediaButton(
                  onTap: () {},
                  svgPath: 'assets/icons/facebook.svg',
                ),
              ],
            ),

            const SizedBox(height: 20),

            InkWell(
              onTap: () {
                _authController.signInAnonymously();
              },
              child: const Text(
                'Guest Login',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialMediaButton extends StatelessWidget {
  const SocialMediaButton({
    Key? key,
    required this.onTap,
    required this.svgPath,
  }) : super(key: key);

  final VoidCallback onTap;
  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: SvgPicture.asset(
          svgPath,
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

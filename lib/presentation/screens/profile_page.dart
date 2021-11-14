import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yea_nay/configs/theme_config.dart';
import 'package:yea_nay/presentation/controllers/auth_controller.dart';
import 'package:yea_nay/presentation/widgets/empty_data_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Obx(() {
        if (_authController.isAnonymous.value) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const EmptyDataWidget(icon: Icons.person, text: "Please login to use this feature"),
              const SizedBox(height: SizeConfig.padding),
              Center(
                child: ElevatedButton(
                  onPressed: () => _authController.signOut(),
                  child: const Text("Sign-In"),
                ),
              ),
            ],
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(SizeConfig.padding),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  backgroundImage: NetworkImage(_authController.currentUser?.avatar ?? ''),
                  radius: 50,
                ),
                const SizedBox(height: SizeConfig.padding),
                Text(
                  _authController.currentUser?.name ?? '',
                  style: const TextStyle(fontSize: 18),
                ),
                const Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _authController.signOut(),
                    child: const Text("Logout"),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}

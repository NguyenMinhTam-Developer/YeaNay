import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yea_nay/configs/theme_config.dart';
import 'package:yea_nay/presentation/controllers/auth_controller.dart';
import 'package:yea_nay/presentation/screens/profile/personal_information_screen.dart';
import 'package:yea_nay/presentation/screens/profile/policy_screen.dart';
import 'package:yea_nay/presentation/widgets/empty_data_widget.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';
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
          return GetBuilder<AuthController>(builder: (_) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(SizeConfig.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(SizeConfig.padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Information
                          Column(
                            children: [
                              Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(color: Get.theme.colorScheme.primary.withOpacity(0.15), shape: BoxShape.circle),
                                child: Image.network(
                                  _authController.currentUser?.avatar ?? '',
                                  fit: BoxFit.cover,
                                  height: Get.width * 0.3,
                                  width: Get.width * 0.3,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    return Icon(
                                      Icons.account_circle_rounded,
                                      color: Get.theme.colorScheme.primary,
                                      size: Get.width * 0.3,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: SizeConfig.margin),
                              Text(
                                _authController.currentUser?.name ?? '',
                                style: Get.textTheme.headline6,
                              ),
                              Text(
                                _authController.currentUser?.email ?? '',
                                style: Get.textTheme.bodyText1!.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: SizeConfig.padding),
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          elevation: 0,
                          clipBehavior: Clip.hardEdge,
                          child: ListTile(
                            onTap: _authController.currentUser != null ? () => Get.to(() => PersonalInformationScreen(_authController.currentUser!)) : null,
                            leading: Icon(Icons.person_rounded, color: Get.theme.colorScheme.primary),
                            minLeadingWidth: 0,
                            title: const Text("Personal Information", maxLines: 1, overflow: TextOverflow.ellipsis),
                            trailing: Icon(Icons.keyboard_arrow_right_rounded, color: Get.theme.colorScheme.primary),
                          ),
                        ),
                        Card(
                          elevation: 0,
                          clipBehavior: Clip.hardEdge,
                          child: ListTile(
                            onTap: () => Get.to(() => const PolicyScreen()),
                            leading: Icon(Icons.policy_rounded, color: Get.theme.colorScheme.primary),
                            minLeadingWidth: 0,
                            title: const Text("Policy", maxLines: 1, overflow: TextOverflow.ellipsis),
                            trailing: Icon(Icons.keyboard_arrow_right_rounded, color: Get.theme.colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: SizeConfig.padding),
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          elevation: 0,
                          clipBehavior: Clip.hardEdge,
                          child: ListTile(
                            onTap: () => _authController.signOut(),
                            leading: const Icon(Icons.logout_rounded, color: Colors.red),
                            minLeadingWidth: 0,
                            title: const Text("Log-out", maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
          // return Padding(
          //   padding: const EdgeInsets.all(SizeConfig.padding),
          //   child: Column(
          //     children: [
          //       CircleAvatar(
          //         backgroundColor: Colors.grey[200],
          //         backgroundImage: NetworkImage(_authController.currentUser?.avatar ?? ''),
          //         radius: 50,
          //       ),
          //       const SizedBox(height: SizeConfig.padding),
          //       Text(
          //         _authController.currentUser?.name ?? '',
          //         style: const TextStyle(fontSize: 18),
          //       ),
          //       const Spacer(),
          //       Center(
          //         child: ElevatedButton(
          //           onPressed: () => _authController.signOut(),
          //           child: const Text("Logout"),
          //         ),
          //       ),
          //     ],
          //   ),
          // );
        }
      }),
    );
  }
}

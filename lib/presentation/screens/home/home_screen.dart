import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yea_nay/configs/theme_config.dart';
import 'package:yea_nay/presentation/controllers/auth_controller.dart';
import 'package:yea_nay/presentation/controllers/post_controller.dart';
import 'package:yea_nay/presentation/widgets/empty_data_widget.dart';
import 'package:yea_nay/presentation/widgets/feed_post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostController _postController = Get.put(PostController());
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/icons/yeanay.png',
          height: 24,
        ),
      ),
      body: Obx(() {
        if (!_postController.isLoading.value) {
          return FutureBuilder(
            future: _authController.currentUser != null ? _postController.getUserFeedsList() : _postController.getPost(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return RefreshIndicator(
                onRefresh: () async {
                  if (_authController.currentUser != null) {
                    await _postController.getUserFeedsList();
                  } else {
                    await _postController.getPost();
                  }
                },
                child: _postController.postList.isNotEmpty
                    ? ListView.separated(
                        itemCount: _postController.postList.length,
                        padding: const EdgeInsets.all(SizeConfig.padding),
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: SizeConfig.padding,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return FeedPostWidget(post: _postController.postList[index]);
                        },
                      )
                    : const EmptyDataWidget(
                        icon: Icons.post_add_outlined,
                        text: "You don't have any feed",
                      ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}

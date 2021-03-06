import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yea_nay/configs/theme_config.dart';
import 'package:yea_nay/domain/models/post_model.dart';
import 'package:yea_nay/presentation/controllers/auth_controller.dart';
import 'package:yea_nay/presentation/controllers/post_controller.dart';
import 'package:yea_nay/presentation/widgets/empty_data_widget.dart';
import 'package:yea_nay/presentation/widgets/feed_post_widget.dart';

class MyVoteScreen extends StatefulWidget {
  const MyVoteScreen({Key? key}) : super(key: key);

  @override
  _MyVoteScreenState createState() => _MyVoteScreenState();
}

class _MyVoteScreenState extends State<MyVoteScreen> {
  final AuthController _authController = Get.find();
  final PostController _postController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Votes")),
      body: Obx(() {
        if (_authController.isAnonymous.value) {
          return const EmptyDataWidget(
            icon: Icons.login_outlined,
            text: "Please login\nto use this feature",
          );
        } else {
          return FutureBuilder(
            future: _postController.getUserVotedList(),
            builder: (BuildContext context, AsyncSnapshot<List<PostModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return RefreshIndicator(
                onRefresh: () async {
                  if (_authController.currentUser != null) {
                    await _postController.getUserVotedList();
                  }
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(SizeConfig.padding),
                  itemCount: snapshot.data?.length ?? 0,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: SizeConfig.padding);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                      return FeedPostWidget(post: snapshot.data![index], editAble: false);
                    } else {
                      return const EmptyDataWidget(
                        icon: Icons.post_add,
                        text: "You don't have any post, create new one now!",
                      );
                    }
                  },
                ),
              );
            },
          );
        }
      }),
    );
  }
}

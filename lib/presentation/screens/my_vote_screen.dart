import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yea_nay/configs/theme_config.dart';
import 'package:yea_nay/presentation/controllers/auth_controller.dart';
import 'package:yea_nay/presentation/controllers/post_controller.dart';
import 'package:yea_nay/presentation/controllers/vote_controller.dart';
import 'package:yea_nay/presentation/widgets/empty_data_widget.dart';
import 'package:yea_nay/presentation/widgets/feed_post_widget.dart';

class MyVoteScreen extends StatefulWidget {
  const MyVoteScreen({Key? key}) : super(key: key);

  @override
  _MyVoteScreenState createState() => _MyVoteScreenState();
}

class _MyVoteScreenState extends State<MyVoteScreen> {
  final AuthController _authController = Get.find();
  final VoteController _voteController = Get.find();
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
            future: _voteController.getUserVotes(FirebaseAuth.instance.currentUser?.uid ?? '').then((value) {
              List<String> ids = [];

              for (var element in value) {
                ids.add(element.postId!);
              }
            }),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.separated(
                padding: const EdgeInsets.all(SizeConfig.padding),
                itemCount: _postController.userVotedPost.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: SizeConfig.padding);
                },
                itemBuilder: (BuildContext context, int index) {
                  if (_postController.userVotedPost.isNotEmpty) {
                    return FeedPostWidget(post: _postController.userVotedPost[index], editAble: false);
                  } else {
                    return const Center(
                      child: EmptyDataWidget(
                        icon: Icons.post_add,
                        text: "You don't have any vote",
                      ),
                    );
                  }
                },
              );
            },
          );
        }
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yea_nay/configs/theme_config.dart';
import 'package:yea_nay/domain/models/post_model.dart';
import 'package:yea_nay/domain/models/user_model.dart';
import 'package:yea_nay/domain/models/vote_model.dart';
import 'package:yea_nay/presentation/controllers/auth_controller.dart';
import 'package:yea_nay/presentation/controllers/post_controller.dart';
import 'package:intl/intl.dart';
import 'package:yea_nay/presentation/controllers/user_controller.dart';
import 'package:yea_nay/presentation/controllers/vote_controller.dart';

class FeedPostWidget extends StatefulWidget {
  const FeedPostWidget({
    Key? key,
    required this.post,
    this.editAble = true,
  }) : super(key: key);

  final PostModel post;
  final bool editAble;

  @override
  _FeedPostWidgetState createState() => _FeedPostWidgetState();
}

class _FeedPostWidgetState extends State<FeedPostWidget> {
  final AuthController _authController = Get.put(AuthController());
  final PostController _postController = Get.put(PostController());
  final VoteController _voteController = Get.put(VoteController());
  final UserController _userController = Get.put(UserController());

  int? _selectedOption;
  List<VoteModel?> voteList = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder(
            future: widget.post.owner != null ? _userController.getUser(widget.post.owner!) : null,
            builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: snapshot.data?.avatar != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data!.avatar!),
                        backgroundColor: Colors.grey[100],
                        radius: 20,
                      )
                    : Container(height: 20, width: 20, color: Colors.grey[100]),
                title: Text(snapshot.data?.name ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(DateFormat('dd MMMM, yyyy').format(DateTime.now())),
                trailing: const Icon(Icons.share),
              );
            },
          ),
          Stack(
            children: [
              Container(
                height: Get.width - 32,
                width: Get.width - 32,
                color: widget.post.background?.color != null ? Color(int.parse((widget.post.background!.color!.substring(6, 16)))) : null,
              ),
              Positioned.fill(
                child: Center(
                  child: Text(
                    widget.post.content?.data ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder(
            future: widget.post.votes?.isEmpty ?? true ? _voteController.getPostVotes(widget.post.id ?? '') : null,
            builder: (BuildContext context, AsyncSnapshot<List<VoteModel>> snapshot) {
              voteList = widget.post.votes ?? [];

              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  widget.post.votes = snapshot.data!;
                  voteList = snapshot.data!;
                }
              }

              return Padding(
                padding: const EdgeInsets.all(SizeConfig.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.post.options!.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: SizeConfig.padding);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        List<VoteModel?> optionVotes = voteList.where((vote) => vote?.value == widget.post.options![index]).toList();

                        return GestureDetector(
                          onTap: widget.editAble
                              ? () {
                                  setState(() {
                                    _selectedOption = index;
                                  });
                                }
                              : null,
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(36),
                              border: Border.all(
                                width: 1,
                                color: _selectedOption == index ? Get.theme.colorScheme.primary : Colors.black,
                              ),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(36),
                                  child: LinearProgressIndicator(
                                    minHeight: 36,
                                    backgroundColor: Colors.white,
                                    color: Get.theme.colorScheme.primary.withOpacity(0.25),
                                    value: optionVotes.isNotEmpty ? (voteList.length / optionVotes.length) : 0,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Center(
                                    child: Text(
                                      "${widget.post.options![index]} (${optionVotes.isNotEmpty ? (optionVotes.length / voteList.length * 100).toStringAsFixed(0) : 0} %)",
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    if (!_authController.isAnonymous.value) const Divider(height: 32),
                    if (!_authController.isAnonymous.value)
                      Row(
                        children: [
                          Expanded(child: Text("${voteList.length.toString()} Votes")),
                          const SizedBox(width: 8),
                          if (widget.editAble)
                            TextButton(
                                onPressed: _selectedOption != null
                                    ? () {
                                        setState(() {
                                          _selectedOption = null;
                                        });
                                      }
                                    : null,
                                child: const Text("Clear")),
                          if (widget.editAble) const SizedBox(width: 8),
                          if (widget.editAble)
                            ElevatedButton(
                                onPressed: _selectedOption != null
                                    ? () {
                                        _voteController
                                            .submitVote(
                                          postId: widget.post.id!,
                                          value: widget.post.options![_selectedOption!]!,
                                        )
                                            .then((value) {
                                          _postController.postList.removeWhere((post) => post.id! == widget.post.id);
                                        });

                                        _postController.update();
                                      }
                                    : null,
                                child: const Text("Submit")),
                        ],
                      )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

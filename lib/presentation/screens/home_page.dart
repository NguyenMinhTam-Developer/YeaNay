import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/empty_data_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('feeds').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> feedSnapshot) {
          List<String> feeds = [];

          if (feedSnapshot.data != null) {
            for (var doc in feedSnapshot.data!.docs) {
              feeds.add(doc.id);
            }

            if (feeds.isNotEmpty) {
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('posts').where('id', whereIn: feeds).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> postSnapshot) {
                  if (!postSnapshot.hasData && postSnapshot.data!.docs.isNotEmpty) {
                    return const EmptyDataWidget(icon: Icons.clear, text: "You don't have any new feed");
                  } else {
                    if (postSnapshot.data != null && postSnapshot.data!.docs.isNotEmpty) {
                      return ListView.separated(
                        itemCount: postSnapshot.data?.docs.length ?? 0,
                        padding: const EdgeInsets.all(16),
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 16);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          String? postId = postSnapshot.data?.docs[index].id;
                          List<String> options = List<String>.from(postSnapshot.data?.docs[index]['options'].map((x) => x));

                          return Card(
                            margin: EdgeInsets.zero,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                    future: FirebaseFirestore.instance.collection('users').doc(postSnapshot.data?.docs[index]['user_id']).get(),
                                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> userSnapshot) {
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: Container(
                                          height: 40,
                                          width: 40,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: const BoxDecoration(shape: BoxShape.circle),
                                          child: userSnapshot.data?.data()?['profile_image'] != null
                                              ? Image.network(
                                                  userSnapshot.data!.data()!['profile_image'],
                                                  fit: BoxFit.cover,
                                                )
                                              : const Icon(Icons.person),
                                        ),
                                        title: Text(userSnapshot.data?.data()?['name'] ?? ''),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 16),

                                  // Content
                                  Container(
                                    height: Get.width - 32,
                                    width: Get.width - 32,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      color: Color(int.parse(postSnapshot.data?.docs[index]['background']['color'])),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Stack(
                                      children: [
                                        if (postSnapshot.data?.docs[index]['background']['background_image'] != null)
                                          Positioned.fill(
                                            child: Image.network(
                                              postSnapshot.data?.docs[index]['background']['background_image'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        if (postSnapshot.data?.docs[index]['content']['data'] != null)
                                          Positioned.fill(
                                            child: Container(
                                              padding: const EdgeInsets.all(16),
                                              child: Center(
                                                child: Text(
                                                  postSnapshot.data?.docs[index]['content']['data'],
                                                  textAlign: postSnapshot.data?.docs[index]['content']['align'] == TextAlign.left.toString()
                                                      ? TextAlign.left
                                                      : postSnapshot.data?.docs[index]['content']['align'] == TextAlign.center.toString()
                                                          ? TextAlign.center
                                                          : TextAlign.right,
                                                  style: TextStyle(
                                                    color: Color(int.parse(postSnapshot.data?.docs[index]['content']['color'])),
                                                    fontSize: double.parse(postSnapshot.data?.docs[index]['content']['size']),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  const Divider(height: 32),

                                  if (postId != null)
                                    // Vote
                                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance.collection('posts').doc(postId).collection('votes').snapshots(),
                                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> voteSnapshot) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            ListView.separated(
                                              shrinkWrap: true,
                                              itemCount: options.length,
                                              physics: const NeverScrollableScrollPhysics(),
                                              separatorBuilder: (BuildContext context, int index) {
                                                return const SizedBox(height: 16);
                                              },
                                              itemBuilder: (BuildContext context, int index) {
                                                int optionVotes = voteSnapshot.data!.docs.where((vote) => vote.data()['vote'] == options[index]).toList().length;

                                                return GestureDetector(
                                                  onTap: () {
                                                    FirebaseFirestore.instance.collection('posts').doc(postId).collection('votes').doc(FirebaseAuth.instance.currentUser!.uid).set(
                                                      {
                                                        'vote': options[index],
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(36), border: Border.all(color: Colors.black)),
                                                    child: Stack(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(36),
                                                          child: LinearProgressIndicator(
                                                            minHeight: 36,
                                                            backgroundColor: Colors.white,
                                                            color: Colors.grey[400],
                                                            value: (optionVotes / voteSnapshot.data!.docs.length),
                                                          ),
                                                        ),
                                                        Positioned.fill(
                                                          child: Center(
                                                            child: Text("${options[index]} (${(optionVotes / voteSnapshot.data!.docs.length * 100).toStringAsFixed(0)}%)"),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            const Divider(height: 32),
                                            Row(
                                              children: [
                                                Expanded(child: Text("${voteSnapshot.data!.docs.length.toString()} Votes")),
                                                const SizedBox(width: 8),
                                                TextButton(
                                                    onPressed: () {
                                                      FirebaseFirestore.instance.collection('posts').doc(postId).collection('votes').doc(FirebaseAuth.instance.currentUser!.uid).delete();
                                                    },
                                                    child: const Text("Clear")),
                                                const SizedBox(width: 8),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('feeds').doc(postId).delete();
                                                      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('my_votes').doc(postId).set({});
                                                    },
                                                    child: const Text("Submit")),
                                              ],
                                            )
                                          ],
                                        );
                                      },
                                    ),

                                  // Votes
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const EmptyDataWidget(icon: Icons.clear, text: "You don't have any new feed");
                    }
                  }
                },
              );
            } else {
              return const EmptyDataWidget(icon: Icons.clear, text: "You don't have any new feed");
            }
          } else {
            return const EmptyDataWidget(icon: Icons.clear, text: "You don't have any new feed");
          }
        },
      ),
    );
  }
}

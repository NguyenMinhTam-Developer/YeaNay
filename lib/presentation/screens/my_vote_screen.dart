import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyVoteScreen extends StatelessWidget {
  const MyVoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Votes"),
      ),
      body: ListView.separated(
        itemCount: 10,
        padding: const EdgeInsets.all(16),
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 16);
        },
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.zero,
            elevation: 3,
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundImage: const NetworkImage('https://firebasestorage.googleapis.com/v0/b/yeanay-9f09b.appspot.com/o/users%2F2XUjRAg6JaUMYjnkadBzXEKuKIA3-avatar.png?alt=media&token=47205197-9a6c-4fd2-9b8b-b74ada031310'),
                    backgroundColor: Colors.grey[100],
                    radius: 20,
                  ),
                  title: const Text("Michael Wittmann"),
                  subtitle: Text(DateFormat('dd MMMM, yyyy').format(DateTime.now())),
                  trailing: const Icon(Icons.share),
                ),
                Stack(
                  children: [
                    Container(
                      height: Get.width - 32,
                      width: Get.width - 32,
                      color: Colors.blue,
                    ),
                    const Positioned.fill(
                      child: Center(
                        child: Text(
                          "How awesome is Flutter?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

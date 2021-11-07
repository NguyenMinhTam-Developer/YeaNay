import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  const PostPage(
    this.data, {
    Key? key,
  }) : super(key: key);

  final String data;
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Screen"),
      ),
      body: Center(
          child: Text(
        widget.data,
        style: const TextStyle(fontSize: 24),
      )),
    );
  }
}

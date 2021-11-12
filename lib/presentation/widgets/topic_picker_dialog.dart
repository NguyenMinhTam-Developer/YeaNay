import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'empty_data_widget.dart';

class TopicPickerDialog extends StatefulWidget {
  const TopicPickerDialog({Key? key, required this.topics}) : super(key: key);

  final List<String> topics;

  @override
  _TopicPickerDialogState createState() => _TopicPickerDialogState();
}

class _TopicPickerDialogState extends State<TopicPickerDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(6.0),
      title: const Text("Choose topics"),
      content: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('topics').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: EmptyDataWidget(
                icon: Icons.topic,
                text: "There are no topics",
              ),
            );
          }

          return ListView.separated(
            itemCount: snapshot.data?.docs.length ?? 0,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () => setState(() {
                  if (!widget.topics.contains(snapshot.data?.docs[index]['name'])) {
                    widget.topics.add(snapshot.data?.docs[index]['name']);
                  } else {
                    widget.topics.remove(snapshot.data?.docs[index]['name']);
                  }
                }),
                leading: Icon(
                  widget.topics.contains(snapshot.data?.docs[index]['name']) ? Icons.check_box : Icons.check_box_outline_blank,
                  color: Colors.black,
                ),
                title: Text(
                  snapshot.data?.docs[index]['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          );
        },
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: Navigator.of(context).pop,
        ),
        TextButton(
          child: const Text('Accept'),
          onPressed: () {
            Navigator.of(context).pop(widget.topics);
          },
        ),
      ],
    );
  }
}

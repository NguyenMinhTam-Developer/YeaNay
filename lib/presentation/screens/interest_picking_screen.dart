import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/auth_controller.dart';
import '../widgets/empty_data_widget.dart';
import '../layouts/event_helper.dart';

class InterestPickingScreen extends StatefulWidget {
  const InterestPickingScreen({
    Key? key,
    required this.displayName,
    required this.dateOfBirth,
    required this.email,
    required this.city,
    required this.state,
    required this.country,
    this.avatarUrl,
    this.selectedImage,
  }) : super(key: key);

  final String displayName, dateOfBirth, email, city, state, country;
  final String? avatarUrl;
  final XFile? selectedImage;

  @override
  _InterestPickingScreenState createState() => _InterestPickingScreenState();
}

class _InterestPickingScreenState extends State<InterestPickingScreen> {
  final AuthController _authController = Get.find();

  List<String> selectedTopics = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Your Interest"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 9,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) => Card(
                    margin: EdgeInsets.zero,
                    child: InkWell(
                      onTap: () => setState(() {
                        if (!selectedTopics.contains(snapshot.data?.docs[index]['name'])) {
                          selectedTopics.add(snapshot.data?.docs[index]['name']);
                        } else {
                          selectedTopics.remove(snapshot.data?.docs[index]['name']);
                        }
                      }),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child: Text(
                                  snapshot.data?.docs[index]['name'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                selectedTopics.contains(snapshot.data?.docs[index]['name']) ? Icons.check_circle : Icons.radio_button_unchecked,
                                size: 20,
                                color: Get.theme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  staggeredTileBuilder: (int index) => const StaggeredTile.count(3, 3),
                  padding: const EdgeInsets.all(16),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedTopics.length < 3) {
                      EventHelper.openSnackBar(title: "Requirement", message: "Please select atleast 3 topics", type: AlertType.info);
                    } else {
                      _authController.createProfile(
                        displayName: widget.displayName,
                        dateOfBirth: widget.dateOfBirth,
                        email: widget.email,
                        city: widget.city,
                        state: widget.state,
                        country: widget.country,
                        topics: selectedTopics,
                        avatarUrl: widget.avatarUrl,
                        selectedImage: widget.selectedImage,
                      );
                    }
                  },
                  child: const Text("Finish"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yea_nay/domain/core/alert.dart';
import 'package:yea_nay/presentation/controllers/auth_controller.dart';
import 'package:yea_nay/presentation/helpers/event_helper.dart';
import 'package:yea_nay/presentation/widgets/empty_data_widget.dart';
import '../widgets/image_picker_dialog.dart';
import '../widgets/topic_picker_dialog.dart';
import 'option_input_widget.dart';

class CreatePostScreen extends StatefulWidget {
  static const String routeName = '/create_post_screen';

  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final AuthController _authController = Get.find();

  final _formKey = GlobalKey<FormState>();
  final PageController _postFormatOptionsController = PageController();

  final TextEditingController _questionController = TextEditingController();

  XFile? _selectedImage;
  String? _question;

  List<String> _options = [
    '',
    '',
  ];

  List<String>? _topics = [];

  Color? _backgroundColor = Colors.white;
  Color? _tempBackgroundColor = Colors.white;

  Color? _textColor = Colors.black;
  Color? _tempTextColor = Colors.black;

  TextAlign _textAlign = TextAlign.center;

  _openBackgroundColorPicker() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: const Text("Background color"),
          content: MaterialColorPicker(
            selectedColor: _backgroundColor,
            onColorChange: (color) => setState(() => _tempBackgroundColor = color),
            onMainColorChange: (color) => setState(() => _tempBackgroundColor = color),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: Navigator.of(context).pop,
            ),
            TextButton(
              child: const Text('Accept'),
              onPressed: () {
                Navigator.of(context).pop();

                setState(() {
                  _selectedImage = null;
                  _backgroundColor = _tempBackgroundColor;
                });
              },
            ),
          ],
        );
      },
    );
  }

  _openBackgroundImagePicker() async {
    _selectedImage = await showDialog<XFile?>(
      context: context,
      builder: (context) {
        return const ImagePickerDialog(
          title: "Background image",
        );
      },
    );

    setState(() {});
  }

  _openTextColorPicker() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: const Text("Background color"),
          content: MaterialColorPicker(
            selectedColor: _backgroundColor,
            onColorChange: (color) => setState(() => _tempTextColor = color),
            onMainColorChange: (color) => setState(() => _tempTextColor = color),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: Navigator.of(context).pop,
            ),
            TextButton(
              child: const Text('Accept'),
              onPressed: () {
                Navigator.of(context).pop();

                setState(() {
                  _textColor = _tempTextColor;
                });
              },
            ),
          ],
        );
      },
    );
  }

  _changeTextAlign(TextAlign textAlign) {
    setState(() {
      _textAlign = textAlign;
    });
  }

  _postOptionTap(int index) {
    _postFormatOptionsController.animateToPage(index, duration: const Duration(milliseconds: 250), curve: Curves.linear);
  }

  _openTopicTagDialog() async {
    _topics = await showDialog<List<String>>(
      context: context,
      builder: (_) {
        return TopicPickerDialog(
          topics: _topics ?? [],
        );
      },
    );

    setState(() {});
  }

  _createPost() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_questionController.text.isEmpty) {
      EventHelper.openSnackBar(title: "Missing field", message: "Post need a question", type: AlertType.warning);
      return;
    } else if (_topics?.isEmpty ?? true) {
      EventHelper.openSnackBar(title: "No Tag", message: "Please select atleast 1 tag for the post", type: AlertType.warning);
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      EventHelper.openLoadingDialog();

      if (FirebaseAuth.instance.currentUser?.uid.isEmpty ?? true) {
        EventHelper.openSnackBar(title: "Access denied", message: "User doesn't exist", type: AlertType.danger);
        EventHelper.closeLoadingDialog();
        return;
      }

      await FirebaseFirestore.instance.collection('posts').add({}).then((postDocument) {
        FirebaseFirestore.instance.collection('posts').doc(postDocument.id).update({
          'id': postDocument.id,
          'owner': FirebaseAuth.instance.currentUser!.uid,
          'content': {
            'data': _question,
            'color': _textColor.toString(),
            'align': _textAlign.toString(),
            "size": 20,
          },
          'background': {
            'color': _backgroundColor.toString(),
          },
          'topics': _topics,
          'options': _options,
        }).then((value) async {
          if (_selectedImage != null) {
            await FirebaseStorage.instance.ref('posts/${postDocument.id}-image.png').putFile(File(_selectedImage!.path)).then((p0) async {
              await FirebaseStorage.instance.ref('posts/${postDocument.id}-image.png').getDownloadURL().then((imageUrl) {
                FirebaseFirestore.instance.collection('posts').doc(postDocument.id).update({
                  'background': {
                    'color': _backgroundColor.toString(),
                    'image': imageUrl,
                  },
                });
              });
            });
          }

          EventHelper.closeLoadingDialog();
        }).then((value) {
          FirebaseFirestore.instance.collection('users').where('area_of_interest', arrayContainsAny: _topics).get().then((userDocutmentList) {
            for (var userDocument in userDocutmentList.docs) {
              FirebaseFirestore.instance.collection('users').doc(userDocument.id).collection('feeds').doc(postDocument.id).set({});
            }
          });

          setState(() {
            _question = '';

            _questionController.clear();
            _options.clear();

            _options = [
              '',
              '',
            ];
          });

          if (Get.currentRoute == CreatePostScreen.routeName) {
            Get.back();
            EventHelper.openSnackBar(title: "Success", message: "Successfully create new Post", type: AlertType.success);
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!_authController.isAnonymous.value) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Create Post"),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Post
                  Card(
                    clipBehavior: Clip.hardEdge,
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        // Post
                        SizedBox(
                          height: Get.width,
                          width: Get.width,
                          child: Stack(
                            children: [
                              // Post Background
                              Positioned.fill(
                                child: _selectedImage != null
                                    ? Image.file(
                                        File(_selectedImage!.path),
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: _backgroundColor,
                                      ),
                              ),

                              // Post Content
                              Positioned.fill(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Center(
                                    child: FormBuilderTextField(
                                      cursorColor: Colors.black,
                                      textAlign: _textAlign,
                                      controller: _questionController,
                                      maxLength: 140,
                                      maxLines: null,
                                      style: TextStyle(color: _textColor),
                                      onChanged: (value) => setState(() => _question = value),
                                      decoration: const InputDecoration(
                                        hintText: "Your question here!",
                                        border: InputBorder.none,
                                        counterText: "",
                                      ),
                                      name: 'question',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Divider(height: 0),

                        // Configs
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => _postOptionTap(0),
                              icon: const Icon(Icons.image_outlined),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => _postOptionTap(1),
                              icon: const Icon(Icons.text_fields_outlined),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: _openTopicTagDialog,
                              icon: const Icon(Icons.local_offer_outlined),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Card(
                    margin: EdgeInsets.zero,
                    child: SizedBox(
                      height: 60,
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _postFormatOptionsController,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              IconButton(onPressed: _openBackgroundImagePicker, icon: const Icon(Icons.image_outlined)),
                              const VerticalDivider(indent: 16, endIndent: 16, thickness: 1),
                              IconButton(onPressed: _openBackgroundColorPicker, icon: const Icon(Icons.palette_outlined)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              IconButton(onPressed: () => _changeTextAlign(TextAlign.left), icon: const Icon(Icons.format_align_left)),
                              IconButton(onPressed: () => _changeTextAlign(TextAlign.center), icon: const Icon(Icons.format_align_center)),
                              IconButton(onPressed: () => _changeTextAlign(TextAlign.right), icon: const Icon(Icons.format_align_right)),
                              const VerticalDivider(indent: 16, endIndent: 16, thickness: 1),
                              IconButton(onPressed: _openTextColorPicker, icon: const Icon(Icons.palette_outlined)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Options
                  Form(
                    key: _formKey,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _options.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 8);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return OptionInputWidget(
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _options[index] = value;
                              });
                            }
                          },
                          onClearPressed: (index == 2 || index == 3)
                              ? () {
                                  setState(() {
                                    _options.removeAt(index);
                                  });
                                }
                              : null,
                          index: index,
                          name: 'option_$index',
                        );
                      },
                    ),
                  ),

                  if (_options.length < 4)
                    ListTile(
                      dense: true,
                      onTap: _options.length < 4 ? () => setState(() => _options.add('')) : null,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      leading: Icon(
                        Icons.add,
                        color: Get.theme.primaryColor,
                      ),
                      title: Text(
                        "Add new option",
                        style: TextStyle(color: Get.theme.primaryColor),
                      ),
                    ),

                  ElevatedButton(onPressed: _createPost, child: const Text("Create Post"))
                ],
              ),
            ),
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Create Post"),
          ),
          body: const EmptyDataWidget(
            icon: Icons.login_outlined,
            text: "Please login to create a post",
          ),
        );
      }
    });
  }
}

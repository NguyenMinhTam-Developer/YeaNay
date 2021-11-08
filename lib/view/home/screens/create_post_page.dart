import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yea_nay/view/event_helper.dart';
import 'package:yea_nay/view/login/widgets/image_picker_dialog.dart';
import 'package:yea_nay/view/topic_picker_dialog.dart';
import 'package:yea_nay/view/widgets/option_input_widget.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _postFormatOptionsController = PageController();

  XFile? _selectedImage;
  String? _question;

  final List<String> _options = [
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
          topics: _topics!,
        );
      },
    );

    setState(() {});
  }

  _createPost() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_question?.isEmpty ?? true) {
      EventHelper.openSnackBar(title: "Missing field", message: "Post need a question", type: AlertType.warning);
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

      await FirebaseFirestore.instance.collection('posts').add({
        'user_id': FirebaseAuth.instance.currentUser!.uid,
        'content': {'question': _question, 'question_color': _textColor.toString(), 'question_text_align': _textAlign.toString()},
        'topics': _topics,
        'options': _options,
      }).then((postDoc) async {
        if (_selectedImage != null) {
          await FirebaseStorage.instance.ref('posts/${postDoc.id}-image.png').putFile(File(_selectedImage!.path)).then((p0) async {
            await FirebaseStorage.instance.ref('posts/${postDoc.id}-image.png').getDownloadURL().then((imageUrl) {
              FirebaseFirestore.instance.collection('posts').doc(postDoc.id).update({
                'background': {
                  'background_color': _backgroundColor.toString(),
                  'background_image': imageUrl,
                },
              });
            });
          });
        }

        EventHelper.closeLoadingDialog();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
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
  }
}

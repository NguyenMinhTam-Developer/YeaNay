import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:image_picker/image_picker.dart';

class OpinionWidget extends StatefulWidget {
  const OpinionWidget({Key? key}) : super(key: key);

  @override
  _OpinionWidgetState createState() => _OpinionWidgetState();
}

class _OpinionWidgetState extends State<OpinionWidget> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController option1 = TextEditingController();
  TextEditingController option2 = TextEditingController();
  TextEditingController option3 = TextEditingController();
  TextEditingController option4 = TextEditingController();
  FocusNode? titleNode;
  Color containerColor = Colors.redAccent;
  bool isImageSelected = false;
  bool isTextAdded = false;
  String? imageFile;
  Alignment textAlignment = Alignment.center;
  Size imageSize = const Size(0, 0);
  int textCount = 0;
  int optionOneCount = 0;
  int optionTwoCount = 0;
  int optionThreeCount = 0;
  int optionFourCount = 0;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    option1 = TextEditingController();
    option2 = TextEditingController();
    option3 = TextEditingController();
    option4 = TextEditingController();
    titleNode = FocusNode();
  }

  @override
  void dispose() {
    titleController.dispose();
    option1.dispose();
    option1.dispose();
    option1.dispose();
    option1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.white, statusBarIconBrightness: Brightness.light),
          backgroundColor: Colors.white,
          title: const Text('Create Post'),
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// main post container
                      Container(
                        color: containerColor,
                        height: 300,
                        child: Stack(
                          children: <Widget>[
                            isImageSelected
                                ? ImageContainer(
                                    image: File(''),
                                    key: Key(imageFile!),
                                    imageSize: imageSize,
                                    // image: getImageFile(imageFile),
                                  )
                                : Container(),
                            isImageSelected && isTextAdded
                                ? Container(
                                    color: Colors.black45.withOpacity(0.4),
                                  )
                                : Container(),
                            isTextAdded
                                ? Align(
                                    alignment: textAlignment,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: titleController,
                                        textInputAction: TextInputAction.done,
                                        focusNode: titleNode,
                                        keyboardType: TextInputType.multiline,
                                        // cursorColor: contrastColor(containerColor),
                                        textAlign: TextAlign.center,
                                        minLines: 1,
                                        maxLines: 6,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(140),
                                        ],
                                        onChanged: (value) {
                                          if (value.isNotEmpty) {
                                            textCount = value.length;
                                          } else {
                                            textCount = 0;
                                          }
                                          setState(() {});
                                        },
                                        decoration: const InputDecoration(
                                          // counterStyle: TextStyle(color: contrastColor(containerColor)),
                                          hintText: 'Your Awesome text here',
                                          // hintStyle: TextStyle(color: contrastColor(containerColor),fontWeight: FontWeight.bold),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.all(8.0),
                                        ),
                                        // style: TextStyle(color: contrastColor(containerColor), fontSize: 30, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                : Container(),

                            /// text lenght count
                            Positioned(
                              right: 10,
                              top: 10,
                              child: isTextAdded
                                  ? Text(
                                      '$textCount / 140',
                                      style: const TextStyle(fontSize: 16),
                                    )
                                  : Container(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Options'),
                            Text(
                              'Min 2 option required',
                              style: TextStyle(fontSize: 8),
                            ),
                          ],
                        ),
                      ),

                      OptionTextContainer(
                        controller: option1,
                        currentCount: optionOneCount,
                        onChange: (String value) {
                          if (value.isNotEmpty) {
                            optionOneCount = value.length;
                          } else {
                            optionOneCount = 0;
                          }
                          setState(() {});
                        },
                        lable: 'A',
                      ),
                      OptionTextContainer(
                        controller: option2,
                        currentCount: optionTwoCount,
                        onChange: (String value) {
                          if (value.isNotEmpty) {
                            optionTwoCount = value.length;
                          } else {
                            optionTwoCount = 0;
                          }
                          setState(() {});
                        },
                        lable: 'B',
                      ),
                      OptionTextContainer(
                        controller: option3,
                        currentCount: optionThreeCount,
                        onChange: (String value) {
                          if (value.isNotEmpty) {
                            optionThreeCount = value.length;
                          } else {
                            optionThreeCount = 0;
                          }
                          setState(() {});
                        },
                        lable: 'C',
                      ),
                      OptionTextContainer(
                        controller: option4,
                        currentCount: optionFourCount,
                        onChange: (String value) {
                          if (value.isNotEmpty) {
                            optionFourCount = value.length;
                          } else {
                            optionFourCount = 0;
                          }
                          setState(() {});
                        },
                        lable: 'D',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            MediaQuery.of(context).viewInsets.bottom == 0
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isTextAdded
                          ? SizedBox(
                              height: 50,
                              width: size.width,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        textAlignment = Alignment.bottomCenter;
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.vertical_align_bottom)),
                                  IconButton(
                                      onPressed: () {
                                        textAlignment = Alignment.center;
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.vertical_align_center)),
                                  IconButton(
                                      onPressed: () {
                                        textAlignment = Alignment.topCenter;
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.vertical_align_top)),
                                ],
                              ),
                            )
                          : Container(),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return Column(
                                          children: <Widget>[
                                            MaterialColorPicker(
                                              shrinkWrap: true,
                                              selectedColor: containerColor,
                                              onColorChange: (color) => setState(() {
                                                containerColor = color;
                                                isImageSelected = false;
                                              }),
                                              // onMainColorChange: (color) => setState(() => containerColor = color),
                                              onBack: () {},
                                            ),
                                            //  raisedButton(
                                            //     title: 'Close',
                                            //     function: () {
                                            //       Navigator.of(context).pop();
                                            //     })
                                          ],
                                        );
                                      });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        padding: const EdgeInsets.all(0.0),
                                        // color: contrastColor(containerColor),
                                        child: Icon(
                                          Icons.font_download,
                                          size: 30,
                                          color: containerColor,
                                        )),
                                    const Text(
                                      'Color',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: GestureDetector(
                                onTap: () async {
                                  final result = await ImagePicker().pickImage(
                                    imageQuality: 70,
                                    maxWidth: 1440,
                                    source: ImageSource.gallery,
                                  );

                                  if (result != null) {
                                    final bytes = await result.readAsBytes();
                                    final image = await decodeImageFromList(bytes);
                                    imageSize = Size(image.width.toDouble(), image.height.toDouble());
                                    isImageSelected = true;
                                    imageFile = result.path.toString();
                                  } else {
                                    isImageSelected = false;
                                  }

                                  setState(() {});

                                  final file = await ImagePicker().pickImage(source: ImageSource.gallery);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Icon(
                                      Icons.image,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      'Image',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isTextAdded = !isTextAdded;
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    Icon(
                                      Icons.title,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      'Text',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  final Size imageSize;
  final File image;

  const ImageContainer({required Key key, required this.imageSize, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageSize.aspectRatio == 0) {
      return SizedBox(
        height: imageSize.height,
        width: imageSize.width,
      );
    } else if (imageSize.aspectRatio < 0.1 || imageSize.aspectRatio > 10) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 64,
            width: 64,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image(
                fit: BoxFit.cover,
                image: FileImage(image),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(
        height: 300,
        constraints: BoxConstraints(
          maxHeight: 300,
          minWidth: MediaQuery.of(context).size.width,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: FileImage(image),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AspectRatio(
            aspectRatio: imageSize.aspectRatio > 0 ? imageSize.aspectRatio : 1,
            child: Image(
              fit: BoxFit.contain,
              image: FileImage(image),
            ),
          ),
        ),
      );
    }
  }
}

class OptionTextContainer extends StatelessWidget {
  final TextEditingController controller;
  final int currentCount;
  final Function onChange;
  final String lable;

  const OptionTextContainer({
    Key? key,
    required this.controller,
    required this.currentCount,
    required this.onChange,
    required this.lable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        height: 50,
        width: size.width,
        decoration: BoxDecoration(border: Border.all(color: Colors.white)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                lable,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 31),
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(40),
                ],
                // onChanged: onChange,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: 'Option',
                ),
              ),
            ),
            Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.only(right: 2),
                child: Text(
                  '$currentCount / 40',
                  style: const TextStyle(fontSize: 12),
                )),
          ],
        ),
      ),
    );
  }
}

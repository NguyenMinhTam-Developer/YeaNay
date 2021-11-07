import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerDialog extends StatelessWidget {
  const ImagePickerDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ImagePicker _picker = ImagePicker();

    return SimpleDialog(
      title: const Text("Pick your avatar from?"),
      children: [
        SimpleDialogOption(
          padding: EdgeInsets.zero,
          child: SimpleDialogItem(
            icon: Icons.camera,
            color: Theme.of(context).colorScheme.primary,
            text: "Camera",
            onPressed: () async {
              Get.back<XFile?>(
                result: await _picker.pickImage(
                  source: ImageSource.camera,
                ),
              );
            },
          ),
        ),
        SimpleDialogOption(
          padding: EdgeInsets.zero,
          child: SimpleDialogItem(
            icon: Icons.collections,
            color: Theme.of(context).colorScheme.primary,
            text: "Gallery",
            onPressed: () async {
              Get.back<XFile?>(
                result: await _picker.pickImage(
                  source: ImageSource.gallery,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SimpleDialogItem extends StatelessWidget {
  const SimpleDialogItem({required this.icon, required this.color, required this.text, required this.onPressed});

  final IconData icon;
  final Color color;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: ListTile(
        onTap: onPressed,
        dense: true,
        leading: Icon(icon),
        title: Text(text, style: Theme.of(context).textTheme.bodyText1),
      ),
    );
  }
}

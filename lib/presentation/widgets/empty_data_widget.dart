import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yea_nay/configs/theme_config.dart';

class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({
    Key? key,
    required this.icon,
    this.text,
  }) : super(key: key);

  final IconData icon;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(Get.width * 0.1),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.primary.withOpacity(0.04)),
                child: Icon(
                  icon,
                  size: Get.width * 0.1,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              if (text != null && text!.isNotEmpty) const SizedBox(height: SizeConfig.padding),
              if (text != null && text!.isNotEmpty)
                Text(
                  text!,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
            ],
          ),
        ),
        ListView()
      ],
    );
  }
}

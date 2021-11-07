import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AlertType {
  primary,
  secondary,
  success,
  danger,
  warning,
  info,
}

class EventHelper {
  // Snack Bar
  EventHelper.openSnackBar({required String title, required String message, required AlertType type, SnackPosition position = SnackPosition.TOP, IconData icon = Icons.announcement, Color backgroundColor = Colors.grey, Color textColor = Colors.black}) {
    switch (type) {
      case AlertType.danger:
        icon = Icons.not_interested;
        backgroundColor = Colors.red;
        textColor = Colors.white;
        break;
      case AlertType.info:
        icon = Icons.flag;
        backgroundColor = Colors.blueAccent;
        textColor = Colors.white;
        break;
      case AlertType.success:
        backgroundColor = Colors.green;
        icon = Icons.check_circle;
        textColor = Colors.white;
        break;
      case AlertType.warning:
        icon = Icons.report;
        backgroundColor = Colors.orange;
        textColor = Colors.black;
        break;
      default:
    }

    EventHelper.closeSnackBar();

    Get.snackbar(
      title.capitalizeFirst!,
      message.capitalizeFirst!,
      animationDuration: const Duration(milliseconds: 300),
      duration: const Duration(seconds: 5),
      isDismissible: true,
      icon: Icon(
        icon,
        color: textColor,
        size: 24,
      ),
      backgroundGradient: LinearGradient(colors: [
        backgroundColor.withOpacity(0.75),
        backgroundColor.withOpacity(0.25),
      ]),
      snackPosition: position,
      backgroundColor: backgroundColor,
      colorText: textColor,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
    );
  }

  EventHelper.closeSnackBar() {
    if (Get.isSnackbarOpen != null && Get.isSnackbarOpen!) Get.back();
  }

  // Loader Dialog
  EventHelper.openLoadingDialog() {
    Get.dialog(const LoadingWidget());
  }

  EventHelper.closeLoadingDialog() {
    if (Get.isDialogOpen != null && Get.isDialogOpen!) Get.back();
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}

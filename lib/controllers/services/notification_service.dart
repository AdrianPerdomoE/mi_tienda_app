import 'package:flutter/material.dart';

enum NotificationType { success, warning, error, info }

class NotificationService {
  void showNotificationBottom(
      BuildContext context, String message, NotificationType type) {
    Color bgColor;

    switch (type) {
      case NotificationType.success:
        bgColor = Colors.green;
        break;
      case NotificationType.warning:
        bgColor = Colors.orange;
        break;
      case NotificationType.error:
        bgColor = Colors.red;
        break;
      case NotificationType.info:
        bgColor = Colors.blue;
        break;
    }
    ScaffoldMessengerState messanger = ScaffoldMessenger.of(context);
    messanger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'Cerrar',
          textColor: Colors.white,
          onPressed: () {
            messanger.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void show(
  BuildContext context, {
  required String message,
  String? actionLabel,
  VoidCallback? onAction,
  Color backgroundColor = const Color(0xFF212121),
  Color textColor = Colors.white,
  Color actionTextColor = Colors.amberAccent,
  Duration duration = const Duration(seconds: 4),
  IconData? icon,                    
  Color? iconColor,                 
}) {
  final contentRow = Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Expanded(
        child: Text(
          message,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
      ),
      if (icon != null)
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Icon(
            icon,
            color: iconColor ?? Colors.green,
            size: 22,
          ),
        ),
    ],
  );

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: contentRow,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      action: (actionLabel != null && onAction != null)
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onAction,
              textColor: actionTextColor,
            )
          : null,
    ),
  );
}

import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final String thingToConfirmText;

  const ConfirmationDialog({
    Key? key,
    required this.onConfirm,
    required this.thingToConfirmText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(thingToConfirmText),
      content: Text('Вы уверены?'),
      actions: <Widget>[
        TextButton(
          child: Text('Отмена'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        TextButton(
          child: Text('Подтвердить'),
          onPressed: () {
            onConfirm();
          },
        ),
      ],
    );
  }
}

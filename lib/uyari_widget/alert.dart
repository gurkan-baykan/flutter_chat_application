import 'package:flutter/material.dart';

class AlertWidget extends StatelessWidget {
  String title;
  String? mesaj;
  AlertWidget({required this.title, this.mesaj});

  Future<bool?> goster(BuildContext context) async {
    return await showDialog<bool?>(
      context: context,
      builder: (context) => this,
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('$title'),
      content: mesaj != null ?  Text('${mesaj}') : Text("Lütfen Tekrar deneyiniz ."),
      actions: <Widget>[
        TextButton(
          child: const Text('Anladım'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

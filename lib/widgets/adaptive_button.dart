import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveButton extends StatelessWidget {
  final String text;
  final VoidCallback handler;
  const AdaptiveButton(this.text, this.handler, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: handler,
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).primaryColor),
            ),
          )
        : FlatButton(
            onPressed: handler,
            child: Text(
              'Choose date',
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).primaryColor),
            ),
          );
  }
}

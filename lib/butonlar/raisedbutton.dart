

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyRaisedButton extends StatelessWidget {
  
  final VoidCallback? press;
  final Color? color;
  final String? text;
  final Widget? buttonIcon;

  MyRaisedButton({this.color, this.text, this.press, this.buttonIcon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: 350,
        child: RaisedButton(
            onPressed: press,
            color: color,
            child: Row(children: [
             Container(width: 25,height: 25, child: buttonIcon),
             SizedBox(width:10),
             Text(text.toString(),style: TextStyle(color: Colors.white,fontSize: 16))
            ]),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.4))));
  }
}

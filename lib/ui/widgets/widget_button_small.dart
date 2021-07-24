import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerdiary/utils/styles.dart';

class ButtonSmallWidget extends StatelessWidget {
  final String title;
  final Function onPressed;
  final bool isEnabled;

  ButtonSmallWidget({this.title, this.onPressed, this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Container(
          width: MediaQuery.of(context).size.width / 5,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isEnabled ? primaryColor : Colors.grey,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.5),
                  offset: Offset(0.0, 1.5),
                  blurRadius: 10,
                ),
              ]),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: onPressed,
                child: Center(
                  child: Text(
                    title,
                    style: isEnabled
                        ? style_ButtonSmallNormalTextWhite
                        : style_ButtonSmallNormalTextGrey,
                  ),
                )),
          ),
        ));
  }
}

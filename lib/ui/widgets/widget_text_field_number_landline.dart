import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:powerdiary/utils/styles.dart';

class TextFeildLandlineNumberWidget extends StatefulWidget {
  String hint;
  TextEditingController controller;
  IconData iconData;
  bool optional;

  TextFeildLandlineNumberWidget({
    this.hint,
    this.controller,
    this.iconData,
    this.optional = false,
  });

  @override
  _TextFeildLandlineNumberWidgetState createState() =>
      _TextFeildLandlineNumberWidgetState();
}

class _TextFeildLandlineNumberWidgetState
    extends State<TextFeildLandlineNumberWidget> {
  bool isEmptyValidated = true;
  bool isNumberValidated = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            Container(
              height: 70,
              child: Card(
                elevation: 8,
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(11),
                    FilteringTextInputFormatter.deny(RegExp(r"[ ]")),
                  ],
                  onChanged: (v) {
                    fieldValidation(v);
                  },
                  onFieldSubmitted: (v) {
                    fieldValidation(v);
                  },
                  controller: widget.controller,
                  validator: (v) {
                    return fieldValidation(v);
                  },
                  decoration: InputDecoration(
                      errorText: "",
                      contentPadding: EdgeInsets.only(
                        left: 20,
                        top: 20,
                      ),
                      suffixIcon: widget.iconData != null
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                              child: Icon(
                                widget.iconData,
                                color: Colors.grey,
                              ),
                            )
                          : null,
                      hintText: widget.hint,
                      hintStyle: style_InputHintText,
                      border: InputBorder.none),
                ),
              ),
            ),
            !isEmptyValidated || !isNumberValidated
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
                        child: Text(
                          !isEmptyValidated
                              ? "Required Field"
                              : !isNumberValidated
                                  ? "Enter valid Number"
                                  : "",
                          style: style_InputErrorText,
                        )),
                  )
                : Container()
          ],
        ));
  }

  String fieldValidation(String v) {
    if (widget.optional && v.isEmpty) {
      setState(() {
        isEmptyValidated = true;
        isNumberValidated = true;
      });
      return null;
    } else {
      setState(() {
        isEmptyValidated = widget.optional ? true : v.isNotEmpty;
        isNumberValidated = v.length == 11 ? true : false;
      });
      return isEmptyValidated && isNumberValidated ? null : "";
    }
  }
}

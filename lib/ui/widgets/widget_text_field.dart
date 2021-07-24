import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerdiary/utils/styles.dart';

class TextFeildWidget extends StatefulWidget {
  String hint;
  TextEditingController controller;
  bool isEmail;
  bool isPassword;
  IconData iconData;
  bool isNumber;
  bool optional;
  final Function onTouch;
  bool readOnly;
  bool isPostCode;

  TextFeildWidget(
      {this.hint,
      this.controller,
      this.iconData,
      this.optional = false,
      this.isPostCode = false,
      this.isNumber = false,
      this.isPassword = false,
      this.isEmail = false,
      this.onTouch,
      this.readOnly = false});

  @override
  _TextFeildWidgetState createState() => _TextFeildWidgetState();
}

class _TextFeildWidgetState extends State<TextFeildWidget> {
  bool isEmptyValidated = true;
  bool isEmailValidated = true;
  bool isPostCodeValidated = true;

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
                  textCapitalization: TextCapitalization.sentences,
                  textAlignVertical: TextAlignVertical.center,
                  onTap: widget.onTouch,
                  readOnly: widget.readOnly,
                  keyboardType: widget.isNumber
                      ? TextInputType.number
                      : TextInputType.text,
                  obscureText: widget.isPassword,
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
            !isEmptyValidated || !isEmailValidated || !isPostCodeValidated
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
                        child: Text(
                          !isEmailValidated
                              ? "Enter Valid Email"
                              : !isPostCodeValidated
                                  ? "Enter Valid Post Code"
                                  : "Required Field",
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
        isEmailValidated = true;
        isEmptyValidated = true;
      });
      return null;
    } else {
      setState(() {
        isEmailValidated = widget.isEmail ? v.isValidEmail() : true;
        isEmptyValidated = widget.optional ? true : v.isNotEmpty;
        isPostCodeValidated = widget.isPostCode ? v.isValidPostCode() : true;
      });
      return isEmailValidated && isEmptyValidated && isPostCodeValidated
          ? null
          : "";
    }
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension PostCodeValidator on String {
  bool isValidPostCode() {
    return RegExp(
            r'^(([A-Z]{1,2}[0-9][A-Z0-9]?|ASCN|STHL|TDCU|BBND|[BFS]IQQ|PCRN|TKCA) ?[0-9][A-Z]{2}|BFPO ?[0-9]{1,4}|(KY[0-9]|MSR|VG|AI)[ -]?[0-9]{4}|[A-Z]{2} ?[0-9]{2}|GE ?CX|GIR ?0A{2}|SAN ?TA1)$')
        .hasMatch(this);
  }
}

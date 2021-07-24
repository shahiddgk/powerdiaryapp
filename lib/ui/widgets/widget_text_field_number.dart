import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:powerdiary/utils/styles.dart';

class TextFeildNumberWidget extends StatefulWidget {
  String hint;
  TextEditingController controller;
  IconData iconData;
  bool optional;

  TextFeildNumberWidget(
      {this.hint, this.controller, this.iconData, this.optional = false});

  @override
  _TextFeildNumberWidgetState createState() => _TextFeildNumberWidgetState();
}

class _TextFeildNumberWidgetState extends State<TextFeildNumberWidget> {
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
                    LengthLimitingTextInputFormatter(14),
                    FilteringTextInputFormatter.deny(RegExp(r"[ ]")),
                    // BlacklistingTextInputFormatter(RegExp("[ ]"))
                  ],
                  onChanged: (v) {
                    v.replaceAll(" ", "");
                    numberValidation(v);
                  },
                  onFieldSubmitted: (v) {
                    numberValidation(v);
                  },
                  controller: widget.controller,
                  validator: (v) {
                    return numberValidation(v);
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

  String numberValidation(String v) {
    if (widget.optional) {
      if (v.length > 0) {
        setState(() {
          isNumberValidated = v.length == 11;
        });
      }
      setState(() {
        isEmptyValidated = true;
      });
      return null;
    } else {
      if (v.length > 0) {
        setState(() {
          isNumberValidated = v.length == 11;
        });
      }
      setState(() {
        isEmptyValidated = v.isNotEmpty;
      });
      return v.isNotEmpty ? null : "";
    }
  }
}

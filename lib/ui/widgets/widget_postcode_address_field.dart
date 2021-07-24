import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerdiary/models/pd_location.dart';
import 'package:powerdiary/models/postcode_location.dart';
import 'package:powerdiary/utils/styles.dart';
import 'package:powerdiary/utils/utils.dart';
import 'package:http/http.dart' as http;

class PostCodeAddressTextFeildWidget extends StatefulWidget {
  TextEditingController controller;
  bool isPostCode;
  final Function onClick;

  PostCodeAddressTextFeildWidget(
      {this.controller, this.isPostCode = false, this.onClick});

  @override
  _PostCodeAddressTextFeildWidgetState createState() =>
      _PostCodeAddressTextFeildWidgetState();
}

class _PostCodeAddressTextFeildWidgetState
    extends State<PostCodeAddressTextFeildWidget> {
  final GlobalKey<FormState> _dropdownFormKey = GlobalKey<FormState>();
  bool isEmptyValidated = true;
  bool validAddress = true;
  PostcodeLocation _postcodeLocation;
  bool isPostCodeValidated = true;
  Function onValueChange;
  String postcode;

  @override
  void initState() {
    super.initState();
  }

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
                child: Row(
                  children: [
                    Flexible(
                        child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.text,
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
                          hintText: "Post Code",
                          hintStyle: style_InputHintText,
                          border: InputBorder.none),
                    )),
                    if (widget.controller.text.isNotEmpty)
                      IconButton(
                        onPressed: widget.onClick,
                        icon: Icon(
                          Icons.my_location,
                        ),
                        color: widget.controller.text.isNotEmpty
                            ? Colors.blue
                            : Colors.grey,
                      )
                  ],
                ),
              ),
            ),
            !isEmptyValidated || !isPostCodeValidated
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
                        child: Text(
                          !isEmptyValidated
                              ? "Post Code is Required"
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
    if (v.isEmpty) {
      setState(() {
        isEmptyValidated = true;
      });
      return null;
    } else {
      setState(() {
        isPostCodeValidated = widget.isPostCode ? v.isValidPostCode() : true;
      });
      return isEmptyValidated && isPostCodeValidated ? null : "";
    }
  }

  _validateAddress(String v) {
    setState(() {
      isEmptyValidated = v.isNotEmpty;
      validAddress = _postcodeLocation == null ? false : true;
    });
    return isEmptyValidated & validAddress ? null : "";
  }
}

extension PostCodeValidator on String {
  bool isValidPostCode() {
    return RegExp(
            r'^(([A-Z]{1,2}[0-9][A-Z0-9]?|ASCN|STHL|TDCU|BBND|[BFS]IQQ|PCRN|TKCA) ?[0-9][A-Z]{2}|BFPO ?[0-9]{1,4}|(KY[0-9]|MSR|VG|AI)[ -]?[0-9]{4}|[A-Z]{2} ?[0-9]{2}|GE ?CX|GIR ?0A{2}|SAN ?TA1)$')
        .hasMatch(this);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerdiary/utils/styles.dart';

class DropdownFeildWidget extends StatefulWidget {
  String initialState;
  final Function(String value) onValueChange;
  final List<DropdownMenuItem<String>> items;
  final String hintText;

  DropdownFeildWidget(
      {this.initialState, this.items, this.hintText, this.onValueChange});

  @override
  _DropdownFeildWidgetState createState() => _DropdownFeildWidgetState();
}

class _DropdownFeildWidgetState extends State<DropdownFeildWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(children: [
          Container(
              height: 70,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 9,
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField<String>(
                      validator: (value) {
                        if (value == null || value.length == 0) {
                          return 'Please select one options';
                        }
                      },
                      value: widget.initialState,
                      iconSize: 30,
                      icon: (null),
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                      hint: Text(widget.hintText),
                      onChanged: (String newValue) =>
                          widget.onValueChange(newValue),
                      items: widget.items ?? [],
                    ),
                  ),
                ),
              )),
        ]));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerdiary/utils/styles.dart';

class DropdownPaymentFeildWidget extends StatefulWidget {
  int initialState;
  final Function(int value) onValueChange;
  final List<DropdownMenuItem<int>> items;
  final String hintText;

  DropdownPaymentFeildWidget(
      {this.initialState, this.items, this.hintText, this.onValueChange});

  @override
  _DropdownPaymentFeildWidgetState createState() =>
      _DropdownPaymentFeildWidgetState();
}

class _DropdownPaymentFeildWidgetState
    extends State<DropdownPaymentFeildWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(children: [
          Container(
              height: 70,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 8,
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<int>(
                      value: widget.initialState,
                      iconSize: 30,
                      icon: (null),
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                      hint: Text(widget.hintText),
                      onChanged: (int newValue) =>
                          widget.onValueChange(newValue),
                      items: widget.items ?? [],
                    ),
                  ),
                ),
              )),
          if (widget.initialState == null)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
                  child: Text(
                    "Required Field",
                    style: style_InputErrorText,
                  )),
            )
        ]));
  }
}

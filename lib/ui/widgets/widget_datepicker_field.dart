import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:powerdiary/utils/styles.dart';

class CustomDatePickerWidget extends StatefulWidget {
  String hint;
  TextEditingController controller;

  CustomDatePickerWidget({this.hint, this.controller});

  @override
  _CustomDatePickerWidgetState createState() => _CustomDatePickerWidgetState();
}

class _CustomDatePickerWidgetState extends State<CustomDatePickerWidget> {
  bool isEmptyValidated = true;

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
                  onTap: () => _selectDate(context),
                  readOnly: true,
                  onChanged: (v) {
                    setState(() {
                      isEmptyValidated = v.isNotEmpty;
                    });
                  },
                  onFieldSubmitted: (v) {
                    setState(() {
                      isEmptyValidated = v.isNotEmpty;
                    });
                  },
                  controller: widget.controller,
                  validator: (v) {
                    setState(() {
                      isEmptyValidated = v.isNotEmpty;
                    });
                    return v.isNotEmpty ? null : "";
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      errorText: "",
                      contentPadding: EdgeInsets.only(
                        left: 20,
                        top: 20,
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                        child: Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                        ),
                      ),
                      hintText: widget.hint,
                      hintStyle: style_InputHintText,
                      border: InputBorder.none),
                ),
              ),
            ),
            !isEmptyValidated
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
                        child: Text(
                          "Please select date",
                          style: style_InputErrorText,
                        )),
                  )
                : Container()
          ],
        ));
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        widget.controller.text =  DateFormat('yyyy-MM-dd').format(picked);
      });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:powerdiary/utils/styles.dart';

class TimePickerWidget extends StatefulWidget {
  String hint;
  TextEditingController controller;

  TimePickerWidget({this.hint, this.controller});

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  bool isEmptyValidated = true;

  //DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  //String _hour, _minute, _time;

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
                  onTap: () => _selectTime(context),
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
                          Icons.timer,
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
                          "Please select time",
                          style: style_InputErrorText,
                        )),
                  )
                : Container()
          ],
        ));
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        // _hour = selectedTime.hour.toString();
        // _minute = selectedTime.minute.toString();
        // _time = _hour + ' : ' + _minute;
        widget.controller.text =
            MaterialLocalizations.of(context).formatTimeOfDay(selectedTime);
      });
  }
}

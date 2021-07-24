import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerdiary/models/response/service_list_response.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';

class MultiSelectServicesWidget extends StatefulWidget {
  MultiSelectServicesWidget(
      {Key key,
      this.serviceList,
      this.controller,
      this.hint,
      this.onItemChange,
      this.selectedServices})
      : super(key: key);

  final List<ServiceReadResponse> serviceList;
  final TextEditingController controller;
  final String hint;
  final Function(List, int) onItemChange;
  final List selectedServices;

  @override
  State<StatefulWidget> createState() => _MultiSelectServicesWidgetState();
}

class _MultiSelectServicesWidgetState extends State<MultiSelectServicesWidget> {
  void _onCancelTap() {
    widget.serviceList.forEach((element) {
      if (!widget.selectedServices.contains("${element.id}")) {
        setState(() {
          element.isSelected = false;
        });
      }
    });
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _onSubmitTap() {
    List selected = [];
    String text = "";
    int totalPrice = 0;
    widget.serviceList.forEach((element) {
      if (element.isSelected) {
        selected.add("${element.id}");
        text += element.name + ", ";
        totalPrice += element.price;
      }
    });
    text = text.trim().substring(0, text.length - 2);
    setState(() {
      widget.controller.text = text;
    });
    widget.onItemChange(selected, totalPrice);
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return TextFeildWidget(
      readOnly: true,
      onTouch: () {
        showDialog(
            context: context,
            builder: (BuildContext cx) {
              return AlertDialog(
                title: Text(widget.hint),
                contentPadding: EdgeInsets.only(top: 12.0),
                content: StatefulBuilder(
                    // You need this, notice the parameters below:
                    builder: (BuildContext context, StateSetter setState) {
                  return Container(
                      height: 300.0, // Change as per your requirement
                      width: 300.0, // Change as per your requirement
                      child: ListView.builder(
                          itemCount: widget.serviceList.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return CheckboxListTile(
                                title: Text(widget.serviceList[index].name),
                                value: widget.serviceList[index].isSelected,
                                onChanged: (checked) {
                                  setState(() {
                                    widget.serviceList[index].isSelected =
                                        checked;
                                  });
                                });
                          }));
                }),
                actions: <Widget>[
                  FlatButton(
                    child: Text('CANCEL'),
                    onPressed: _onCancelTap,
                  ),
                  FlatButton(
                    child: Text('OK'),
                    onPressed: _onSubmitTap,
                  )
                ],
              );
            });
      },
      hint: widget.hint,
      controller: widget.controller,
      isNumber: true,
    );
  }
}

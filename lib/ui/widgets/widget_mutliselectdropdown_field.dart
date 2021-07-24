import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class MultiselectDropdownFeildWidget extends StatefulWidget {
  final Function(List value) onValueChange;
  final List<dynamic> items;
  final String hintText;
  final List selectedItems;

  MultiselectDropdownFeildWidget(
      {this.items, this.hintText, this.onValueChange, this.selectedItems});

  @override
  _MultiselectDropdownFeildWidgetState createState() =>
      _MultiselectDropdownFeildWidgetState();
}

class _MultiselectDropdownFeildWidgetState
    extends State<MultiselectDropdownFeildWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 8,
        child: MultiSelectFormField(
          autovalidate: false,
          validator: (value) {
            if (value == null || value.length == 0) {
              return 'Please select one or more options';
            }
          },
          initialValue: widget.selectedItems,
          dataSource: widget.items ?? [],
          title: Text("Services"),
          textField: 'display',
          valueField: 'value',
          okButtonLabel: 'OK',
          cancelButtonLabel: 'CANCEL',
          // required: true,
          hintWidget: Text(
            widget.hintText,
            style: TextStyle(color: Colors.grey),
          ),
          onSaved: (value) {
            if (value == null) return;
            widget.onValueChange(value);
          },
        ),
      ),
    );
  }
}

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerdiary/utils/styles.dart';

class SearchableDropdownFeildWidget extends StatefulWidget {
  dynamic initialState;
  final Function(dynamic value) onValueChange;
  final List<dynamic> items;
  final String hintText;

  SearchableDropdownFeildWidget(
      {this.initialState, this.onValueChange, this.items, this.hintText});

  @override
  _SearchableDropdownFeildWidgetState createState() =>
      _SearchableDropdownFeildWidgetState();
}

class _SearchableDropdownFeildWidgetState
    extends State<SearchableDropdownFeildWidget> {
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
                child: DropdownSearch(
                  items: widget.items ?? [],
                  itemAsString: (dynamic customer) =>
                      "${customer.firstName} ${customer.lastName} ${customer.primaryPhone}",
                  label: widget.hintText,
                  onChanged: (dynamic newValue) =>
                      widget.onValueChange(newValue),
                  showSearchBox: true,
                  selectedItem: widget.initialState,
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

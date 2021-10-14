import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerdiary/models/pd_location.dart';
import 'package:powerdiary/utils/styles.dart';
import 'package:powerdiary/utils/utils.dart';

class AddressTextFeildWidget extends StatefulWidget {
  TextEditingController controller;
  Function(PdLocation) updateLocation;

  AddressTextFeildWidget({this.controller, this.updateLocation});

  @override
  _AddressTextFeildWidgetState createState() => _AddressTextFeildWidgetState();
}

class _AddressTextFeildWidgetState extends State<AddressTextFeildWidget> {
  bool isEmptyValidated = true;
  bool validAddress = true;
  bool locationEnabled = true;
  PdLocation _pdLocation;

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
                        _validateAddress(v);
                      },
                      onFieldSubmitted: (v) {
                        _validateAddress(v);
                      },
                      controller: widget.controller,
                      validator: (v) {
                        return _validateAddress(v);
                      },
                      decoration: InputDecoration(
                          errorText: "",
                          contentPadding: EdgeInsets.only(
                            left: 20,
                            top: 20,
                          ),
                          hintText: "Search Address",
                          hintStyle: style_InputHintText,
                          border: InputBorder.none),
                    )),
                    if (widget.controller.text.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _pdLocation = null;
                          });
                          widget.updateLocation(_pdLocation);
                          _validateAddress("");
                        },
                        icon: Icon(Icons.clear),
                        color: widget.controller.text.isNotEmpty
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    if (widget.controller.text.isNotEmpty)
                      IconButton(
                        onPressed: _getLocationFromAddress,
                        icon: Icon(Icons.search),
                        color: widget.controller.text.isNotEmpty
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    // IconButton(
                    //   onPressed: _getCurrentLocation,
                    //   icon: Icon(Icons.my_location),
                    //   color: Colors.blue,
                    // )
                  ],
                ),
              ),
            ),
            !isEmptyValidated || !validAddress || !locationEnabled
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 2.0, horizontal: 15),
                        child: Text(
                          !isEmptyValidated
                              ? "Address is Required"
                              : !validAddress
                                  ? "Address is Invalid"
                                  : !locationEnabled
                                      ? "Please Enable Location First"
                                      : "",
                          style: style_InputErrorText,
                        )),
                  )
                : Container()
          ],
        ));
  }

  _validateAddress(String v) {
    setState(() {
      isEmptyValidated = v.isNotEmpty;
      validAddress = _pdLocation == null ? false : true;
    });
    return isEmptyValidated & validAddress ? null : "";
  }

  _getCurrentLocation() {
    getCurrentLocation(context).then((value) {
      setState(() {
        _pdLocation = value;
      });
      widget.updateLocation(_pdLocation);
    }).catchError((e) {
      print(e);
      setState(() {
        locationEnabled = false;
      });
    });
  }

  _getLocationFromAddress() {
    getLocationAddress(widget.controller.text).then((value) {
      setState(() {
        _pdLocation = value;
      });
      if (_pdLocation != null) {
        widget.updateLocation(_pdLocation);
      }
      _validateAddress(widget.controller.text);
      print(value);
    }).catchError((e) {
      print(e);
    });
  }
}

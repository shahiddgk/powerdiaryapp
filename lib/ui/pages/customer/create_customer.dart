import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:powerdiary/models/pd_location.dart';
import 'package:powerdiary/models/request/customer_request.dart';
import 'package:powerdiary/models/request/post_code_address_request.dart';
import 'package:powerdiary/models/response/customer_list_response.dart';
import 'package:powerdiary/models/response/post_code_address_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/widgets/widget_address_field.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_dropdown_field.dart';
import 'package:powerdiary/ui/widgets/widget_post_code_drop_down.dart';
import 'package:powerdiary/ui/widgets/widget_postcode_address_field.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/ui/widgets/widget_text_field_number.dart';
import 'package:powerdiary/ui/widgets/widget_text_field_number_landline.dart';
import 'package:powerdiary/utils/utils.dart';
import 'package:http/http.dart' as http;

import '../../../utils/utils.dart';

class CreateCustomer extends StatefulWidget {
  @override
  _CreateCustomerState createState() => _CreateCustomerState();
}

class _CreateCustomerState extends State<CreateCustomer> {
  final GlobalKey<FormState> _customerFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _dropdownKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _primaryPhoneController = new TextEditingController();
  TextEditingController _secondaryPhoneController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _zipController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _referredByController = new TextEditingController();
  bool _isLoading = false;

  PdLocation _pdLocation;

  String api_response = "";

  List<PostCodeReadResponse> addrressList = [];
  String _addressListState;
  String api_key = "ak_kr1v46iv0aNNht6IWqYTiNYN2lxLb";
  String postcode = "GU16 7HF";
  @override
  void initState() {
    _primaryPhoneController = TextEditingController();
    _secondaryPhoneController = TextEditingController();
    super.initState();
  }

  List<String> referredBy = [
    'Google',
    'Leaflet',
    'Recommendation',
    'Repeat client',
    'Seen van',
    'Paper advert'
  ];
  String referredByDropDownValue = 'Google';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Customer'),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 50.0,
              horizontal: 10.0,
            ),
            child: Form(
              key: _customerFormKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextFeildWidget(
                      hint: 'First Name',
                      controller: _firstNameController,
                    ),
                    TextFeildWidget(
                      hint: 'Last Name',
                      controller: _lastNameController,
                    ),
                    TextFeildNumberWidget(
                      optional: true,
                      hint: "Mobile Number",
                      controller: _primaryPhoneController,
                    ),
                    TextFeildLandlineNumberWidget(
                      optional: true,
                      hint: "Landline Number",
                      controller: _secondaryPhoneController,
                    ),
                    TextFeildWidget(
                      hint: 'Email',
                      controller: _emailController,
                      isEmail: true,
                      optional: true,
                    ),
                    PostCodeAddressTextFeildWidget(
                      controller: _zipController,
                      isPostCode: true,
                      onClick: _getAddressesList,
                    ),
                    Visibility(
                      visible:
                          _zipController == 0 || _zipController.text.isEmpty
                              ? false
                              : true,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: PostCodeAddressDropdownFeildWidget(
                          hintText: "Select Address",
                          initialState: _addressListState,
                          onValueChange: (val) {
                            setState(() {
                              _addressListState = val;
                              _addressController.text = val;
                            });
                          },
                          items: addrressList?.map((item) {
                            return new DropdownMenuItem(
                              child: new Text(
                                  "${item.line1},${item.line2},${item.line3}"),
                              value:
                                  '${item.line1},${item.line2},${item.line3}',
                            );
                          })?.toList(),
                        ),
                      ),
                    ),
                    AddressTextFeildWidget(
                      controller: _addressController,
                      updateLocation: updateLocation,
                    ),
                    DropdownFeildWidget(
                      hintText: 'Referred By',

                      initialState: referredByDropDownValue,
                      onValueChange: (val) {
                        setState(() {
                          referredByDropDownValue = val;
                        });
                      },
                      items: referredBy?.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item),
                          value: item,
                        );
                      })?.toList(),
                      // controller: _referredByController,
                      // optional: true,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ButtonWidget(
                            title: "Cancel",
                            isEnabled: false,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        Expanded(
                          child: ButtonWidget(
                            title: "Create",
                            onPressed: _submitCustomer,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
                height: MediaQuery.of(context).size.height,
                child: PDProgressIndicator())
        ],
      ),
    );
  }

  updateLocation(PdLocation value) {
    if (value == null) {
      setState(() {
        _addressController.clear();
        _pdLocation = null;
      });
    } else {
      setState(() {
        _pdLocation = value;
        _addressController.text = _pdLocation.address;
      });
    }
  }

  _getAddressesList() {
    if (_zipController.text == 0 || _zipController.text.isEmpty) {
    } else {
      HTTPManager()
          .getPostCodeAddressListing(PostCodeAddressListRequest(
              _zipController.text.split(" ").join(""), api_key))
          .then((value) {
        setState(() {
          _isLoading = false;
          addrressList = value.values;
          api_response = jsonEncode(value.values);

          print(addrressList);
        });
      }).catchError((e) {
        print(e);
        showAlert(context, e.toString(), true, () {
          setState(() {
            _isLoading = false;
          });
        }, () {
          _getAddressesList();
        });
      });
    }
  }

  _submitCustomer() {
    if (_customerFormKey.currentState.validate() && _pdLocation != null) {
      setState(() {
        _isLoading = true;
      });

      HTTPManager()
          .createCustomer(CustomerCreateRequest(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              primaryPhone: _primaryPhoneController.text,
              secondaryPhone: _secondaryPhoneController.text,
              email: _emailController.text,
              zip: _zipController.text,
              address: _addressController.text,
              // latitude: "${_pdLocation.latitude}",
              // longitude: "${_pdLocation.longitude}",
              referredBy: referredByDropDownValue,
              companyId: '${globalSessionUser.companyId}'))
          .then((value) {
        setState(() {
          _isLoading = false;
        });

        showAlert(context, value.message, false, () {}, () {
          Navigator.of(context).pop(CustomerReadResponse.fromJson(value.data));
        });
      }).catchError((e) {
        print(e);

        showAlert(context, e.toString(), true, () {
          setState(() {
            _isLoading = false;
          });
        }, () {
          _submitCustomer();
        });
      });
    }
  }
}

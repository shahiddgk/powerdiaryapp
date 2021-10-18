import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:powerdiary/models/request/category_request.dart';
import 'package:powerdiary/models/request/service_request.dart';
import 'package:powerdiary/models/response/category_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_dropdown_field.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/utils/utils.dart';

import '../../../utils/utils.dart';

class CreateService extends StatefulWidget {
  @override
  _CreateServiceState createState() => _CreateServiceState();
}

class _CreateServiceState extends State<CreateService> {
  List<CategoryReadResponse> categoryList = [];
  String _categoryListState;

  final GlobalKey<FormState> _serviceFormKey = GlobalKey<FormState>();
  TextEditingController _categoryIdController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _priceController = new TextEditingController();
  TextEditingController _serviceColorController = new TextEditingController();
  TextEditingController _customerMessageController =
      new TextEditingController();
  bool _isLoading = true;

  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  @override
  void initState() {
    _getCategoryList();
    setState(() {
      _priceController.text = "0";
    });
  }

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Service'),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 50.0,
              horizontal: 10.0,
            ),
            child: Form(
              key: _serviceFormKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    DropdownFeildWidget(
                      hintText: "Select Category",
                      initialState: _categoryListState,
                      onValueChange: (val) {
                        setState(() {
                          _categoryListState = val;

                          print(_categoryListState);
                        });
                      },
                      items: categoryList?.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item.name),
                          value: '${item.id}',
                        );
                      })?.toList(),
                    ),
                    TextFeildWidget(
                      hint: 'Name',
                      controller: _nameController,
                    ),
                    TextFeildWidget(
                      hint: 'Price',
                      iconData: FontAwesomeIcons.poundSign,
                      controller: _priceController,
                      optional: true,
                    ),
                    TextFeildWidget(
                      readOnly: true,
                      hint: 'Service Color',
                      onTouch: () {
                        print("This is in onpress of color picker");
                        showDialog(
                          context: context,
                          builder: (BuildContext cx) {
                            return AlertDialog(
                              title: const Text('Pick color'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: pickerColor,
                                  onColorChanged: changeColor,
                                  showLabel: true,
                                  pickerAreaHeightPercent: 0.8,
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Pick Color'),
                                  onPressed: () {
                                    setState(() => currentColor = pickerColor);
                                    var hexCode =
                                        pickerColor.value.toRadixString(16);
                                    setState(() =>
                                        _serviceColorController.text = hexCode);
                                    Navigator.of(context, rootNavigator: true)
                                        .pop('dialog');
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      controller: _serviceColorController,
                    ),
                    // TextFeildWidget(
                    //   hint: 'Customer Message',
                    //   controller: _customerMessageController,
                    //   optional: true,
                    // ),
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
                            onPressed: _submitService,
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

  _getCategoryList() {
    HTTPManager()
        .getCategoryListing(
            CategoryListRequest(companyId: globalSessionUser.companyId))
        .then((value) {
      setState(() {
        _isLoading = false;
        categoryList =
            value.values.where((element) => element.isActive).toList();
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {}, () {
        _getCategoryList();
      });
    });
  }

  _submitService() {
    if (_serviceFormKey.currentState.validate()) {
      print("categoryId:::${_categoryListState}");
      print("name:::${_nameController.text}");
      print(_priceController.text);
      print(_serviceColorController.text);

      setState(() {
        _isLoading = true;
      });
      HTTPManager()
          .createService(ServiceCreateRequest(
        categoryId: _categoryListState,
        name: _nameController.text,
        price: _priceController.text,
        serviceColor: _serviceColorController.text,
        // customerMessage: _customerMessageController.text.isEmpty
        //     ? ''
        //     : _customerMessageController.text,
        companyId: '${globalSessionUser.companyId}',
        id: '${globalSessionUser.id}',
      ))
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        showAlert(context, value.message, false, () {}, () {
          Navigator.of(context).pop();
        });
      }).catchError((e) {
        print(e);
        showAlert(context, e.toString(), true, () {}, () {
          _submitService();
        });
      });
    }
  }
}

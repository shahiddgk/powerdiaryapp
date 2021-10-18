import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:powerdiary/models/request/category_request.dart';
import 'package:powerdiary/models/request/service_request.dart';
import 'package:powerdiary/models/response/category_list_response.dart';
import 'package:powerdiary/models/response/service_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_dropdown_field.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/utils/utils.dart';

class EditService extends StatefulWidget {
  final ServiceReadResponse serviceReadResponse;

  const EditService({Key key, this.serviceReadResponse}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  final GlobalKey<FormState> _serviceFormKey = GlobalKey<FormState>();
  TextEditingController _idController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _priceController = new TextEditingController();
  TextEditingController _serviceColorController = new TextEditingController();
  TextEditingController _customerMessageController =
      new TextEditingController();
  bool _isLoading = true;

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  String categoryListState;
  List<CategoryReadResponse> categoryList = [];

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _idController.text = '${widget.serviceReadResponse.id}';
      _nameController.text = widget.serviceReadResponse.name;
      _priceController.text = '${widget.serviceReadResponse.price}';
      _serviceColorController.text = widget.serviceReadResponse.serviceColor;
      _customerMessageController.text =
          widget.serviceReadResponse.customerMessage;
      categoryListState = '${widget.serviceReadResponse.categoryId}';
    });
    _getCategoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Service'),
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
                      initialState: categoryListState,
                      onValueChange: (val) {
                        setState(() {
                          categoryListState = val;
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
                      optional: true,
                      controller: _priceController,
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
                            title: "Update",
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
      setState(() {
        _isLoading = true;
      });
      print(categoryListState);
      HTTPManager()
          .updateService(ServiceUpdateRequest(
        id: _idController.text,
        categoryId: categoryListState,
        name: _nameController.text,
        price: _priceController.text,
        serviceColor: _serviceColorController.text,
        // customerMessage: _customerMessageController.text.isEmpty
        //     ? ''
        //     : _customerMessageController.text,
        companyId: '${widget.serviceReadResponse.companyId}',
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

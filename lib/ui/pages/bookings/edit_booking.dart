import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:powerdiary/models/multiselect_model.dart';
import 'package:powerdiary/models/request/booking_request.dart';
import 'package:powerdiary/models/request/category_request.dart';
import 'package:powerdiary/models/request/customer_request.dart';
import 'package:powerdiary/models/request/service_request.dart';
import 'package:powerdiary/models/request/tax_info_request.dart';
import 'package:powerdiary/models/response/booking_list_response.dart';
import 'package:powerdiary/models/response/booking_list_weekly_response.dart';
import 'package:powerdiary/models/response/category_list_response.dart';
import 'package:powerdiary/models/response/customer_list_response.dart';
import 'package:powerdiary/models/response/service_list_response.dart';
import 'package:powerdiary/models/response/tax_info_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_datepicker_field.dart';
import 'package:powerdiary/ui/widgets/widget_dropdown_field.dart';
import 'package:powerdiary/ui/widgets/widget_finish_time.dart';
import 'package:powerdiary/ui/widgets/widget_mutiselect_dropdown.dart';
import 'package:powerdiary/ui/widgets/widget_mutliselectdropdown_field.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/ui/widgets/widget_searchable_dropdown_field.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/ui/widgets/widget_timepicker_field.dart';
import 'package:powerdiary/utils/utils.dart';

class EditBooking extends StatefulWidget {
  final BookingReadResponse bookingReadResponse;
  final String category;

  const EditBooking({Key key, this.bookingReadResponse, this.category})
      : super(key: key);

  @override
  _EditBookingState createState() => _EditBookingState();
}

class _EditBookingState extends State<EditBooking> {
  final GlobalKey<FormState> _bookingFormKey = GlobalKey<FormState>();
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _timeController = new TextEditingController();
  TextEditingController _finishController = new TextEditingController();
  TextEditingController _priceController = new TextEditingController();
  TextEditingController _numofDaysController = new TextEditingController();

  TextEditingController _commentsController = new TextEditingController();
  TextEditingController _selectedServicesController =
      new TextEditingController();
  bool _isLoading = true;
  bool checkedValue = true;

  List<CustomerReadResponse> customersList = [];
  CustomerReadResponse selectedCustomer;

  List<CategoryReadResponse> categoryList = [];
  String _categoryListState;
  String _category;

  List<CustomerReadResponse> _searchResult = [];

  List<CategoryServiceNameList> categoryServiceNameList1 = [];
  List<ServiceReadResponse> serviceList = [];
  List services = [];
  List selectedServices = [];
  int servicesSum;
  List servicesIdList = [];
  List availableServicesIdList = [];

  String api_response = "";
  List<TaxInfoResponse> taxList = [];

  dynamic categoryService;
  List<String> categoryNameList = [];
  Map<String, dynamic> categoryServiceNameList = {};
  List categoryServiceList;
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      print("Category:::${widget.category}");
      _categoryListState = "${widget.category}";
      print("_categoryListState:::${_categoryListState}");
      _dateController.text =
          DateFormat('yyyy-MM-dd').format(widget.bookingReadResponse.dueDate);
      if (widget.bookingReadResponse.startTime != null)
        _timeController.text = '${widget.bookingReadResponse.startTime}';
      if (widget.bookingReadResponse.endTime != null)
        _finishController.text = '${widget.bookingReadResponse.endTime}';
      if (widget.bookingReadResponse.totalPrice != null)
        _priceController.text = '${widget.bookingReadResponse.totalPrice}';
      if (widget.bookingReadResponse.comment != null)
        _commentsController.text = '${widget.bookingReadResponse.comment}';
      if (widget.bookingReadResponse.serviceIds != null) {
        availableServicesIdList
            .addAll(widget.bookingReadResponse.serviceIds.split(","));
        _selectedServicesController.text = widget.bookingReadResponse.services;
      }

      if (widget.bookingReadResponse.comment != null) {
        _numofDaysController.text = '${widget.bookingReadResponse.paymentDays}';
        if (_numofDaysController.text == '0') {
          setState(() {
            checkedValue = true;
          });
        } else {
          setState(() {
            checkedValue = false;
          });
        }
      }

      // if (widget.bookingReadResponse.customerId != null)
      //   selectedCustomer = "${widget.bookingReadResponse.customerId}";
    });
    _getCustomerList();
    _getCategoryList();
    _getCategoryServiceList();
    _getTaxList();

    super.initState();
  }

  _getCategoryServicesList(category) {
    print(category);
    print("categoryService:::${categoryService['data'][category]}");
    if (category == _categoryListState) {
      if (categoryService['data'][category] != null &&
          categoryService['data'][category][0] != []) {
        setState(() {
          categoryServiceNameList1.clear();
          categoryServiceNameList = categoryService['data'][category];
          _categoryListState = category;
        });

        categoryServiceNameList.entries
            .map((e) => categoryServiceNameList1
                .add(CategoryServiceNameList(id: e.key, name: e.value)))
            .toList();

        selectedServices.clear();
        print('categoryServiceNameList1:${categoryServiceNameList1}');

        return _categoryListState;
      } else if (categoryService['data'][category] == null ||
          categoryService['data'][category][0] == []) {
        setState(() {
          //services = [];
          selectedServices = [];
          //categoryServiceNameList = [];
        });
      }

      print(categoryServiceNameList);

      setState(() {
        _categoryListState = category;
      });
    }
    return _categoryListState;
  }

  _getCategoryServiceList() {
    http
        .post(
            "https://app.diarymaster.co.uk/api/category-services?company_id=${globalSessionUser.companyId}")
        .then((value) {
      setState(() {
        categoryService = json.decode(value.body);
        print(categoryService);
        for (int i = 0; i < categoryList.length; i++) {
          print(i);
          print(categoryList[i].name);
          setState(() {
            categoryNameList.add(categoryList[i].name);
            print("CategoryNameLis${categoryNameList}");
          });
        }
        _getCategoryServicesList(_categoryListState);
      });
      print(categoryList);
    });
  }

  _getCustomerList() {
    HTTPManager()
        .getCustomerListing(
            CustomerListRequest(companyId: globalSessionUser.companyId))
        .then((value) {
      setState(() {
        customersList = value.values;
        List<CustomerReadResponse> cust = customersList
            .where((element) =>
                element.id == widget.bookingReadResponse.customerId)
            .toList();
        selectedCustomer = cust.length > 0 ? cust[0] : null;
      });
      _getServiceList();
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _getCustomerList();
      });
    });
  }

  _getTaxList() {
    HTTPManager()
        .getTaxListing(TaxListRequest(companyId: globalSessionUser.companyId))
        .then((value) {
      setState(() {
        _isLoading = false;
        taxList = value.values;
        api_response = jsonEncode(value.values);
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _getTaxList();
      });
    });
  }

  _getServiceList() {
    HTTPManager()
        .getServiceListing(
            ServiceListRequest(companyId: globalSessionUser.companyId),
            selectedServices)
        .then((value) {
      setState(() {
        _isLoading = false;
        serviceList =
            value.values.where((element) => element.isActive).toList();
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _getServiceList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Booking'),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 50.0,
              horizontal: 10.0,
            ),
            child: Form(
              key: _bookingFormKey,
              child: SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  CustomDatePickerWidget(
                    hint: 'Booking Date',
                    controller: _dateController,
                  ),
                  TimePickerWidget(
                    hint: 'Booking Time',
                    controller: _timeController,
                  ),
                  DurationFeildWidget(
                    hint: "Finish Time",
                    controller: _finishController,
                    isNumber: true,
                  ),
                  SearchableDropdownFeildWidget(
                    hintText: "Choose Customer",
                    initialState: selectedCustomer,
                    items: customersList,
                    onValueChange: (data) {
                      setState(() {
                        selectedCustomer = data;
                      });
                    },
                  ),

                  // MultiSelectServicesWidget(
                  //   serviceList: serviceList,
                  //   selectedServices: selectedServices,
                  //   controller: _selectedServicesController,
                  //   hint: "Select Services",
                  //   onItemChange: (services, pricing) {
                  //     setState(() {
                  //       selectedServices = services;
                  //       _priceController.text = "$pricing";
                  //     });
                  //   },
                  // ),

                  DropdownFeildWidget(
                    hintText: "Select Category",
                    initialState: _categoryListState,
                    onValueChange: (val) {
                      setState(() {
                        _categoryListState = val;
                        _category = _categoryListState;
                        categoryServiceNameList1.clear();
                        _getCategoryServicesList(val);
                      });
                    },
                    items: categoryList?.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item.name),
                        value: '${item.id}',
                      );
                    })?.toList(),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 8,
                      child: MultiSelectDialogField(
                        buttonIcon: Icon(Icons.arrow_drop_down),
                        height: 250,
                        title: Text('services'),
                        items: categoryServiceNameList1
                            .map((e) => MultiSelectItem<dynamic>(e.id, e.name))
                            .toList(),
                        initialValue: availableServicesIdList,
                        // onSaved: (value) {
                        //   if (value == null) return;
                        //   setState(() {
                        //     serviceList = value;
                        //   });
                        // },
                        onSelectionChanged: (value) {
                          // for (int i = 0; i < value.length; i++) {

                          if (categoryServiceNameList1.contains(services) &&
                              services.isNotEmpty) {
                            // setState(() {
                            //   List availableServices = [];
                            //   services.add(value);
                            //   selectedServices = services;
                            //   selectedServices = selectedServices[
                            //       selectedServices.length - 1];
                            //
                            //   availableServices = value + services;
                            //
                            //   value = availableServices;
                            //   print("Value::${value}");
                            //
                            //   print('Services::${services}');
                            //   print(
                            //       'selectedServices::${selectedServices}');
                            // });
                          } else {
                            List newServicesList = [];
                            //List availableServicesList = [];
                            int totalPrice = int.parse(_priceController.text);

                            if (serviceList.isNotEmpty) {
                              for (int i = 0; i < serviceList.length; i++) {
                                for (int j = 0; j < value.length; j++) {
                                  int serviceID = serviceList[i].id;
                                  String valueId = value[j];
                                  int valueID = int.parse(valueId);
                                  if (serviceID == valueID) {
                                    setState(() {
                                      print(
                                          "serviceList:::${serviceList[i].id}");
                                      print(
                                          "serviceListPrice:::${serviceList[i].price}");
                                      print("value:::${value[j]}");

                                      totalPrice =
                                          totalPrice + serviceList[i].price;

                                      print("totalPrice:::${totalPrice}");
                                    });
                                  }
                                }
                              }
                            }

                            setState(() {
                              newServicesList.add(value);

                              _priceController.text = totalPrice.toString();

                              selectedServices = newServicesList;
                              availableServicesIdList = value;

                              print('newServicesList::${newServicesList}');
                              print('selectedServices::${selectedServices}');
                              print(
                                  'availableServices::${availableServicesIdList}');
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  TextFeildWidget(
                    hint: 'Price',
                    iconData: FontAwesomeIcons.poundSign,
                    controller: _priceController,
                    isNumber: true,
                    //readOnly: true,
                  ),
                  CheckboxListTile(
                    title: Text("Payment upon completion"),
                    value: checkedValue,
                    onChanged: (newValue) {
                      setState(() {
                        checkedValue = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                  Visibility(
                    visible: checkedValue == true ? false : true,
                    child: TextFeildWidget(
                      hint: 'Enter Number of Days',
                      controller: _numofDaysController,
                      optional: true,
                      isNumber: true,
                    ),
                  ),
                  TextFeildWidget(
                    hint: 'Comments',
                    optional: true,
                    controller: _commentsController,
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
                          title: "Submit",
                          onPressed: _submitBooking,
                        ),
                      ),
                    ],
                  )
                ],
              )),
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
        // _categoryListState = categoryList[0].name;
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {}, () {
        _getCategoryList();
      });
    });
  }

  _submitBooking() {
    if (_bookingFormKey.currentState.validate()) {
      setState(() {
        // servicesIdList = selectedServices[0];
        // print('servicesIdList::${servicesIdList}');

        _isLoading = true;
      });
      HTTPManager()
          .updateBooking(BookingUpdateRequest(
        bookingId: '${widget.bookingReadResponse.bookingId}',
        companyId: "${globalSessionUser.companyId}",
        userId: "${globalSessionUser.id}",
        customerId: "${selectedCustomer.id}",
        totalPrice: _priceController.text,
        dueDate: _dateController.text,
        dueTime: _timeController.text,
        finishTime: _finishController.text,
        comment: _commentsController.text,
        serviceId: availableServicesIdList,
        paymentDays: _numofDaysController.text.isEmpty
            ? '${0}'
            : '${_numofDaysController.text}',
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
        setState(() {
          _isLoading = false;
        });
        showAlert(context, e.toString(), true, () {
          setState(() {
            _isLoading = false;
          });
        }, () {
          _submitBooking();
        });
      });
    }
  }
}

class Services {
  int id;
  String name;
  Services(this.id, this.name);
}

class multiselectItem {
  final dynamic display;
  final int value;

  multiselectItem({this.display, this.value});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display'] = this.display;
    data['value'] = this.value;
    return data;
  }
}

class CategoryServiceNameList {
  final String id;
  final String name;

  CategoryServiceNameList({this.id, this.name});

  @override
  String toString() {
    return '{ ${this.name}, ${this.id} }';
  }
}

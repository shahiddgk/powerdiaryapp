import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:powerdiary/models/multiselect_model.dart';
import 'package:powerdiary/models/request/booking_request.dart';
import 'package:powerdiary/models/request/category_request.dart';
import 'package:powerdiary/models/request/customer_request.dart';
import 'package:powerdiary/models/request/permission_request.dart';
import 'package:powerdiary/models/request/service_request.dart';
import 'package:powerdiary/models/request/tax_info_request.dart';
import 'package:powerdiary/models/response/booking_list_response.dart';
import 'package:powerdiary/models/response/category_list_response.dart';
import 'package:powerdiary/models/response/customer_list_response.dart';
import 'package:powerdiary/models/response/permission_list_response.dart';
import 'package:powerdiary/models/response/service_list_response.dart';
import 'package:powerdiary/models/response/tax_info_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/pages/qoute/quote_detail.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_button_small.dart';
import 'package:powerdiary/ui/widgets/widget_datepicker_field.dart';
import 'package:powerdiary/ui/widgets/widget_dropdown_field.dart';
import 'package:powerdiary/ui/widgets/widget_finish_time.dart';
import 'package:powerdiary/ui/widgets/widget_mutliselectdropdown_field.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/ui/widgets/widget_searchable_dropdown_field.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/ui/widgets/widget_timepicker_field.dart';
import 'package:powerdiary/utils/route_manager.dart';
import 'package:powerdiary/utils/utils.dart';

class CreateBooking extends StatefulWidget {
  final BookingReadResponse bookingReadResponse;

  const CreateBooking({Key key, this.bookingReadResponse}) : super(key: key);

  @override
  _CreateBookingState createState() => _CreateBookingState();
}

class _CreateBookingState extends State<CreateBooking> {
  final GlobalKey<FormState> _bookingFormKey = GlobalKey<FormState>();
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _timeController = new TextEditingController();
  TextEditingController _finishtimeController = new TextEditingController();
  TextEditingController _priceController = new TextEditingController();
  TextEditingController _numofDaysController = new TextEditingController();
  TextEditingController _commentsController = new TextEditingController();

  bool _isLoading = true;
  bool checkedValue = true;

  List<CustomerReadResponse> customersList = [];
  CustomerReadResponse selectedCustomer;
  PermissionShowResponse permissionShowResponse;

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

  int _counter = 4;
  Timer _timer;

  void _startTimer() {
    _counter = 4;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  initState() {
    // TODO: implement initState
    if (widget.bookingReadResponse != null) {
      setState(() {
        _dateController.text =
            DateFormat('yyyy-MM-dd').format(widget.bookingReadResponse.dueDate);
        _timeController.text =
            DateFormat.jm().format(widget.bookingReadResponse.dueDate);
        _finishtimeController = TextEditingController(text: "${45}");
      });
    } else {
      setState(() {
        var now = DateTime.now();
        var formatter = new DateFormat('yyyy-MM-dd');
        String fomrmattedDate = formatter.format(now);

        _dateController.text = fomrmattedDate;
        _timeController.text = DateFormat.jm().format(now);
        _finishtimeController = TextEditingController(text: "${45}");
      });
    }
    _getCustomerList();
    _getCategoryList();
    _getCategoryServiceList();
    _getPermissionList();
    _getTaxList();
    _startTimer();

    super.initState();
  }

  _getPermissionList() {
    HTTPManager()
        .getPermissionList(PermissionListRequest(
            companyId: globalSessionUser.companyId,
            roleId: globalSessionUser.roleId))
        .then((value) {
      setState(() {
        _isLoading = false;
        permissionShowResponse = value;
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _getPermissionList();
      });
    });
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
        // categoryServiceList
        //     .sublist(categoryService['data'][categoryList[i].name]);
      });
      print(categoryList);
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

  _getCustomerList() {
    HTTPManager()
        .getCustomerListing(
            CustomerListRequest(companyId: globalSessionUser.companyId))
        .then((value) {
      setState(() {
        customersList = value.values;
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

  _getCustomerListWithValue(CustomerReadResponse selectedValue) {
    HTTPManager()
        .getCustomerListing(
            CustomerListRequest(companyId: globalSessionUser.companyId))
        .then((value) {
      setState(() {
        customersList = value.values;
        selectedCustomer = selectedValue;
      });
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

  _getServiceList() {
    HTTPManager().getServiceListing(
        ServiceListRequest(companyId: globalSessionUser.companyId),
        []).then((value) {
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
        title: Text('Create Booking'),
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
                      controller: _finishtimeController,
                      isNumber: true,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: SearchableDropdownFeildWidget(
                            hintText: "Choose Customer",
                            initialState: selectedCustomer,
                            items: customersList,
                            onValueChange: (data) {
                              setState(() {
                                selectedCustomer = data;
                              });
                            },
                          ),
                        ),
                        if (_counter == 0)
                          permissionShowResponse.booking[0].read == 1
                              ? ButtonSmallWidget(
                                  title: "Add New",
                                  onPressed: _goToCustomer,
                                )
                              : ButtonSmallWidget(
                                  title: "Add New",
                                  //onPressed: _goToCustomer,
                                )
                      ],
                    ),
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
                    // _categoryListState != null
                    //     ?
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 9,
                        child: MultiSelectDialogField(
                          buttonIcon: Icon(Icons.arrow_drop_down),
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return "Select one or more services";
                            }
                          },
                          height: 250,
                          title: Text('services'),
                          items: categoryServiceNameList1
                              .map(
                                  (e) => MultiSelectItem<dynamic>(e.id, e.name))
                              .toList(),
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
                              int totalPrice = 0;

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
                                print("value:::${value}");

                                newServicesList.add(value);

                                availableServicesIdList = value;

                                _priceController.text = totalPrice.toString();

                                selectedServices = newServicesList;

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
                        hint: 'Enter number of Days',
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

  _goToCustomer() async {
    Navigator.of(context)
        .pushNamed(RouteManager.route_customer_create)
        .then((value) {
      setState(() {
        _isLoading = true;
      });
      _isLoading = false;
      _getCustomerListWithValue(value);
    });
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

  _submitBooking() {
    if (_bookingFormKey.currentState.validate()) {
      setState(() {
        // servicesIdList = selectedServices[0];
        // print(_categoryListState);
        //
        // print('servicesIdList::${servicesIdList}');

        _isLoading = true;
      });
      HTTPManager()
          .createBooking(BookingCreateRequest(
        companyId: "${globalSessionUser.companyId}",
        userId: "${globalSessionUser.id}",
        customerId: "${selectedCustomer.id}",
        totalPrice: _priceController.text,
        dueDate: _dateController.text,
        dueTime: _timeController.text,
        finishTime: _finishtimeController.text,
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

  onSearchText(String text) {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    customersList.forEach((customersList) {
      if (customersList.firstName.contains(text) ||
          customersList.lastName.contains(text)) {
        _searchResult.add(customersList);
      }
      setState(() {});
      return _searchResult;
    });
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

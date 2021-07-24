import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:powerdiary/models/multiselect_model.dart';
import 'package:powerdiary/models/request/booking_request.dart';
import 'package:powerdiary/models/request/customer_request.dart';
import 'package:powerdiary/models/request/service_request.dart';
import 'package:powerdiary/models/response/booking_list_response.dart';
import 'package:powerdiary/models/response/customer_list_response.dart';
import 'package:powerdiary/models/response/service_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_button_small.dart';
import 'package:powerdiary/ui/widgets/widget_datepicker_field.dart';
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

  TextEditingController _commentsController = new TextEditingController();

  bool _isLoading = true;

  List<CustomerReadResponse> customersList = [];
  CustomerReadResponse selectedCustomer;

  List<CustomerReadResponse> _searchResult = [];

  List<ServiceReadResponse> serviceList = [];
  List selectedServices = [];
  int servicesSum;

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
    super.initState();
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
                        ButtonSmallWidget(
                          title: "Add New",
                          onPressed: _goToCustomer,
                        )
                      ],
                    ),
                    MultiselectDropdownFeildWidget(
                      hintText: "Select Services",
                      items: serviceList?.map((item) {
                        return MultiselectItem(
                          display: item.name,
                          value: item,
                        ).toJson();
                      })?.toList(),
                      onValueChange: (value) {
                        int totalPrice = 0;
                        List services = [];
                        for (ServiceReadResponse vl in value) {
                          totalPrice += vl.price;
                          services.add(vl.id);
                        }
                        setState(() {
                          _priceController.text = totalPrice.toString();
                          servicesSum = totalPrice;
                          selectedServices = services;
                        });
                      },
                    ),
                    TextFeildWidget(
                      hint: 'Price',
                      iconData: FontAwesomeIcons.poundSign,
                      controller: _priceController,
                      isNumber: true,
                    ),
                    TextFeildWidget(
                      hint: 'Comments',
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

  _submitBooking() {
    if (_bookingFormKey.currentState.validate()) {
      setState(() {
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
        serviceId: selectedServices,
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

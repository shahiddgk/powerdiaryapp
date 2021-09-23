import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:powerdiary/models/request/booking_request.dart';
import 'package:powerdiary/models/request/customer_request.dart';
import 'package:powerdiary/models/request/service_request.dart';
import 'package:powerdiary/models/response/booking_list_response.dart';
import 'package:powerdiary/models/response/customer_list_response.dart';
import 'package:powerdiary/models/response/service_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_datepicker_field.dart';
import 'package:powerdiary/ui/widgets/widget_finish_time.dart';
import 'package:powerdiary/ui/widgets/widget_mutiselect_dropdown.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/ui/widgets/widget_searchable_dropdown_field.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/ui/widgets/widget_timepicker_field.dart';
import 'package:powerdiary/utils/utils.dart';

class EditBooking extends StatefulWidget {
  final BookingReadResponse bookingReadResponse;

  const EditBooking({Key key, this.bookingReadResponse}) : super(key: key);

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

  List<ServiceReadResponse> serviceList = [];
  List selectedServices = [];

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
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
        selectedServices
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

    super.initState();
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
                  MultiSelectServicesWidget(
                    serviceList: serviceList,
                    selectedServices: selectedServices,
                    controller: _selectedServicesController,
                    hint: "Select Services",
                    onItemChange: (services, pricing) {
                      setState(() {
                        selectedServices = services;
                        _priceController.text = "$pricing";
                      });
                    },
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

  _submitBooking() {
    if (_bookingFormKey.currentState.validate()) {
      setState(() {
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
        serviceId: selectedServices,
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

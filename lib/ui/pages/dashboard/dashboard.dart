import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:powerdiary/models/pd_location.dart';
import 'package:powerdiary/models/request/booking_request.dart';
import 'package:powerdiary/models/request/category_request.dart';
import 'package:powerdiary/models/request/permission_request.dart';
import 'package:powerdiary/models/response/booking_list_response.dart';
import 'package:powerdiary/models/response/category_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/pages/bookings/create_booking.dart';
import 'package:powerdiary/ui/pages/bookings/edit_booking.dart';
import 'package:powerdiary/ui/pages/bookings/view_booking_invoice.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_button_small.dart';
import 'package:powerdiary/ui/widgets/widget_calendar_view_header.dart';
import 'package:powerdiary/ui/widgets/widget_dropdown_field.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/utils/styles.dart';
import 'package:powerdiary/utils/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:powerdiary/models/response/permission_list_response.dart';
import 'package:url_launcher/url_launcher.dart';

class dashboard extends StatefulWidget {
  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  bool _isLoading = true;
  List<BookingReadResponse> bookingList = [];
  List<BookingReadResponse> filteredBookingList = [];
  PdLocation _pdLocation;
  TextEditingController _timeController = new TextEditingController();
  final GlobalKey<FormState> _smsFormKey = GlobalKey<FormState>();
  String selectedStatus = "0";
  Map<int, String> userFilter = new Map<int, String>();
  PermissionShowResponse permissionShowResponse;

  List<CategoryReadResponse> categoryList = [];
  String _categoryListState;

  @override
  void initState() {
    _getBookingList();
    getCurrentLocation(context).then((value) {
      setState(() {
        _pdLocation = value;
      });
    });

    _getCategoryList();

    _getPermissionList();

    super.initState();
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

        _categoryListState = "${categoryList[0].id}";
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {}, () {
        _getCategoryList();
      });
    });
  }

  _getBookingList() {
    HTTPManager()
        .getBookingListing(BookingListRequest(
            companyId: globalSessionUser.companyId,
            userId: globalSessionUser.id,
            roleId: globalSessionUser.roleId))
        .then((value) {
      setState(() {
        _isLoading = false;
        bookingList = value.values;
        filteredBookingList = value.values
            // .where((element) => element.serviceStatus == 1)
            .toList();
        userFilter[0] = "All Bookings";
        bookingList.forEach((element) {
          userFilter[element.userId] = element.userName;
        });
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _getBookingList();
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)
                      // topLeft: Radius.circular(8.0),
                      // topRight: Radius.circular(8.0),
                      ),
                  child: Image.asset('assets/top.jpeg', fit: BoxFit.fill),
                ),
                DropdownFeildWidget(
                  hintText: "Select User",
                  initialState: selectedStatus,
                  onValueChange: (val) {
                    setState(() {
                      selectedStatus = val;
                      if (val == "0") {
                        filteredBookingList = bookingList
                            // .where((element) => element.serviceStatus == 1)
                            .toList();
                      } else {
                        filteredBookingList = bookingList
                            .where((element) =>
                                element.serviceStatus == 1 &&
                                element.userId == int.parse(selectedStatus))
                            .toList();
                      }
                    });
                  },
                  items: userFilter.entries.map((item) {
                    return new DropdownMenuItem(
                      child: new Text(item.value),
                      value: '${item.key}',
                    );
                  })?.toList(),
                ),
                Expanded(
                    child: SfCalendar(
                  allowedViews: [
                    CalendarView.day,
                    CalendarView.week,
                    CalendarView.month,
                  ],
                  view: CalendarView.week ??
                      CalendarView.month ??
                      CalendarView.month,
                  onTap: calendarTapped,
                  dataSource: MeetingDataSource(filteredBookingList),
                  scheduleViewMonthHeaderBuilder: (BuildContext buildContext,
                      ScheduleViewMonthHeaderDetails details) {
                    return CalendarViewHeader(
                      dateTime: details.date,
                    );
                  },
                  monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment,
                  ),
                  // scheduleViewSettings:
                  //     ScheduleViewSettings(appointmentItemHeight: 20),
                ))
              ],
            )),
        if (_isLoading)
          Container(
              height: MediaQuery.of(context).size.height,
              child: PDProgressIndicator())
      ]),
    );
  }

  calendarTapped(CalendarTapDetails details) {
    if (details.appointments != null && details.appointments.length > 0) {
      Alert(
          context: context,
          title: "${DateFormat.yMMMd().format(details.date)}",
          style: AlertStyle(
              isCloseButton: true,
              isOverlayTapDismiss: true,
              alertElevation: 8.0,
              titleStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 28)),
          content: Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: ButtonSmallWidget(
                      title: "Add New",
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        _createBooking(BookingReadResponse(
                          dueDate: details.date,
                        ));
                      },
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: details.appointments.length,
                          itemBuilder: (context, index) {
                            return Column(children: [
                              ListTile(
                                title: Text(
                                    "${index + 1}. ${details.appointments[index].customerName}"),
                                subtitle: Text(
                                    "\nDate: ${DateFormat.yMMMd().format(details.appointments[index].dueDate)}"
                                    "\nTime Start: ${details.appointments[index].startTime}"
                                    "\nDuration: ${details.appointments[index].endTime} mins"
                                    "\nServices: ${details.appointments[index].services}"
                                    "\nAddress: ${details.appointments[index].customerReadResponse.address}"
                                    //  "\nComments: ${details.appointments[index].comment}"
                                    ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  permissionShowResponse.booking[0].update == 1
                                      ? IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            _updateBooking(
                                                details.appointments[index],
                                                _categoryListState);
                                          },
                                        )
                                      : IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.grey,
                                          ),
                                          // onPressed: () {
                                          //   Navigator.of(context, rootNavigator: true)
                                          //       .pop();
                                          //   _updateBooking(
                                          //       details.appointments[index]);
                                          // },
                                        ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      _deleteBooking(
                                          details.appointments[index]);
                                    },
                                  ),
                                  permissionShowResponse
                                              .booking[0].viewInvoice ==
                                          1
                                      ? IconButton(
                                          icon:
                                              Icon(Icons.receipt_long_outlined),
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            _showBooking(
                                                details.appointments[index]);
                                          },
                                        )
                                      : IconButton(
                                          icon: Icon(
                                            Icons.receipt_long_outlined,
                                            color: Colors.grey,
                                          ),
                                          // onPressed: () {
                                          //   Navigator.of(context, rootNavigator: true)
                                          //       .pop();
                                          //   _showBooking(details.appointments[index]);
                                          // },
                                        ),
                                  IconButton(
                                    icon: Icon(Icons.send_to_mobile),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      _sendSms(details.appointments[index]);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.directions),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      _showDirections(
                                          details.appointments[index]);
                                    },
                                  )
                                ],
                              ),
                              Divider()
                            ]);
                          }))
                ],
              )),
          buttons: []).show();
    } else {
      print("No Appointments");
      _createBooking(BookingReadResponse(dueDate: details.date));
    }
  }

  _sendSms(BookingReadResponse bookingReadResponse) {
    print("send sms");
    _timeController.clear();
    Alert(
        context: context,
        title: "Alert to ${bookingReadResponse.customerReadResponse.firstName}",
        style: AlertStyle(
            isCloseButton: true,
            isOverlayTapDismiss: true,
            alertElevation: 8.0,
            titleStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 28)),
        content: Form(
          key: _smsFormKey,
          child: Container(
              width: double.maxFinite,
              //height: MediaQuery.of(context).size.height / 2,
              child: Column(
                children: [
                  TextFeildWidget(
                    hint: 'Enter Time in Minutes',
                    controller: _timeController,
                    isNumber: true,
                  ),
                  ButtonWidget(
                    title: "Send SMS",
                    onPressed: () {
                      _sendSmsToCustomer(bookingReadResponse);
                    },
                  ),
                ],
              )),
        ),
        buttons: []).show();
  }

  _sendSmsToCustomer(BookingReadResponse bookingReadResponse) {
    if (_smsFormKey.currentState.validate()) {
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        _isLoading = true;
      });
      HTTPManager()
          .sendSms(bookingReadResponse.companyId,
              bookingReadResponse.customerId, _timeController.text + " minutes")
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        showAlert(context, value.message, false, () {}, () {
          _getBookingList();
        });
      }).catchError((e) {
        print(e);
        showAlert(context, e.toString(), true, () {
          setState(() {
            _isLoading = false;
          });
        }, () {
          _sendSmsToCustomer(bookingReadResponse);
        });
      });
    }
  }

  _showDirections(BookingReadResponse bookingReadResponse) async {
    if (Platform.isAndroid) {
      // Android-specific code/UI Component
      if (await MapLauncher.isMapAvailable(MapType.google)) {
        await MapLauncher.showDirections(
          mapType: MapType.google,
          destination: Coords(
            double.parse(bookingReadResponse.customerReadResponse.latitude),
            double.parse(bookingReadResponse.customerReadResponse.longitude),
          ),
          destinationTitle: bookingReadResponse.customerReadResponse.address,
          origin: Coords(_pdLocation.latitude, _pdLocation.longitude),
          originTitle: "User Current Location",
          //waypoints: waypoints,
          directionsMode: DirectionsMode.driving,
        );
      } else {
        const _url =
            'https://play.google.com/store/apps/details?id=com.google.android.apps.maps';
        await canLaunch(_url)
            ? await launch(_url)
            : throw 'Could not launch $_url';
      }
    } else if (Platform.isIOS) {
      // iOS-specific code/UI Component
      if (await MapLauncher.isMapAvailable(MapType.google)) {
        await MapLauncher.showDirections(
          mapType: MapType.google,
          destination: Coords(
              double.parse(bookingReadResponse.customerReadResponse.latitude),
              double.parse(bookingReadResponse.customerReadResponse.longitude)),
          destinationTitle: bookingReadResponse.customerReadResponse.address,
          origin: Coords(_pdLocation.latitude, _pdLocation.longitude),
          originTitle: "User Current Location",
          //waypoints: waypoints,
          directionsMode: DirectionsMode.driving,
        );
      } else {
        const _url =
            'https://apps.apple.com/gb/app/google-maps-transit-food/id585027354';
        await canLaunch(_url)
            ? await launch(_url)
            : throw 'Could not launch $_url';
      }
    }
  }

  _showBooking(BookingReadResponse bookingReadResponse) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => ViewBookingInvoice(
              bookingReadResponse: bookingReadResponse,
            )));
  }

  _updateBooking(BookingReadResponse bookingReadResponse, String category) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) => EditBooking(
                  bookingReadResponse: bookingReadResponse,
                  category: category,
                )))
        .then((value) {
      _getBookingList();
    });
  }

  _createBooking(BookingReadResponse bookingReadResponse) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) => CreateBooking(
                  bookingReadResponse: bookingReadResponse,
                )))
        .then((value) {
      _getBookingList();
    });
  }

  _deleteBooking(BookingReadResponse bookingReadResponse) {
    confirmDelete(context, () {
      setState(() {
        _isLoading = true;
      });
      HTTPManager()
          .deleteBooking(BookingShowRequest(
        companyId: '${bookingReadResponse.companyId}',
        bookingId: '${bookingReadResponse.bookingId}',
      ))
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        showAlert(context, value.message, false, () {}, () {
          _getBookingList();
        });
      }).catchError((e) {
        print(e);
        showAlert(context, e.toString(), true, () {
          setState(() {
            _isLoading = false;
          });
        }, () {
          _deleteBooking(bookingReadResponse);
        });
      });
    });
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<BookingReadResponse> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].formatedStartTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].formatedEndTime;
  }

  @override
  String getSubject(int index) {
    return appointments[index].formatedDetails;
  }

  @override
  Color getColor(int index) {
    List colors = appointments[index].services_color.split(",");
    return colors.length == 1 ? HexColor(colors[0]) : primaryColor;
  }

  @override
  bool isAllday(int index) {
    return false;
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

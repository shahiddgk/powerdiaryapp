import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:powerdiary/models/pd_location.dart';
import 'package:powerdiary/models/request/booking_request.dart';
import 'package:powerdiary/models/response/booking_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/pages/bookings/edit_booking.dart';
import 'package:powerdiary/ui/pages/bookings/view_booking_invoice.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/utils/utils.dart';

class BookingListing extends StatefulWidget {
  @override
  _BookingListingState createState() => _BookingListingState();
}

class _BookingListingState extends State<BookingListing> {
  final GlobalKey<FormState> _dropdownFormKey = GlobalKey<FormState>();

  bool _isLoading = true;
  List<BookingReadResponse> bookingList = [];
  PdLocation _pdLocation;

  String dropdownValue = 'Cash';
  String holder = '';
  bool _isShowing = true;
  String ChequeNumber;

  TextEditingController _chequeController = new TextEditingController();

  @override
  void initState() {
    _getBookingList();
    getCurrentLocation(context).then((value) {
      setState(() {
        _pdLocation = value;
      });
    });
    super.initState();
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

  List<String> paymentMethod = ['Cash', 'Card', 'PayPal', 'Invoice', 'cheque'];

  void getDropDownItem() {
    setState(() {
      holder = dropdownValue;
    });
  }

  void _toggle() {
    setState(() {
      _isShowing = !_isShowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Booking Listing'),
        ),
        body: Stack(
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: bookingList.length == 0
                    ? Text("No Booking available")
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text("Sr.No#")),
                                DataColumn(label: Text("User")),
                                DataColumn(label: Text("Customer")),
                                DataColumn(label: Text("Service")),
                                DataColumn(label: Text("Price")),
                                DataColumn(label: Text("Book Date")),
                                DataColumn(label: Text("Book Time")),
                                DataColumn(label: Text("Book Status")),
                                DataColumn(label: Text("Actions")),
                              ],
                              rows: List.generate(
                                  bookingList.length,
                                  (index) => DataRow(cells: <DataCell>[
                                        DataCell(Text('${index + 1}')),
                                        DataCell(
                                            Text(bookingList[index].userName)),
                                        DataCell(Text(
                                            bookingList[index].customerName)),
                                        DataCell(
                                            Text(bookingList[index].services)),
                                        DataCell(Text(
                                            '${bookingList[index].totalPrice}')),
                                        DataCell(Text(DateFormat.yMMMd().format(
                                            bookingList[index].dueDate))),
                                        // DataCell(Text(DateFormat.Hm()
                                        //     .format(bookingList[index].startTime))),
                                        DataCell(Text(
                                          bookingList[index].startTime,
                                        )),
                                        DataCell(IgnorePointer(
                                          ignoring: bookingList[index]
                                                      .serviceStatus ==
                                                  3
                                              ? true
                                              : false,
                                          child: DropdownButton(
                                            hint: Text("Completed"),
                                            value: bookingList[index]
                                                .serviceStatus,
                                            items: [
                                              DropdownMenuItem(
                                                child: Text("Booked"),
                                                value: 1,
                                              ),
                                              DropdownMenuItem(
                                                child: Text("In-Progress"),
                                                value: 2,
                                              ),
                                              DropdownMenuItem(
                                                child: Text("Completed"),
                                                value: 3,
                                                onTap: () {
                                                  _paymentPopup(
                                                      bookingList[index]);
                                                },
                                              ),
                                              DropdownMenuItem(
                                                child: Text("Cancel"),
                                                value: 4,
                                              ),
                                            ],
                                            onChanged: (value) {
                                              if (value != 3) {
                                                _updateBookingStatus(
                                                    bookingList[index], value);
                                              }
                                            },
                                          ),
                                        )),
                                        //Text(_selectedBookStatus),
                                        DataCell(Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.edit),
                                              onPressed: () {
                                                _updateBooking(
                                                    bookingList[index]);
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                _deleteBooking(
                                                    bookingList[index]);
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                  Icons.receipt_long_outlined),
                                              onPressed: () {
                                                _showBooking(
                                                    bookingList[index]);
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.directions),
                                              onPressed: () {
                                                _showDirections(
                                                    bookingList[index]);
                                                // _getCurrentLocation();
                                              },
                                            )
                                          ],
                                        ))
                                      ])),
                            )))),
            if (_isLoading)
              Container(
                  height: MediaQuery.of(context).size.height,
                  child: PDProgressIndicator())
          ],
        ));
  }

  Future _paymentPopup(BookingReadResponse bookingReadResponse) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: new Text("Payment Method"),
              content: Form(
                key: _dropdownFormKey,
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  new Text("Please select payment method"),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: new DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      onChanged: (String data) {
                        setState(() {
                          dropdownValue = data;
                        });
                      },
                      items: paymentMethod
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Visibility(
                    visible: dropdownValue == "cheque" ? true : false,
                    child: TextFeildWidget(
                      hint: 'Cheque number',
                      controller: _chequeController,
                      isNumber: true,
                    ),
                  )
                ]),
              ),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _updateBookingStatus(bookingReadResponse, 3);
                    _toggle();
                    Navigator.of(context).pop();
                  },
                  color: Colors.green,
                ),
                new FlatButton(
                  child: new Text(
                    "Close",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.black38,
                ),
              ],
            );
          },
        );
      },
    );
  }

  _updateBookingStatus(BookingReadResponse bookingReadResponse, int value) {
    setState(() {
      bookingReadResponse.serviceStatus = value;
    });
    _bookingStatus(
      '${bookingReadResponse.bookingId}',
      '${bookingReadResponse.companyId}',
      bookingReadResponse.paymentMethod,
      bookingReadResponse.chequenumber,
      bookingReadResponse.serviceStatus,
    );
  }

  _showDirections(BookingReadResponse bookingReadResponse) async {
    if (Platform.isAndroid) {
      // Android-specific code/UI Component
      if (await MapLauncher.isMapAvailable(MapType.google)) {
        await MapLauncher.showDirections(
          mapType: MapType.apple,
          destination: Coords(
            bookingReadResponse.customerReadResponse.latitude,
            bookingReadResponse.customerReadResponse.longitude,
          ),
          destinationTitle: "Some Destination",
          origin: Coords(_pdLocation.latitude, _pdLocation.longitude),
          originTitle: "User Current Location",
          //waypoints: waypoints,
          directionsMode: DirectionsMode.walking,
        );
      }
    } else if (Platform.isIOS) {
      // iOS-specific code/UI Component
      if (await MapLauncher.isMapAvailable(MapType.apple)) {
        await MapLauncher.showDirections(
          mapType: MapType.apple,
          destination: Coords(
            bookingReadResponse.customerReadResponse.latitude,
            bookingReadResponse.customerReadResponse.longitude,
          ),
          //destinationTitle: "Some Destination",
          origin: Coords(_pdLocation.latitude, _pdLocation.longitude),
          originTitle: "User Current Location",
          //waypoints: waypoints,
          directionsMode: DirectionsMode.driving,
        );
      }
    }
  }

  _showBooking(BookingReadResponse bookingReadResponse) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => ViewBookingInvoice(
              bookingReadResponse: bookingReadResponse,
            )));
  }

  _updateBooking(BookingReadResponse bookingReadResponse) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) => EditBooking(
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

  _bookingStatus(String bookingId, String companyId, String paymentInstrument,
      String paymentInstrumentNumber, int serviceStatus) {
    setState(() {
      _isLoading = true;

      print(serviceStatus);
    });
    HTTPManager()
        .statusBooking(BookingStatusRequest(
      bookingId: bookingId,
      companyId: companyId,
      serviceStatus: "$serviceStatus",
      paymentMethod: dropdownValue,
      chequenumber: _chequeController.text,
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
        _bookingStatus(
          bookingId,
          companyId,
          paymentInstrument,
          paymentInstrumentNumber,
          serviceStatus,
        );
      });
    });
  }
}

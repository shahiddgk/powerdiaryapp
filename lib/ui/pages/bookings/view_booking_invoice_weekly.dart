import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:powerdiary/models/request/booking_request.dart';
import 'package:powerdiary/models/request/booking_weekly_request.dart';
import 'package:powerdiary/models/response/booking_list_response.dart';
import 'package:powerdiary/models/response/booking_list_weekly_response.dart';
import 'package:powerdiary/models/response/booking_show_reponse.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/utils/utils.dart';
import 'package:screenshot/screenshot.dart';

class ViewWeeklyBookingInvoice extends StatefulWidget {
  final BookingWeeklyReadResponse bookingReadResponse;

  const ViewWeeklyBookingInvoice({Key key, this.bookingReadResponse})
      : super(key: key);

  @override
  _ViewWeeklyBookingInvoiceState createState() =>
      _ViewWeeklyBookingInvoiceState();
}

class _ViewWeeklyBookingInvoiceState extends State<ViewWeeklyBookingInvoice> {
  bool _isLoading = true;
  BookingShowResponse bookingShowResponse;
  Uint8List _imageFile;
  ScreenshotController screenshotController = ScreenshotController();
  var path;
  List<String> imagePaths = [];
  _ViewWeeklyBookingInvoiceState();
  @override
  void initState() {
    // TODO: implement initState'
    _getBookingDetails();
    super.initState();
  }

  _getBookingDetails() {
    HTTPManager()
        .showWeeklyBookingInvoice(BookingWeeklyShowRequest(
            companyId: "${widget.bookingReadResponse.companyId}",
            bookingId: "${widget.bookingReadResponse.bookingId}"))
        .then((value) {
      setState(() {
        _isLoading = false;
        bookingShowResponse = value;
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _getBookingDetails();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Invoice'),
      ),
      body: Stack(
        children: [
          if (!_isLoading)
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: 50.0,
                horizontal: 15.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Screenshot(
                        controller: screenshotController,
                        child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Image.network(
                                    bookingShowResponse.companyDetails.image),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 10),
                                  child: Text(
                                    "Invoice # " +
                                        '${bookingShowResponse.bookingDetails.length > 0 ? bookingShowResponse.bookingDetails[0].invoice : ""}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Invoice to ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 15),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Html(
                                                data:
                                                    "${bookingShowResponse.companyDetails.header}",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                        child: Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                                '${bookingShowResponse.customerDetails.customerName} ${bookingShowResponse.customerDetails.lastName}'),
                                          ),
                                          Text(
                                            "${bookingShowResponse.customerDetails.primaryPhone}",
                                            textAlign: TextAlign.right,
                                          ),
                                          Text(
                                            "${bookingShowResponse.customerDetails.email}",
                                            textAlign: TextAlign.right,
                                          ),
                                          Text(
                                            "${bookingShowResponse.customerDetails.address}",
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          children: [
                                            Text(
                                                "Invoice Date : ${bookingShowResponse.bookingDetails.length > 0 ? DateFormat.yMMMd().format(bookingShowResponse.bookingDetails[0].bookingDate) : ""}"),
                                            Text(
                                                "Booking Date : ${bookingShowResponse.bookingDetails.length > 0 ? DateFormat.yMMMd().format(bookingShowResponse.bookingDetails[0].bookingDate) : ""}"),
                                          ],
                                        ),
                                        Flexible(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                bookingShowResponse
                                                            .bookingDetails[0]
                                                            .paymentMethod ==
                                                        "cheque"
                                                    ? Text(
                                                        "Payment Method:",
                                                        maxLines: 1,
                                                        softWrap: false,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      )
                                                    : Text(
                                                        "Payment Method: ${bookingShowResponse.bookingDetails.length > 0 ? bookingShowResponse.bookingDetails[0].paymentMethod : ""} ",
                                                        maxLines: 1,
                                                        softWrap: false,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                //if(bookingShowResponse.bookingDetails[0].paymentMethod == 4){
                                                Visibility(
                                                  visible: bookingShowResponse
                                                              .bookingDetails[0]
                                                              .paymentMethod ==
                                                          "cheque"
                                                      ? true
                                                      : false,
                                                  child: Text(
                                                      "Cheque#:${bookingShowResponse.bookingDetails.length > 0 ? bookingShowResponse.bookingDetails[0].chequenumber : ""}"),
                                                ),
                                                // }
                                                Text(
                                                    "Payment Days: ${bookingShowResponse.bookingDetails[0].paymentDays}")
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    child: DataTable(
                                        columns: [
                                          DataColumn(label: Text("Sr.No#")),
                                          DataColumn(
                                              label: Text("Service Name")),
                                          DataColumn(label: Text("Price")),
                                        ],
                                        rows: List.generate(
                                          bookingShowResponse
                                              .bookingDetails.length,
                                          (index) => DataRow(cells: <DataCell>[
                                            DataCell(Text("${index + 1}")),
                                            DataCell(Text(
                                                "${bookingShowResponse.serviceData[index].serviceName}")),
                                            DataCell(Text(
                                                "£${bookingShowResponse.serviceData[index].servicePrice}")),
                                          ]),
                                        ))),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Sub Total:£ ${bookingShowResponse.bookingDetails.length > 0 ? bookingShowResponse.bookingDetails[0].totalPrice : ""}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500),
                                    )),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Vat:£ ${bookingShowResponse.bookingDetails[0].vat}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Grand Total:£ ${bookingShowResponse.bookingDetails[0].totalPrice + bookingShowResponse.bookingDetails[0].vat}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Note: ${bookingShowResponse.bookingDetails[0].notes}",
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Html(
                                            data:
                                                "${bookingShowResponse.companyDetails.footer} ",
                                            // softWrap: true,
                                          )
                                        ],
                                      ),
                                    )),
                              ],
                            ))),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: FlatButton(
                          //       onPressed: () async {
                          //         print("in send invoice");
                          //         screenshotController.capture().then((Uint8List image) async {
                          //           final RenderBox box = context.findRenderObject() as RenderBox;
                          //           await Share.(['///storage/emulated/0/Pictures/hello.jpg'], text: 'Invoice',
                          //           // await Share.shareFiles(['///storage/emulated/0/Pictures/hello.jpg'], text: 'Invoice',
                          //               sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                          //         });
                          //       },
                          //       color: Colors.green,
                          //       child: Row(
                          //         children: <Widget>[
                          //           Icon(
                          //             Icons.directions,
                          //             color: Colors.white,
                          //           ),
                          //           Text(
                          //             "Send Invoice",
                          //             style: TextStyle(
                          //               color: Colors.white,
                          //             ),
                          //           )
                          //         ],
                          //       )),
                          // ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlatButton(
                                onPressed: () {
                                  _sendInvoice(bookingShowResponse);
                                },
                                color: Colors.green,
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.directions,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Send Invoice",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlatButton(
                                onPressed: () {
                                  print("Send Invoice");
                                  screenshotController
                                      .capture()
                                      .then((Uint8List image) async {
                                    //Capture Done
                                    setState(() {
                                      _imageFile = image;
                                    });
                                    await Share.file("Invoice", "invoice.png",
                                        image, "image/png");
                                    var status =
                                        await Permission.storage.request();
                                    if (status.isGranted) {
                                      var result =
                                          await ImageGallerySaver.saveImage(
                                              _imageFile,
                                              quality: 60,
                                              name: "hello");
                                      path = result['filePath'];
                                      print("File Saved to Gallery  " +
                                          path.toString());
                                    }
                                  }).catchError((onError) {
                                    print(onError);
                                  });
                                },
                                color: Colors.deepPurple,
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.print,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Print",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_isLoading)
            Container(
                height: MediaQuery.of(context).size.height,
                child: PDProgressIndicator()),
        ],
      ),
    );
  }

  _sendInvoice(BookingShowResponse bookingShowResponse) {
    setState(() {
      _isLoading = true;
    });
    HTTPManager()
        .sendWeeklyInvoiceBooking(BookingWeeklySendInvoice(
      bookingId: '${bookingShowResponse.bookingDetails[0].bookingId}',
      companyId: bookingShowResponse.bookingDetails[0].companyId,
    ))
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      showAlert(context, value.message, false, () {}, () {
        _getBookingDetails();
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _sendInvoice(bookingShowResponse);
      });
    });
  }
}

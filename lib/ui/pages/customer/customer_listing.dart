import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:powerdiary/models/request/customer_request.dart';
import 'package:powerdiary/models/request/permission_request.dart';
import 'package:powerdiary/models/response/customer_list_response.dart';
import 'package:powerdiary/models/response/permission_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/pages/customer/edit_customer.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/utils/utils.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class CustomersListing extends StatefulWidget {
  @override
  _CustomersListingState createState() => _CustomersListingState();
}

class _CustomersListingState extends State<CustomersListing> {
  bool _isLoading = true;
  String api_response = "";
  List<CustomerReadResponse> customerList = [];
  PermissionShowResponse permissionShowResponse;
  MapTileLayerController _controller;

  int _counter = 5;
  Timer _timer;

  void _startTimer() {
    _counter = 5;

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

  int _Ttimer = 10;
  Timer _Timer;

  void _stTimer() {
    _Ttimer = 10;

    _Timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_Ttimer > 0) {
          _Ttimer--;
        } else {
          _Timer.cancel();
        }
      });
    });
  }

  List<Model> _data;

  _getCustomerList() {
    HTTPManager()
        .getCustomerListing(
            CustomerListRequest(companyId: globalSessionUser.companyId))
        .then((value) {
      setState(() {
        _isLoading = false;
        customerList = value.values;
        api_response = jsonEncode(value.values);
        _getCoordinates(customerList);
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

  List<GeneralModel> _general;

  @override
  void initState() {
    _getCustomerList();
    _getPermissionList();

    setState(() {
      _general = <GeneralModel>[GeneralModel(55.3781, 3.4360)];
    });
    _controller = MapTileLayerController();

    _stTimer();
    _startTimer();
    super.initState();
  }

  _getCoordinates(customer) {
    print("customer:::${customer}");
    setState(() {
      _data = customerList
          .map((e) => Model(longitude: e.longitude, latitude: e.latitude))
          .toList();
      // customer
      // .map((e) => Model(
      //     latitude: double.parse(e.latitude),
      //     longitude: double.parse(e.longitude)))
      // .toList();
    });
    print("data:::${_data}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Customer Listing'),
        ),
        body: Stack(
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: customerList.length == 0
                    ? Text("No Customer available")
                    : _counter > 0
                        ? Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            itemCount: customerList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    childAspectRatio: 0.62,
                                    crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.all(5),
                                child: Card(
                                  shadowColor: Colors.white,
                                  color: Colors.white,
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(children: [
                                                    Icon(Icons.person),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          customerList[index]
                                                              .firstName,
                                                          style: TextStyle(
                                                            fontSize: 15.0,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text(
                                                          customerList[index]
                                                              .lastName,
                                                          style: TextStyle(
                                                            fontSize: 15.0,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ]),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.phone),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        customerList[index]
                                                            .primaryPhone,
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // SizedBox(
                                                //   height: 5,
                                                // ),
                                                // SingleChildScrollView(
                                                //   scrollDirection:
                                                //       Axis.horizontal,
                                                //   child: Row(
                                                //     children: [
                                                //       Icon(Icons.phone),
                                                //       SizedBox(
                                                //         width: 5,
                                                //       ),
                                                //       Text(
                                                //         customerList[index]
                                                //             .secondaryPhone,
                                                //         style: TextStyle(
                                                //           fontSize: 15.0,
                                                //         ),
                                                //       ),
                                                //     ],
                                                //   ),
                                                // ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.email),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        customerList[index]
                                                            .email,
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons
                                                          .location_city_outlined),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        customerList[index]
                                                            .address,
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Switch(
                                                      value: customerList[index]
                                                          .isActive,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          customerList[index]
                                                              .isActive = value;
                                                        });
                                                        // _activateCategory(
                                                        //     customerList[index]);
                                                      },
                                                      //activeTrackColor: Colors.blue,
                                                      // activeColor: Colors.white,
                                                      //inactiveThumbColor: Colors.grey,
                                                    ),
                                                    permissionShowResponse
                                                                .customer[0]
                                                                .update ==
                                                            1
                                                        ? IconButton(
                                                            icon: Icon(
                                                              Icons.edit,
                                                            ),
                                                            onPressed: () {
                                                              _updateCustomer(
                                                                  customerList[
                                                                      index]);
                                                              // _getCurrentLocation();
                                                            },
                                                          )
                                                        : IconButton(
                                                            icon: Icon(
                                                              Icons.edit,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            // onPressed: () {
                                                            //   _updateCustomer(
                                                            //       customerList[index]);
                                                            //   // _getCurrentLocation();
                                                            // },
                                                          ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 3.0, right: 3.0),
                                                  child: Container(
                                                    height: 140,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: SfMaps(
                                                      layers: <MapLayer>[
                                                        MapTileLayer(
                                                          controller:
                                                              _controller,
                                                          initialMarkersCount:
                                                              1,
                                                          //controller: _controller,
                                                          urlTemplate:
                                                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                          initialFocalLatLng: customerList[
                                                                          index]
                                                                      .latitude
                                                                      .isEmpty ||
                                                                  customerList[
                                                                          index]
                                                                      .longitude
                                                                      .isEmpty
                                                              ? MapLatLng(
                                                                  54.5316223,
                                                                  -8.0317785)
                                                              : MapLatLng(
                                                                  double.parse(_data[
                                                                          index]
                                                                      .latitude),
                                                                  double.parse(_data[
                                                                          index]
                                                                      .longitude),
                                                                ),
                                                          initialZoomLevel: 5,
                                                          markerBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int i) {
                                                            return customerList[
                                                                            index]
                                                                        .latitude
                                                                        .isEmpty ||
                                                                    customerList[
                                                                            index]
                                                                        .latitude
                                                                        .isEmpty
                                                                ? MapMarker(
                                                                    latitude:
                                                                        _general[0]
                                                                            .latitude,
                                                                    longitude:
                                                                        _general[0]
                                                                            .longitude,
                                                                    // child:
                                                                    // Icon(
                                                                    //   Icons
                                                                    //       .location_on,
                                                                    //   color: Colors
                                                                    //       .red,
                                                                    //   size:
                                                                    //   20,
                                                                    // ),
                                                                  )
                                                                : MapMarker(
                                                                    latitude: double.parse(
                                                                        _data[index]
                                                                            .latitude),
                                                                    longitude: double.parse(
                                                                        _data[index]
                                                                            .longitude),
                                                                    child: Icon(
                                                                      Icons
                                                                          .location_on,
                                                                      color: Colors
                                                                          .red,
                                                                      size: 20,
                                                                    ),
                                                                  );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            })
                // SingleChildScrollView(
                //         scrollDirection: Axis.vertical,
                //         child: SingleChildScrollView(
                //             scrollDirection: Axis.horizontal,
                //             child: DataTable(
                //               columns: [
                //                 DataColumn(label: Text("Sr.No#")),
                //                 DataColumn(label: Text("Name")),
                //                 DataColumn(label: Text("Phone")),
                //                 DataColumn(label: Text("E-Mail")),
                //                 DataColumn(label: Text("Address")),
                //                 DataColumn(label: Text("Referred By")),
                //                 DataColumn(label: Text("Created")),
                //                 DataColumn(label: Text("Actions")),
                //               ],
                //               rows: List.generate(
                //                   customerList.length,
                //                   (index) => DataRow(cells: <DataCell>[
                //                         DataCell(Text('${index + 1}')),
                //                         DataCell(
                //                             Text(customerList[index].firstName)),
                //                         DataCell(Text(
                //                             customerList[index].primaryPhone)),
                //                         DataCell(Text(customerList[index].email ??
                //                             'default')),
                //                         DataCell(
                //                             Text(customerList[index].address)),
                //                         DataCell(Text(
                //                             customerList[index].referredBy ??
                //                                 'default')),
                //                         DataCell(Text(DateFormat.yMMMd().format(
                //                             customerList[index].createdAt))),
                //                         DataCell(Row(
                //                           children: [
                //                             IconButton(
                //                               icon: Icon(Icons.edit),
                //                               onPressed: () {
                //                                 _updateCustomer(
                //                                     customerList[index]);
                //                               },
                //                             ),
                //                             // IconButton(
                //                             //   icon: Icon(Icons.delete),
                //                             //   onPressed: () {
                //                             //     _deleteCustomer(
                //                             //         customerList[index]);
                //                             //   },
                //                             // )
                //                           ],
                //                         ))
                //                       ])),
                //             )),
                //       ),
                ),
            if (_isLoading)
              Container(
                  height: MediaQuery.of(context).size.height,
                  child: PDProgressIndicator())
          ],
        ));
  }

  _activateCategory() {}

  _updateCustomer(CustomerReadResponse customerReadResponse) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) => EditCustomer(
                  customerReadResponse: customerReadResponse,
                )))
        .then((value) {
      _getCustomerList();
    });
  }

  _deleteCustomer(CustomerReadResponse customerReadResponse) {
    confirmDelete(context, () {
      setState(() {
        _isLoading = true;
      });
      HTTPManager()
          .deleteCustomer(CustomerDeleteRequest(
        id: '${customerReadResponse.id}',
        companyId: '${customerReadResponse.companyId}',
      ))
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        showAlert(context, value.message, false, () {}, () {
          _getCustomerList();
        });
      }).catchError((e) {
        print(e);
        showAlert(context, e.toString(), true, () {
          setState(() {
            _isLoading = false;
          });
        }, () {
          _deleteCustomer(customerReadResponse);
        });
      });
    });
  }

  // dataLatitude(int index, String latitude, String longitude) {
  //   // print(index);
  //   // print(latitude);
  //   // print(longitude);
  //   double _latitude = double.parse(latitude);
  //   double _longitude = double.parse(longitude);
  //
  //   _data = <Model>[
  //     Model(_latitude, _longitude),
  //   ];
  //   return _data[index].latitude;
  // }

  // dataLongitude(int index, String latitude, String longitude) {
  //   double _latitude = double.parse(latitude);
  //   double _longitude = double.parse(longitude);
  //   _data = <Model>[
  //     Model(_latitude, _longitude),
  //   ];
  //   return _data[index].longitude;
  // }
}

class Model {
  final String latitude;
  final String longitude;

  Model({this.longitude, this.latitude});

  @override
  String toString() {
    return '{ ${this.latitude}, ${this.longitude} }';
  }
}

class GeneralModel {
  final double latitude;
  final double longitude;

  GeneralModel(this.longitude, this.latitude);
}

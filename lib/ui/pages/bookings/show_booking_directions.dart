import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as hello;
import 'package:platform_maps_flutter/platform_maps_flutter.dart';
import 'package:powerdiary/models/response/booking_list_response.dart';

class ShowBookingDirections extends StatefulWidget {
  final BookingReadResponse bookingReadResponse;

  const ShowBookingDirections({Key key, this.bookingReadResponse})
      : super(key: key);

  @override
  _ShowBookingDirectionsState createState() => _ShowBookingDirectionsState();
}

class _ShowBookingDirectionsState extends State<ShowBookingDirections> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  PlatformMapController mapController;

  hello.Position _currentPosition;
  String _currentAddress;

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  String _startAddress = '';
  String _destinationAddress = '';
  String _placeDistance;

  Set<Marker> markers = {};

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await hello.Geolocator.getCurrentPosition(
            desiredAccuracy: hello.LocationAccuracy.high)
        .then((hello.Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });

      _calculateDistance().then((isCalculated) {
        if (isCalculated) {
          print('Distance Calculated Sucessfully');
        } else {
          print('Error Calculating Distance');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Create the polylines for showing the route between two places
  _createPolylines(hello.Position start, hello.Position destination) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDSaueZmyVx1U9V2EyrNYlooIGVJsk9aAM", // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.walking,
    );
    print("poly line result:" +
        result.status +
        " count:" +
        "${result.points.length}");
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance() async {
    try {
      //Some Dummy Location: 37.78545422890511, -122.40692270010051
      hello.Position startCoordinates = hello.Position(
          latitude: _currentPosition.latitude,
          longitude: _currentPosition.longitude);
      hello.Position destinationCoordinates = hello.Position(
          latitude: 37.78545422890511, longitude: -122.40692270010051);

      // Start Location Marker
      Marker startMarker = Marker(
        markerId: MarkerId('$startCoordinates'),
        position: LatLng(
          startCoordinates.latitude,
          startCoordinates.longitude,
        ),
        infoWindow: InfoWindow(
          title: 'Start',
          snippet: _currentAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Destination Location Marker
      Marker destinationMarker = Marker(
        markerId: MarkerId('$destinationCoordinates'),
        position: LatLng(
          destinationCoordinates.latitude,
          destinationCoordinates.longitude,
        ),
        infoWindow: InfoWindow(
          title: 'Destination',
          snippet: _destinationAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Adding the markers to the list
      markers.add(startMarker);
      markers.add(destinationMarker);

      print('START COORDINATES: $startCoordinates');
      print('DESTINATION COORDINATES: $destinationCoordinates');

      await _createPolylines(startCoordinates, destinationCoordinates);

      double totalDistance = 0.0;

      // Calculating the total distance by adding the distance
      // between small segments
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      setState(() {
        _placeDistance = totalDistance.toStringAsFixed(2);
        print('DISTANCE: $_placeDistance km');
      });

      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Widget _textField({
    TextEditingController controller,
    FocusNode focusNode,
    String label,
    String hint,
    double width,
    Icon prefixIcon,
    Widget suffixIcon,
    Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[400],
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue[300],
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('View Booking Directions'),
        ),
        body: Container(
          height: height,
          width: width,
          child: Stack(
            children: <Widget>[
// Map View
              PlatformMap(
                initialCameraPosition: _initialLocation,
                markers: markers != null ? Set<Marker>.from(markers) : null,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                polylines: Set<Polyline>.of(polylines.values),
                onTap: (location) => print('onTap: $location'),
                onCameraMove: (cameraUpdate) =>
                    print('onCameraMove: $cameraUpdate'),
                compassEnabled: true,
                onMapCreated: (controller) {
                  mapController = controller;
                },
              ),
              // Show zoom buttons
              // SafeArea(
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 10.0),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: <Widget>[
              //         ClipOval(
              //           child: Material(
              //             color: Colors.blue[100], // button color
              //             child: InkWell(
              //               splashColor: Colors.blue, // inkwell color
              //               child: SizedBox(
              //                 width: 50,
              //                 height: 50,
              //                 child: Icon(Icons.add),
              //               ),
              //               onTap: () {
              //                 mapController.animateCamera(
              //                   CameraUpdate.zoomIn(),
              //                 );
              //               },
              //             ),
              //           ),
              //         ),
              //         SizedBox(height: 20),
              //         ClipOval(
              //           child: Material(
              //             color: Colors.blue[100], // button color
              //             child: InkWell(
              //               splashColor: Colors.blue, // inkwell color
              //               child: SizedBox(
              //                 width: 50,
              //                 height: 50,
              //                 child: Icon(Icons.remove),
              //               ),
              //               onTap: () {
              //                 mapController.animateCamera(
              //                   CameraUpdate.zoomOut(),
              //                 );
              //               },
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              // Show the place input fields & button for
              // showing the route
              // SafeArea(
              //   child: Align(
              //     alignment: Alignment.topCenter,
              //     child: Padding(
              //       padding: const EdgeInsets.only(top: 10.0),
              //       child: Container(
              //         decoration: BoxDecoration(
              //           color: Colors.white70,
              //           borderRadius: BorderRadius.all(
              //             Radius.circular(20.0),
              //           ),
              //         ),
              //         width: width * 0.9,
              //         child: Padding(
              //           padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              //           child: Column(
              //             mainAxisSize: MainAxisSize.min,
              //             children: <Widget>[
              //               Text(
              //                 'Places',
              //                 style: TextStyle(fontSize: 20.0),
              //               ),
              //               SizedBox(height: 10),
              //               _textField(
              //                   label: 'Start',
              //                   hint: 'Choose starting point',
              //                   prefixIcon: Icon(Icons.looks_one),
              //                   suffixIcon: IconButton(
              //                     icon: Icon(Icons.my_location),
              //                     onPressed: () {
              //                       startAddressController.text =
              //                           _currentAddress;
              //                       _startAddress = _currentAddress;
              //                     },
              //                   ),
              //                   controller: startAddressController,
              //                   focusNode: startAddressFocusNode,
              //                   width: width,
              //                   locationCallback: (String value) {
              //                     setState(() {
              //                       _startAddress = value;
              //                     });
              //                   }),
              //               SizedBox(height: 10),
              //               _textField(
              //                   label: 'Destination',
              //                   hint: 'Choose destination',
              //                   prefixIcon: Icon(Icons.looks_two),
              //                   controller: destinationAddressController,
              //                   focusNode: desrinationAddressFocusNode,
              //                   width: width,
              //                   locationCallback: (String value) {
              //                     setState(() {
              //                       _destinationAddress = value;
              //                     });
              //                   }),
              //               SizedBox(height: 10),
              //               Visibility(
              //                 visible: _placeDistance == null ? false : true,
              //                 child: Text(
              //                   'DISTANCE: $_placeDistance km',
              //                   style: TextStyle(
              //                     fontSize: 16,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //               ),
              //               SizedBox(height: 5),
              //               RaisedButton(
              //                 onPressed: (_startAddress != '' &&
              //                         _destinationAddress != '')
              //                     ? () async {
              //                         startAddressFocusNode.unfocus();
              //                         desrinationAddressFocusNode.unfocus();
              //                         setState(() {
              //                           if (markers.isNotEmpty) markers.clear();
              //                           if (polylines.isNotEmpty)
              //                             polylines.clear();
              //                           if (polylineCoordinates.isNotEmpty)
              //                             polylineCoordinates.clear();
              //                           _placeDistance = null;
              //                         });
              //
              //                         _calculateDistance().then((isCalculated) {
              //                           if (isCalculated) {
              //                             print(
              //                                 'Distance Calculated Sucessfully');
              //                           } else {
              //                             print('Error Calculating Distance');
              //                           }
              //                         });
              //                       }
              //                     : null,
              //                 color: Colors.red,
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(20.0),
              //                 ),
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: Text(
              //                     'Show Route'.toUpperCase(),
              //                     style: TextStyle(
              //                       color: Colors.white,
              //                       fontSize: 20.0,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // Show current location button
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                    child: ClipOval(
                      child: Material(
                        color: Colors.orange[100], // button color
                        child: InkWell(
                          splashColor: Colors.orange, // inkwell color
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(Icons.my_location),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: LatLng(
                                    _currentPosition.latitude,
                                    _currentPosition.longitude,
                                  ),
                                  zoom: 18.0,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

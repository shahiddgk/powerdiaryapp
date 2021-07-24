import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:powerdiary/models/pd_location.dart';
import 'package:powerdiary/models/response/session_user_model.dart';
import 'package:powerdiary/utils/styles.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String USER_KEY = "user_session";
SessionUserModel globalSessionUser;

Future showAlert(BuildContext context, String message, bool isError,
    VoidCallback cancelCallback, VoidCallback retryCallback) {
  Alert(
    context: context,
    type: isError ? AlertType.error : AlertType.success,
    title: isError ? "Error!" : "Success",
    desc: message,
    style: AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: false,
        alertElevation: 8.0,
        titleStyle: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 28)),
    buttons: [
      if (isError)
        DialogButton(
          color: Colors.white,
          border: Border.all(color: primaryColor, width: 1),
          radius: BorderRadius.circular(10),
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            cancelCallback();
          },
          width: 120,
        ),
      DialogButton(
        gradient: LinearGradient(colors: <Color>[primaryColor, primaryColor]),
        radius: BorderRadius.circular(10),
        child: Text(
          isError ? "Retry" : "Ok",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          retryCallback();
        },
        width: 120,
      )
    ],
  ).show();
}

Future confirmDelete(BuildContext context, VoidCallback retryCallback) {
  Alert(
    context: context,
    type: AlertType.warning,
    title: "Diary Master",
    desc: "Are you sure you want to delete this item?",
    style: AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: false,
        alertElevation: 8.0,
        titleStyle: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 28)),
    buttons: [
      DialogButton(
        color: Colors.white,
        border: Border.all(color: primaryColor, width: 1),
        radius: BorderRadius.circular(10),
        child: Text(
          "Cancel",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        width: 120,
      ),
      DialogButton(
        gradient: LinearGradient(colors: <Color>[primaryColor, primaryColor]),
        radius: BorderRadius.circular(10),
        child: Text(
          "Ok",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          retryCallback();
        },
        width: 120,
      )
    ],
  ).show();
}

saveUserSession(SessionUserModel sessionUserModel) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(USER_KEY, jsonEncode(sessionUserModel));
}

Future<SessionUserModel> getUserSession() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userSession = prefs.getString(USER_KEY);
  if (userSession == null) {
    return SessionUserModel();
  }
  return SessionUserModel.fromJson(jsonDecode(userSession));
}

logoutSessionUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

Future<PdLocation> getCurrentLocation(BuildContext context) async {
  var geoposition;
  try {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (enabled) {
      geoposition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return getAddress(geoposition.latitude, geoposition.longitude);
    } else {
      showAlert(context, "Please, enable GPS ", true, null, null);
    }
  } on PlatformException catch (e) {
    if (e.code == 'PERMISSION_DENIED') {
      Geolocator.requestPermission();
      print('please grant permission');
    }
    if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
      Geolocator.requestPermission();
      print('permission denied- please enable it from app settings');
    }
    geoposition = null;
  }

  //print("lat and long $geoposition.latitude $geoposition.longitude");
}

// Method for retrieving the address
Future<PdLocation> getAddress(double latitude, double longitude) async {
  try {
    List<Placemark> p = await placemarkFromCoordinates(latitude, longitude);
    Placemark place = p[0];
    var address =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
    return PdLocation(
        latitude: latitude, longitude: longitude, address: address);
  } catch (e) {
    print(e);
  }
}

// Method for retrieving the address
Future<PdLocation> getLocationAddress(String query) async {
  try {
    List<Location> addressPlacemark = await locationFromAddress(query);
    Location place = addressPlacemark[0];
    print("calculated address: $place.latitude, $place.longitude");
    return PdLocation(
        latitude: place.latitude, longitude: place.longitude, address: query);
  } catch (e) {
    print(e);
  }
}

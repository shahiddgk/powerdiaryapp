import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:powerdiary/models/request/user_request.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/utils/route_manager.dart';
import 'package:powerdiary/utils/utils.dart';

import '../../main.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  _pushNotificationSetup() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    _firebaseMessaging.getInitialMessage().then((RemoteMessage message) {
      if (message != null) {
        print("onMessage: ${message.notification.body} ");
      }
    });

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: ${message.notification.body} ");
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!  ${message.data}');
      if (message != null) {}
    });
    getUserSession().then((value) => {
          if (value != null)
            {
              setState(() {
                globalSessionUser = value;
              }),
              _fetchFcmToken()
            }
        });
  }

  _fetchFcmToken() {
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
      if (globalSessionUser.id == null) {
        Navigator.pushReplacementNamed(context, RouteManager.route_login);
      } else {
        _updateFcmToken(token);
      }
    }).catchError((e) {
      print(e);
      showAlert(context, "No Internet Connection", true, () {
        Navigator.pushReplacementNamed(context, RouteManager.route_dashboard);
      }, () {
        _fetchFcmToken();
      });
    });
  }

  _updateFcmToken(String token) {
    HTTPManager()
        .updateFcmToken(UserTokenRequest(
            userId: "${globalSessionUser.id}", fcmToken: token))
        .then((value) {
      Navigator.pushReplacementNamed(context, RouteManager.route_dashboard);
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        Navigator.pushReplacementNamed(context, RouteManager.route_dashboard);
      }, () {
        _updateFcmToken(token);
      });
    });
  }

  @override
  initState() {
    // TODO: implement initState

    _pushNotificationSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: PDProgressIndicator()));
  }
}

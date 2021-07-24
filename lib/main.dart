import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:powerdiary/models/request/user_request.dart';
import 'package:powerdiary/utils/route_manager.dart';
import 'package:powerdiary/utils/styles.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';

import 'network/http_manager.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget),
          maxWidth: 1200,
          minWidth: 450,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            ResponsiveBreakpoint.autoScale(2460, name: "4K"),
          ],
          background: Container(color: Colors.white)),
      initialRoute: RouteManager.route_splash,
      onGenerateRoute: RouteManager.generateRoute,
      theme: ThemeData(
          brightness: Brightness.light,
          visualDensity: VisualDensity(vertical: 0.5, horizontal: 0.5),
          // primarySwatch: MaterialColor(
          //   0xFFF5E0C3,
          //   <int, Color>{
          //     50: Color(0xFFFFFFFF),
          //     100: Color(0xee7e0ecd),
          //     200: Color(0xF7FC140B),
          //     300: Color(0xF7000000),
          //     400: Color(0xF70B14C4),
          //     500: Color(0xF7383535),
          //     600: Color(0xF70C1132),
          //   },
          // ),
          primaryColor: primaryColor,
          primaryColorDark: primaryColor,
          primaryColorBrightness: Brightness.light,
          //  scaffoldBackgroundColor: Color(0xFFFFFFFF),
          dividerColor: Color(0xF7383535),
          bottomAppBarColor: Color(0xF70B14C4),
          highlightColor: Color(0xff936F3E),
          selectedRowColor: Color(0xF70B14C4),
          unselectedWidgetColor: Color(0xF7383535),
          disabledColor: Colors.grey.shade200,
          timePickerTheme: TimePickerThemeData(backgroundColor: Colors.white),
          buttonTheme: ButtonThemeData(
              //button themes
              ),
          buttonColor: Color(0xF70B14C4),
          backgroundColor: Color(0xF7383535),
          //      dialogBackgroundColor: Colors.white,
          errorColor: Colors.red,
          // textTheme: TextTheme(
          //   headline6: TextStyle(color: Colors.white),
          //   headline1: TextStyle(
          //       color: Colors.blue,
          //       fontStyle: FontStyle.normal,
          //       fontWeight: FontWeight.bold),
          //   //text themes that contrast with card and canvas
          // ),
          primaryTextTheme: TextTheme(
            headline6: TextStyle(color: Colors.white),
            headline1: TextStyle(
                color: Colors.blue,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold),
          ),
          accentTextTheme: TextTheme(
              headline1: TextStyle(
            color: Colors.blue,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
          )
              //text theme that contrast with accent Color
              ),
          inputDecorationTheme: InputDecorationTheme(
              // default values for InputDecorator, TextField, and TextFormField
              ),
          iconTheme: IconThemeData(
            color: primaryColor,
            //icon themes that contrast with card and canvas
          ),
          primaryIconTheme: IconThemeData(
            color: Colors.white,
            //icon themes that contrast primary color
          ),
          accentIconTheme: IconThemeData(color: primaryColor
              //icon themes that contrast accent color
              ),
          cardTheme: CardTheme(
              // card theme
              ),
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            iconTheme: IconThemeData(
              color: Colors.white,
              //icon themes that contrast primary color
            ),
            //app bar theme
          ),
          bottomAppBarTheme: BottomAppBarTheme(
              // bottom app bar theme
              ),
          colorScheme: ColorScheme(
              primary: Colors.blue,
              primaryVariant: Colors.blue,
              secondary: Color(0xffC9A87C),
              secondaryVariant: Color(0xaaC9A87C),
              brightness: Brightness.light,
              background: Color(0xffB5BFD3),
              error: Colors.red,
              onBackground: Color(0xffB5BFD3),
              onError: Colors.red,
              onPrimary: Color(0xffEDD5B3),
              onSecondary: Color(0xffC9A87C),
              onSurface: Color(0xff457BE0),
              surface: Color(0xff457BE0)),
          snackBarTheme: SnackBarThemeData(
              // snack bar theme
              ),
          dialogTheme: DialogTheme(
              // dialog theme
              ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              // floating action button theme
              ),
          navigationRailTheme: NavigationRailThemeData(
              // navigation rail theme
              ),
          typography: Typography.material2018(),
          cupertinoOverrideTheme: CupertinoThemeData(
              //cupertino theme
              ),
          bottomSheetTheme: BottomSheetThemeData(
              //bottom sheet theme
              ),
          popupMenuTheme: PopupMenuThemeData(
              //pop menu theme
              ),
          bannerTheme: MaterialBannerThemeData(
              // material banner theme
              ),
          dividerTheme: DividerThemeData(
              //divider, vertical divider theme
              ),
          buttonBarTheme: ButtonBarThemeData(
              // button bar theme
              ),
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          })),
      debugShowCheckedModeBanner: false,
    );
  }
}

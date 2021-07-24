import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerdiary/models/request/login_request.dart';
import 'package:powerdiary/models/request/user_request.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/utils/route_manager.dart';
import 'package:powerdiary/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  bool _isLoading = false;
  bool _isCheckingSession = true;

  @override
  initState() {
    // TODO: implement initState
    getUserSession().then((value) => {
          if (value.id == null)
            {
              setState(() {
                _isCheckingSession = false;
              })
            }
          else
            {
              setState(() {
                globalSessionUser = value;
              }),
              Navigator.pushReplacementNamed(
                  context, RouteManager.route_dashboard)
            }
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Stack(
        children: [
          if (!_isCheckingSession)
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 50.0,
                horizontal: 10.0,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    children: <Widget>[
                      TextFeildWidget(
                        hint: 'Email',
                        controller: _emailController,
                        isEmail: true,
                      ),
                      TextFeildWidget(
                        hint: 'Password',
                        controller: _passwordController,
                        isPassword: true,
                      ),
                      ButtonWidget(
                        title: "Login",
                        onPressed: _loginUser,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have Account?"),
                          TextButton(
                              onPressed: _signup, child: Text('SignUp Here'))
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

  _loginUser() {
    if (_loginFormKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      HTTPManager()
          .loginUser(LoginRequest(
              email: _emailController.text, password: _passwordController.text))
          .then((value) {
        if (value.companyId == 1) {
          setState(() {
            _isLoading = false;
          });
          showAlert(context, "Wrong Credentials", true, () {}, () {
            _loginUser();
          });
          print(value);
        } else {
          saveUserSession(value);
          setState(() {
            globalSessionUser = value;
          });
          //Update Firebase Token
          _fetchFcmToken();
        }
      }).catchError((e) {
        print(e);
        setState(() {
          _isLoading = false;
        });
        showAlert(context, e.toString(), true, () {}, () {
          _loginUser();
        });
      });
    }
  }

  _fetchFcmToken() {
    FirebaseMessaging.instance.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
      _updateFcmToken(token);
    }).catchError((e) {
      print(e);
      showAlert(context, "No Internet Connection", true, () {
        setState(() {
          _isLoading = false;
        });
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
      _updateFcmToken(token);
    });
  }

  _signup() async {
    const url = 'http://diarymaster.co.uk/';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

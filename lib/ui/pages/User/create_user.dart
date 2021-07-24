import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerdiary/models/request/role_request.dart';
import 'package:powerdiary/models/request/user_request.dart';
import 'package:powerdiary/models/response/roles_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_dropdown_field.dart';
import 'package:powerdiary/ui/widgets/widget_image_profile.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/utils/route_manager.dart';
import 'package:powerdiary/utils/utils.dart';

class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final GlobalKey<FormState> _userFormKey = GlobalKey<FormState>();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  // TextEditingController _roleIdController = new TextEditingController();
  // TextEditingController _imageController = new TextEditingController();

  List<RolesReadResponse> rolesList = [];
  String selectedRole;

  bool _isLoading = true;
  File _imageFile;

  @override
  void initState() {
    _getRolesList();
    super.initState();
  }

  _getRolesList() {
    HTTPManager()
        .getRolesListing(
            RoleListRequest(companyId: globalSessionUser.companyId))
        .then((value) {
      setState(() {
        _isLoading = false;
        rolesList = value.values;
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _getRolesList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 50.0,
                  horizontal: 10.0,
                ),
                child: Form(
                  key: _userFormKey,
                  child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                      ProfileImageWidget(onImagePick: _onImagePick),
                      TextFeildWidget(
                        hint: 'User Name',
                        controller: _nameController,
                      ),
                      TextFeildWidget(
                        hint: 'User Email',
                        controller: _emailController,
                        isEmail: true,
                      ),
                      TextFeildWidget(
                        hint: 'password',
                        controller: _passwordController,
                        isPassword: true,
                      ),
                      DropdownFeildWidget(
                        hintText: "Select Role",
                        initialState: selectedRole,
                        onValueChange: (val) {
                          setState(() {
                            selectedRole = val;
                          });
                        },
                        items: rolesList?.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item.role),
                            value: '${item.id}',
                          );
                        })?.toList(),
                      ),
                      Row(
                        children: [
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
                              onPressed: _submitUser,
                            ),
                          ),
                        ],
                      )
                    ]),
                  ),
                ),
              )),
          if (_isLoading)
            Container(
                height: MediaQuery.of(context).size.height,
                child: PDProgressIndicator())
        ],
      ),
    );
  }

  _onImagePick(File imageFile) {
    setState(() {
      _imageFile = imageFile;
    });
  }

  _submitUser() async {
    if (_userFormKey.currentState.validate() && selectedRole.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      // File imagbytes = await _imageFile;
      HTTPManager()
          .createUser(UserCreateRequest(
              companyId: "${globalSessionUser.companyId}",
              name: _nameController.text,
              email: _emailController.text,
              password: _passwordController.text,
              roleId: selectedRole,
              file: _imageFile))
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        showAlert(context, value.message, false, () {}, () {
          Navigator.pushNamed(context, RouteManager.route_user_list);
        });
      }).catchError((e) {
        print(e);
        showAlert(context, e.toString(), true, () {
          setState(() {
            _isLoading = false;
          });
        }, () {
          _submitUser();
        });
      });
    }
  }
}

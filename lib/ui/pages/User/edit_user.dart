import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerdiary/models/request/role_request.dart';
import 'package:powerdiary/models/request/user_request.dart';
import 'package:powerdiary/models/response/roles_list_response.dart';
import 'package:powerdiary/models/response/user_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_dropdown_field.dart';
import 'package:powerdiary/ui/widgets/widget_image_profile.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/utils/utils.dart';

class EditUser extends StatefulWidget {
  final UserReadResponse userReadResponse;

  const EditUser({Key key, this.userReadResponse}) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final GlobalKey<FormState> _userFormKey = GlobalKey<FormState>();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _roleIdController = new TextEditingController();
  TextEditingController _imageController = new TextEditingController();
  List<RolesReadResponse> rolesList = [];
  String selectedRole;
  bool _isLoading = true;
  File _imageFile;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _nameController.text = widget.userReadResponse.name;
      _emailController.text = widget.userReadResponse.email;
      _passwordController.text = widget.userReadResponse.password;
      _roleIdController.text = widget.userReadResponse.roleId.toString();
      _imageController.text = widget.userReadResponse.image;
      selectedRole = "${widget.userReadResponse.roleId}";
    });
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
      appBar: AppBar(
        title: Text('Edit User'),
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
                child: Column(children: <Widget>[
                  ProfileImageWidget(
                    onImagePick: _onImagePick,
                    networkImage: _imageController.text,
                  ),
                  TextFeildWidget(
                    hint: 'User Name',
                    controller: _nameController,
                  ),
                  TextFeildWidget(
                    hint: 'User Email',
                    controller: _emailController,
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
                          title: "Update",
                          onPressed: _submitUser,
                        ),
                      ),
                    ],
                  )
                ]),
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

  _onImagePick(File imageFile) {
    setState(() {
      _imageFile = imageFile;
    });
  }

  _submitUser() {
    if (_userFormKey.currentState.validate() && selectedRole.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      HTTPManager()
          .updateUser(UserUpdateRequest(
              id: '${widget.userReadResponse.id}',
              companyId: '${widget.userReadResponse.companyId}',
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
          Navigator.of(context).pop();
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

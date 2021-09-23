import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:powerdiary/models/request/user_request.dart';
import 'package:powerdiary/models/response/user_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/pages/User/edit_user.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/utils/route_manager.dart';
import 'package:powerdiary/utils/utils.dart';

class UserListing extends StatefulWidget {
  @override
  _UserListingState createState() => _UserListingState();
}

class _UserListingState extends State<UserListing> {
  bool _isLoading = true;
  String api_response = "";
  List<UserReadResponse> userList = [];

  @override
  void initState() {
    _getUserList();
  }

  _getUserList() {
    HTTPManager()
        .getUserListing(UserListRequest(companyId: globalSessionUser.companyId))
        .then((value) {
      setState(() {
        _isLoading = false;
        userList = value.values;
        api_response = jsonEncode(value.values);
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _getUserList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Listing'),
      ),
      body: Stack(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            ButtonWidget(
              title: "Add New",
              onPressed: () {
                Navigator.pushNamed(context, RouteManager.route_user_create)
                    .then((value) {
                  _getUserList();
                });
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: userList.length == 0
                  ? Text("No User available")
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text("Sr.No#")),
                            DataColumn(label: Text("Roles")),
                            DataColumn(label: Text("UserName")),
                            DataColumn(label: Text("Email")),
                            DataColumn(label: Text("Created at")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("Actions")),
                          ],
                          rows: List.generate(
                              userList.length,
                              (index) => DataRow(cells: <DataCell>[
                                    DataCell(Text('${index + 1}')),
                                    DataCell(
                                        Text('${userList[index].role_name}')),
                                    DataCell(Text(userList[index].name)),
                                    DataCell(Text(userList[index].email)),
                                    DataCell(Text(DateFormat.yMMMd()
                                        .format(userList[index].createdAt))),
                                    DataCell(Switch(
                                      value: userList[index].isActive,
                                      onChanged: (value) {
                                        setState(() {
                                          userList[index].isActive = value;
                                        });
                                        _activateUser(
                                            '${userList[index].id}',
                                            '${userList[index].companyId}',
                                            userList[index].isActive);
                                      },
                                      activeTrackColor: Colors.blue,
                                      activeColor: Colors.white,
                                      inactiveThumbColor: Colors.grey,
                                    )),
                                    DataCell(Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            _updateUser(userList[index]);
                                          },
                                        ),
                                        // IconButton(
                                        //   icon: Icon(Icons.delete),
                                        //   onPressed: () {
                                        //     _deleteUser(userList[index]);
                                        //   },
                                        // )
                                      ],
                                    ))
                                  ])),
                        ),
                      ),
                    ),
            )
          ]),
          if (_isLoading)
            Container(
                height: MediaQuery.of(context).size.height,
                child: PDProgressIndicator())
        ],
      ),
    );
  }

  _activateUser(String id, String companyId, bool state) {
    setState(() {
      _isLoading = true;
    });
    HTTPManager()
        .statusUser(UserStatusRequest(
      id: id,
      companyId: companyId,
      status: state ? "1" : "0",
    ))
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      showAlert(context, value.message, false, () {}, () {
        _getUserList();
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _activateUser(id, companyId, state);
      });
    });
  }

  _updateUser(UserReadResponse userReadResponse) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) => EditUser(
                  userReadResponse: userReadResponse,
                )))
        .then((value) {
      _getUserList();
    });
  }

  _deleteUser(UserReadResponse userReadResponse) {
    confirmDelete(context, () {
      setState(() {
        _isLoading = true;
      });
      HTTPManager()
          .deleteUser(UserDeleteRequest(
              id: '${userReadResponse.id}',
              companyId: '${userReadResponse.companyId}'))
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        showAlert(context, value.message, false, () {}, () {
          _getUserList();
        });
      }).catchError((e) {
        print(e);
        showAlert(context, e.toString(), true, () {
          setState(() {
            _isLoading = false;
          });
        }, () {
          _deleteUser(userReadResponse);
        });
      });
    });
  }
}

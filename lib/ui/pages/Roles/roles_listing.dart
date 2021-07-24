import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:powerdiary/models/request/role_request.dart';
import 'package:powerdiary/models/response/roles_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/pages/Roles/edit_role.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/utils/route_manager.dart';
import 'package:powerdiary/utils/utils.dart';

class RolesListing extends StatefulWidget {
  @override
  _RolesListingState createState() => _RolesListingState();
}

class _RolesListingState extends State<RolesListing> {
  bool _isLoading = true;
  String api_response = "";
  List<RolesReadResponse> roleList = [];

  @override
  void initState() {
    _getRolesList();
  }

  _getRolesList() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager()
        .getRolesListing(
            RoleListRequest(companyId: globalSessionUser.companyId))
        .then((value) {
      setState(() {
        _isLoading = false;
        roleList = value.values;
        api_response = jsonEncode(value.values);
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
          title: Text('Roles Listing'),
        ),
        body: Stack(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              ButtonWidget(
                title: "Add New",
                onPressed: () {
                  Navigator.pushNamed(context, RouteManager.route_role_create)
                      .then((value) {
                    print("poped out roles add");
                    _getRolesList();
                  });
                },
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: roleList.length == 0
                    ? Text("No Roles available")
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text("Sr.No#")),
                              DataColumn(label: Text("Role Name")),
                              DataColumn(label: Text("Created at")),
                              DataColumn(label: Text("Actions")),
                            ],
                            rows: List.generate(
                                roleList.length,
                                (index) => DataRow(cells: <DataCell>[
                                      DataCell(Text('${index + 1}')),
                                      DataCell(Text('${roleList[index].role}')),
                                      DataCell(Text(DateFormat.yMMMd()
                                          .format(roleList[index].createdAt))),
                                      DataCell(Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              _updateRole(roleList[index]);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              _deleteRole(roleList[index]);
                                            },
                                          )
                                        ],
                                      ))
                                    ])),
                          ),
                        ),
                      ),
              ))
            ]),
            if (_isLoading)
              Container(
                  height: MediaQuery.of(context).size.height,
                  child: PDProgressIndicator())
          ],
        ));
  }

  _updateRole(RolesReadResponse roleReadResponse) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) => EditRole(
                  rolesReadResponse: roleReadResponse,
                )))
        .then((value) {
      _getRolesList();
    });
  }

  _deleteRole(RolesReadResponse rolesReadResponse) {
    confirmDelete(context, () {
      setState(() {
        _isLoading = true;
      });
      HTTPManager()
          .deleteRole(RoleDeleteRequest(
        id: '${rolesReadResponse.id}',
        companyId: '${rolesReadResponse.companyId}',
        //name: userReadResponse.name,
      ))
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        showAlert(context, value.message, false, () {}, () {
          _getRolesList();
        });
      }).catchError((e) {
        print(e);
        showAlert(context, e.toString(), true, () {
          setState(() {
            _isLoading = false;
          });
        }, () {
          _deleteRole(rolesReadResponse);
        });
      });
    });
  }
}

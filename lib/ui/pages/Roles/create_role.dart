import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerdiary/models/request/role_request.dart';
import 'package:powerdiary/models/response/role_permission_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/pages/Roles/roles_listing.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/utils/utils.dart';

class CreateRole extends StatefulWidget {
  @override
  _CreateRoleState createState() => _CreateRoleState();
}

class _CreateRoleState extends State<CreateRole> {
  final GlobalKey<FormState> _roleFormKey = GlobalKey<FormState>();
  TextEditingController _nameController = new TextEditingController();
  bool _isLoading = true;
  List<RolePermissionResponse> rolesPermissions = [];

  Map<String, List<String>> accessIdMap = new Map<String, List<String>>();

  @override
  void initState() {
    _getRolePermissionList();
    super.initState();
  }

  _getRolePermissionList() {
    HTTPManager().getRolesPermissions(null).then((value) {
      setState(() {
        _isLoading = false;
        rolesPermissions = value.values;
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _getRolePermissionList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Role'),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 50.0,
              horizontal: 10.0,
            ),
            child: Form(
              key: _roleFormKey,
              child: Column(children: <Widget>[
                TextFeildWidget(
                  hint: 'Role Name',
                  controller: _nameController,
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text("Module")),
                          DataColumn(label: Text("Read")),
                          DataColumn(label: Text("Create")),
                          DataColumn(label: Text("Edit")),
                          DataColumn(label: Text("Delete")),
                          DataColumn(label: Text("View")),
                          DataColumn(label: Text("Export")),
                          DataColumn(label: Text("Graph")),
                        ],
                        rows: List.generate(
                            rolesPermissions.length,
                            (index) => DataRow(cells: <DataCell>[
                                  DataCell(Text(rolesPermissions[index].name)),
                                  DataCell(rolesPermissions[index]
                                          .modulePermissions
                                          .contains("1")
                                      ? Checkbox(
                                          value: rolesPermissions[index].read,
                                          onChanged: (val) {
                                            setState(() {
                                              rolesPermissions[index].read =
                                                  val;
                                            });
                                            _updateAccessId(
                                                '${rolesPermissions[index].id}',
                                                rolesPermissions[index].read,
                                                "1");
                                          })
                                      : Container()),
                                  DataCell(rolesPermissions[index]
                                      .modulePermissions
                                      .contains("2")
                                      ? Checkbox(
                                      value: rolesPermissions[index].create,
                                      onChanged: (val) {
                                        setState(() {
                                          rolesPermissions[index].create = val;
                                        });
                                        _updateAccessId(
                                            '${rolesPermissions[index].id}',
                                            rolesPermissions[index].create,
                                            "2");
                                      }):Container()),
                                  DataCell(rolesPermissions[index]
                                      .modulePermissions
                                      .contains("3")
                                      ? Checkbox(
                                      value: rolesPermissions[index].edit,
                                      onChanged: (val) {
                                        setState(() {
                                          rolesPermissions[index].edit = val;
                                        });
                                        _updateAccessId(
                                            '${rolesPermissions[index].id}',
                                            rolesPermissions[index].edit,
                                            "3");
                                      }):Container()),
                                  DataCell(rolesPermissions[index]
                                      .modulePermissions
                                      .contains("4")
                                      ? Checkbox(
                                      value: rolesPermissions[index].delete,
                                      onChanged: (val) {
                                        setState(() {
                                          rolesPermissions[index].delete = val;
                                        });
                                        _updateAccessId(
                                            '${rolesPermissions[index].id}',
                                            rolesPermissions[index].delete,
                                            "4");
                                      }):Container()),
                                  DataCell(rolesPermissions[index]
                                      .modulePermissions
                                      .contains("5")
                                      ? Checkbox(
                                      value: rolesPermissions[index].view,
                                      onChanged: (val) {
                                        setState(() {
                                          rolesPermissions[index].view = val;
                                        });
                                        _updateAccessId(
                                            '${rolesPermissions[index].id}',
                                            rolesPermissions[index].view,
                                            "5");
                                      }):Container()),
                                  DataCell(rolesPermissions[index]
                                      .modulePermissions
                                      .contains("6")
                                      ? Checkbox(
                                      value: rolesPermissions[index].export,
                                      onChanged: (val) {
                                        setState(() {
                                          rolesPermissions[index].export = val;
                                        });
                                        _updateAccessId(
                                            '${rolesPermissions[index].id}',
                                            rolesPermissions[index].export,
                                            "6");
                                      }):Container()),
                                  DataCell(rolesPermissions[index]
                                      .modulePermissions
                                      .contains("7")
                                      ? Checkbox(
                                      value: rolesPermissions[index].graph,
                                      onChanged: (val) {
                                        setState(() {
                                          rolesPermissions[index].graph = val;
                                        });
                                        _updateAccessId(
                                            '${rolesPermissions[index].id}',
                                            rolesPermissions[index].graph,
                                            "7");
                                      }):Container()),
                                ])),
                      ),
                    ),
                  ),
                )),
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
          if (_isLoading)
            Container(
                height: MediaQuery.of(context).size.height,
                child: PDProgressIndicator())
        ],
      ),
    );
  }

  _updateAccessId(String permissionId, bool isAdded, String accessId) {
    List<String> aids =
        accessIdMap[permissionId] == null ? [] : accessIdMap[permissionId];
    if (isAdded) {
      aids.add(accessId);
    } else {
      aids.remove(accessId);
    }
    accessIdMap[permissionId] = aids;
    print(jsonEncode(accessIdMap));
  }

  _submitUser() {
    if (_roleFormKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      HTTPManager()
          .createRole(RoleCreateRequest(
              companyId: globalSessionUser.companyId,
              role: _nameController.text,
              accessIds: accessIdMap))
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

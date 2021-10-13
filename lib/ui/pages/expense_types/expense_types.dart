import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:powerdiary/models/request/expense_types_request.dart';
import 'package:powerdiary/models/request/permission_request.dart';
import 'package:powerdiary/models/response/expense_type_list_response.dart';
import 'package:powerdiary/models/response/permission_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/pages/expense_types/edit_expense_type.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/utils/utils.dart';

class ExpenseType extends StatefulWidget {
  @override
  _ExpenseTypeState createState() => _ExpenseTypeState();
}

class _ExpenseTypeState extends State<ExpenseType> {
  bool _isLoading = true;
  String api_response = "";
  List<ExpenseTypeReadResponse> expensetypeList = [];
  PermissionShowResponse permissionShowResponse;

  int _counter = 3;
  Timer _timer;

  void _startTimer() {
    _counter = 3;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    _getExpenseTypeList();
    _getPermissionList();
    _startTimer();
  }

  _getExpenseTypeList() {
    HTTPManager()
        .getExpenseTypeListing(
            ExpenseTypeListRequest(companyId: globalSessionUser.companyId))
        .then((value) {
      setState(() {
        _isLoading = false;
        expensetypeList = value.values;
        api_response = jsonEncode(value.values);
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _getExpenseTypeList();
      });
    });
  }

  _getPermissionList() {
    HTTPManager()
        .getPermissionList(PermissionListRequest(
            companyId: globalSessionUser.companyId,
            roleId: globalSessionUser.roleId))
        .then((value) {
      setState(() {
        _isLoading = false;
        permissionShowResponse = value;
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _getPermissionList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Type'),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: expensetypeList.length == 0
                ? Text("No Expense Types available")
                : _counter > 0
                    ? Text("No Expense Types available")
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                              columns: [
                                DataColumn(label: Text("Sr.No#")),
                                DataColumn(label: Text("Expense Types")),
                                DataColumn(label: Text("Actions")),
                              ],
                              rows: List.generate(
                                  expensetypeList.length,
                                  (index) => DataRow(cells: <DataCell>[
                                        DataCell(Text('${index + 1}')),
                                        DataCell(
                                            Text(expensetypeList[index].type)),
                                        DataCell(Row(
                                          children: [
                                            permissionShowResponse
                                                        .expenseTypes[0]
                                                        .update ==
                                                    1
                                                ? IconButton(
                                                    icon: Icon(Icons.edit),
                                                    onPressed: () {
                                                      _updateExpenseType(
                                                          expensetypeList[
                                                              index]);
                                                    },
                                                  )
                                                : IconButton(
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color: Colors.grey,
                                                    ),
                                                    // onPressed: () {
                                                    //   _updateExpenseType(
                                                    //       expensetypeList[index]);
                                                    // },
                                                  ),
                                            // IconButton(
                                            //   icon: Icon(Icons.delete),
                                            //   onPressed: () {
                                            //     _deleteExpenseType(
                                            //         expensetypeList[index]);
                                            //   },
                                            // )
                                          ],
                                        ))
                                      ]))),
                        ),
                      ),
          ),
          if (_isLoading)
            Container(
                height: MediaQuery.of(context).size.height,
                child: PDProgressIndicator()),
        ],
      ),
    );
  }

  _updateExpenseType(ExpenseTypeReadResponse expenseTypeReadResponse) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) => EditExpenseType(
                  expenseTypeReadResponse: expenseTypeReadResponse,
                )))
        .then((value) {
      _getExpenseTypeList();
    });
    _getExpenseTypeList();
  }

  _deleteExpenseType(ExpenseTypeReadResponse expenseTypeReadResponse) {
    confirmDelete(context, () {
      setState(() {
        _isLoading = true;
      });
      HTTPManager()
          .deleteExpenseType(ExpenseTypeDeleteRequest(
        id: '${expenseTypeReadResponse.id}',
        companyId: '${expenseTypeReadResponse.companyId}',
      ))
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        showAlert(context, value.message, false, () {}, () {
          _getExpenseTypeList();
        });
      }).catchError((e) {
        print(e);
        showAlert(context, e.toString(), true, () {
          setState(() {
            _isLoading = false;
          });
        }, () {
          _deleteExpenseType(expenseTypeReadResponse);
        });
      });
    });
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:powerdiary/models/request/expense_request.dart';
import 'package:powerdiary/models/response/expense_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/pages/expenses/edit_expenses.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/utils/utils.dart';

class ExpensesList extends StatefulWidget {
  @override
  _ExpensesListState createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  bool _isLoading = true;
  List<ExpenseReadResponse> expenseList = [];

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
    _getExpenseList();
    _startTimer();
  }

  _getExpenseList() {
    HTTPManager()
        .getExpenseListing(
            ExpenseListRequest(companyId: globalSessionUser.companyId))
        .then((value) {
      setState(() {
        _isLoading = false;
        expenseList = value.values;
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _getExpenseList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: expenseList.length == 0
                ? Text("No Expenses available")
                : _counter > 0
                    ? Text("No Expenses available")
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text("Sr.No#")),
                              DataColumn(label: Text("Expense Types")),
                              DataColumn(label: Text("Expense Payable")),
                              DataColumn(label: Text("Amount")),
                              DataColumn(label: Text("Action")),
                            ],
                            rows: List.generate(
                              expenseList.length,
                              (index) => DataRow(cells: [
                                DataCell(Text('${index + 1}')),
                                DataCell(Text('${expenseList[index].type}')),
                                DataCell(Text(DateFormat.yMMMd()
                                    .format(expenseList[index].payable))),
                                DataCell(Text('${expenseList[index].amount}')),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        _updateExpense(expenseList[index]);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteExpense(expenseList[index]);
                                      },
                                    )
                                  ],
                                ))
                              ]),
                            ),
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

  _updateExpense(ExpenseReadResponse expenseReadResponse) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) => EditExpenses(
                  expenseReadResponse: expenseReadResponse,
                )))
        .then((value) {
      _getExpenseList();
    });
  }

  _deleteExpense(ExpenseReadResponse expenseReadResponse) {
    confirmDelete(context, () {
      setState(() {
        _isLoading = true;
      });
      HTTPManager()
          .deleteExpense(ExpenseDeleteRequest(
        companyId: expenseReadResponse.companyId,
        id: expenseReadResponse.id,
      ))
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        showAlert(context, value.message, false, () {}, () {
          _getExpenseList();
        });
      }).catchError((e) {
        print(e);
        showAlert(context, e.toString(), true, () {
          setState(() {
            _isLoading = false;
          });
        }, () {
          _deleteExpense(expenseReadResponse);
        });
      });
    });
  }
}

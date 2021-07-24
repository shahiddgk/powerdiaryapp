import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:powerdiary/models/request/expense_types_request.dart';
import 'package:powerdiary/models/response/expense_type_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/utils/utils.dart';

class Type extends StatefulWidget {
  @override
  _TypeState createState() => _TypeState();
}

class _TypeState extends State<Type> {
  final GlobalKey<FormState> _typeFormKey = GlobalKey<FormState>();
  TextEditingController _expenseTypeController = new TextEditingController();
  // TextEditingController _descriptionController = new TextEditingController();
  bool _isLoading = false;
  String api_response = "";
  List<ExpenseTypeReadResponse> expensetypeList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Type"),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 50.0,
              horizontal: 10.0,
            ),
            child: Form(
              key: _typeFormKey,
              child: Column(
                children: <Widget>[
                  TextFeildWidget(
                    hint: 'Expense Type',
                    controller: _expenseTypeController,
                  ),
                  // TextFeildWidget(
                  //   hint: 'Description',
                  //   controller: _descriptionController,
                  // ),
                  Row(
                    children: <Widget>[
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
                          onPressed: _submitExpenseType,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

  _submitExpenseType() {
    if (_typeFormKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      HTTPManager()
          .createExpenseType(ExpenseTypeCreateRequest(
        companyId: '${globalSessionUser.companyId}',
        //description: _descriptionController.text,
        type: _expenseTypeController.text,
      ))
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        showAlert(context, value.message, false, () {}, () {
          _getExpenseTypeList();
          Navigator.of(context).pop();
        });
      }).catchError((e) {
        print(e);
        showAlert(context, e.toString(), true, () {
          setState(() {
            _isLoading = false;
          });
        }, () {
          _submitExpenseType();
        });
      });
    }
  }
}

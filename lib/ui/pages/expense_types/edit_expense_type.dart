import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:powerdiary/models/request/expense_types_request.dart';
import 'package:powerdiary/models/response/expense_type_list_response.dart';
import 'package:powerdiary/models/response/general_response_model.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/utils/utils.dart';

class EditExpenseType extends StatefulWidget {
  final ExpenseTypeReadResponse expenseTypeReadResponse;

  const EditExpenseType({Key key, this.expenseTypeReadResponse})
      : super(key: key);

  @override
  _EditExpenseTypeState createState() => _EditExpenseTypeState();
}

class _EditExpenseTypeState extends State<EditExpenseType> {
  final GlobalKey<FormState> _expenseTypeForm = GlobalKey<FormState>();
  TextEditingController _expenseType = new TextEditingController();
  // TextEditingController _expenseTypeDes = new TextEditingController();
  bool _isLoading = true;
  String api_response = "";
  List<ExpenseTypeReadResponse> expensetypeList = [];

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _expenseType.text = widget.expenseTypeReadResponse.type;
      //  _expenseTypeDes.text = widget.expenseTypeReadResponse.description;
      _isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Expense Type"),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 50.0,
              horizontal: 10.0,
            ),
            child: Form(
              key: _expenseTypeForm,
              child: Column(
                children: <Widget>[
                  TextFeildWidget(
                    hint: 'Expense Type',
                    controller: _expenseType,
                  ),
                  // TextFeildWidget(
                  //   hint: 'Description',
                  //   controller: _expenseTypeDes,
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
          if (_isLoading)
            Container(
                height: MediaQuery.of(context).size.height,
                child: PDProgressIndicator())
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
  // Navigator.push( context, MaterialPageRoute(builder: (context) => ExpenseType()));

  _submitExpenseType() {
    if (_expenseTypeForm.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      HTTPManager()
          .updateExpenseType(ExpenseTypeUpdateRequest(
        type: _expenseType.text,
        companyId: '${widget.expenseTypeReadResponse.companyId}',
        id: '${widget.expenseTypeReadResponse.id}',
        //        description: _expenseTypeDes.text
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

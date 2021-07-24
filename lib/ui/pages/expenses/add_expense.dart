import 'package:flutter/material.dart';
import 'package:powerdiary/models/request/expense_request.dart';
import 'package:powerdiary/models/request/expense_types_request.dart';
import 'package:powerdiary/models/response/expense_type_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_datepicker_field.dart';
import 'package:powerdiary/ui/widgets/widget_dropdown_field.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/utils/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddExpenses extends StatefulWidget {
  @override
  _AddExpensesState createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  final GlobalKey<FormState> _expenseFormKey = GlobalKey<FormState>();
  TextEditingController _payableController = new TextEditingController();
  TextEditingController _amountController = new TextEditingController();
  // TextEditingController _descriptionController = new TextEditingController();

  List<ExpenseTypeReadResponse> expenseTypeList = [];
  String _selectedExpenseType;
  bool _isLoading = true;

  @override
  void initState() {
    _getExpenseTypeList();
  }

  _getExpenseTypeList() {
    HTTPManager()
        .getExpenseTypeListing(
            ExpenseTypeListRequest(companyId: globalSessionUser.companyId))
        .then((value) {
      setState(() {
        _isLoading = false;
        expenseTypeList = value.values;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 50.0,
              horizontal: 10.0,
            ),
            child: Form(
              key: _expenseFormKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    DropdownFeildWidget(
                      hintText: "Select Expense Type",
                      initialState: _selectedExpenseType,
                      onValueChange: (val) {
                        setState(() {
                          _selectedExpenseType = val;
                        });
                      },
                      items: expenseTypeList?.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item.type),
                          value: '${item.id}',
                        );
                      })?.toList(),
                    ),
                    CustomDatePickerWidget(
                      hint: 'Payable',
                      controller: _payableController,
                    ),
                    TextFeildWidget(
                      iconData: FontAwesomeIcons.poundSign,
                      hint: 'Amount',
                      controller: _amountController,
                    ),
                    // TextFeildWidget(
                    //   hint: 'Expense Description',
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
                            onPressed: _submitExpense,
                          ),
                        ),
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

  _submitExpense() {
    if (_expenseFormKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      HTTPManager()
          .createExpense(ExpenseCreateRequest(
        companyId: "${globalSessionUser.companyId}",
        expenseType: _selectedExpenseType,
        payable: _payableController.text,
        amount: _amountController.text,
        //        description: _descriptionController.text
      ))
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        showAlert(context, value.message, false, () {}, () {
          Navigator.of(context).pop();
        });
      }).catchError((e) {
        print(e);
        setState(() {
          _isLoading = false;
        });
        showAlert(context, e.toString(), true, () {
          setState(() {
            _isLoading = false;
          });
        }, () {
          _submitExpense();
        });
      });
    }
  }
}

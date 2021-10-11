import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:powerdiary/models/request/expense_request.dart';
import 'package:powerdiary/models/request/expense_types_request.dart';
import 'package:powerdiary/models/response/expense_list_response.dart';
import 'package:powerdiary/models/response/expense_type_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_datepicker_field.dart';
import 'package:powerdiary/ui/widgets/widget_dropdown_field.dart';
import 'package:powerdiary/ui/widgets/widget_payment_method.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/utils/utils.dart';

class EditExpenses extends StatefulWidget {
  final ExpenseReadResponse expenseReadResponse;

  const EditExpenses({Key key, this.expenseReadResponse}) : super(key: key);

  @override
  _EditExpensesState createState() => _EditExpensesState();
}

class _EditExpensesState extends State<EditExpenses> {
  final GlobalKey<FormState> _expenseFormKey = GlobalKey<FormState>();
  TextEditingController _payableController = new TextEditingController();
  TextEditingController _amountController = new TextEditingController();
  // TextEditingController _descriptionController = new TextEditingController();

  List<ExpenseTypeReadResponse> expenseTypeList = [];
  String _selectedExpenseType;
  int _selectedExpenseMethod;
  bool _isLoading = true;

  @override
  void initState() {
    setState(() {
      _payableController.text =
          DateFormat('yyyy-MM-dd').format(widget.expenseReadResponse.payable);
      _amountController.text = "${widget.expenseReadResponse.amount}";
      // _descriptionController.text = widget.expenseReadResponse.description;
      _selectedExpenseType = '${widget.expenseReadResponse.expenseType}';
      _selectedExpenseMethod = widget.expenseReadResponse.paymentMethod;
    });
    _getExpenseTypeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Expense'),
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
                    DropdownPaymentFeildWidget(
                      hintText: "Select Payment Method",
                      initialState: _selectedExpenseMethod,
                      onValueChange: (val) {
                        setState(() {
                          _selectedExpenseMethod = val;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          child: Text("Cash"),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text("Card"),
                          value: 2,
                        ),
                        DropdownMenuItem(
                          child: Text("Bank Transfer"),
                          value: 3,
                        ),
                        DropdownMenuItem(
                          child: Text("Cheque"),
                          value: 4,
                        ),
                      ],
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 8, right: 8),
                    //   child: Card(
                    //     child: Container(
                    //       height: 60,
                    //       width: MediaQuery.of(context).size.width,
                    //       decoration: BoxDecoration(
                    //           border: Border.all(color: Colors.black38)),
                    //       child: Padding(
                    //         padding: EdgeInsets.only(left: 10, right: 10),
                    //         child: DropdownButton(
                    //           isExpanded: true,
                    //           value: _selectedExpenseMethod,
                    //           items: [
                    //             DropdownMenuItem(
                    //               child: Text("Cash"),
                    //               value: 1,
                    //             ),
                    //             DropdownMenuItem(
                    //               child: Text("Card"),
                    //               value: 2,
                    //             ),
                    //             DropdownMenuItem(
                    //               child: Text("Bank Transfer"),
                    //               value: 3,
                    //             ),
                    //             DropdownMenuItem(
                    //               child: Text("Check"),
                    //               value: 4,
                    //             ),
                    //           ],
                    //           onChanged: (value) {
                    //             _selectedExpenseMethod = value;
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    CustomDatePickerWidget(
                      hint: 'Payable',
                      controller: _payableController,
                    ),
                    TextFeildWidget(
                      hint: 'Amount',
                      controller: _amountController,
                      isNumber: true,
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
                            onPressed: _updateExpense,
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

  _updateExpense() {
    if (_expenseFormKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      print(_selectedExpenseType);
      HTTPManager()
          .updateExpense(ExpenseUpdateRequest(
        id: '${widget.expenseReadResponse.id}',
        companyId: '${widget.expenseReadResponse.companyId}',
        expenseType: _selectedExpenseType,
        payable: _payableController.text,
        amount: _amountController.text,
        paymentMethod: '${_selectedExpenseMethod}',

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
          _updateExpense();
        });
      });
    }
  }
}

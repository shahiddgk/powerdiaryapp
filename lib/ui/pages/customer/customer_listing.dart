import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:powerdiary/models/request/customer_request.dart';
import 'package:powerdiary/models/response/customer_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/pages/customer/edit_customer.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/utils/utils.dart';

class CustomersListing extends StatefulWidget {
  @override
  _CustomersListingState createState() => _CustomersListingState();
}

class _CustomersListingState extends State<CustomersListing> {
  bool _isLoading = true;
  String api_response = "";
  List<CustomerReadResponse> customerList = [];

  @override
  void initState() {
    _getCustomerList();
  }

  _getCustomerList() {
    HTTPManager()
        .getCustomerListing(
            CustomerListRequest(companyId: globalSessionUser.companyId))
        .then((value) {
      setState(() {
        _isLoading = false;
        customerList = value.values;
        api_response = jsonEncode(value.values);
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _getCustomerList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Customer Listing'),
        ),
        body: Stack(
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: customerList.length == 0
                    ? Text("No Customer available")
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text("Sr.No#")),
                                DataColumn(label: Text("Name")),
                                DataColumn(label: Text("Phone")),
                                DataColumn(label: Text("E-Mail")),
                                DataColumn(label: Text("Address")),
                                DataColumn(label: Text("Referred By")),
                                DataColumn(label: Text("Created")),
                                DataColumn(label: Text("Actions")),
                              ],
                              rows: List.generate(
                                  customerList.length,
                                  (index) => DataRow(cells: <DataCell>[
                                        DataCell(Text('${index + 1}')),
                                        DataCell(Text(
                                            customerList[index].firstName)),
                                        DataCell(Text(
                                            customerList[index].primaryPhone)),
                                        DataCell(Text(
                                            customerList[index].email ??
                                                'default')),
                                        DataCell(
                                            Text(customerList[index].address)),
                                        DataCell(Text(
                                            customerList[index].referredBy ??
                                                'default')),
                                        DataCell(Text(DateFormat.yMMMd().format(
                                            customerList[index].createdAt))),
                                        DataCell(Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.edit),
                                              onPressed: () {
                                                _updateCustomer(
                                                    customerList[index]);
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                _deleteCustomer(
                                                    customerList[index]);
                                              },
                                            )
                                          ],
                                        ))
                                      ])),
                            )))),
            if (_isLoading)
              Container(
                  height: MediaQuery.of(context).size.height,
                  child: PDProgressIndicator())
          ],
        ));
  }

  _activateCategory() {}

  _updateCustomer(CustomerReadResponse customerReadResponse) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) => EditCustomer(
                  customerReadResponse: customerReadResponse,
                )))
        .then((value) {
      _getCustomerList();
    });
  }

  _deleteCustomer(CustomerReadResponse customerReadResponse) {
    confirmDelete(context, () {
      setState(() {
        _isLoading = true;
      });
      HTTPManager()
          .deleteCustomer(CustomerDeleteRequest(
        id: '${customerReadResponse.id}',
        companyId: '${customerReadResponse.companyId}',
      ))
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        showAlert(context, value.message, false, () {}, () {
          _getCustomerList();
        });
      }).catchError((e) {
        print(e);
        showAlert(context, e.toString(), true, () {
          setState(() {
            _isLoading = false;
          });
        }, () {
          _deleteCustomer(customerReadResponse);
        });
      });
    });
  }
}

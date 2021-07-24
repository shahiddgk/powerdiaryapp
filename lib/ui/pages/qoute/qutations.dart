import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:powerdiary/models/request/QutationListRequest.dart';
import 'package:powerdiary/models/response/qutations_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/pages/qoute/quote_detail.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/utils/utils.dart';

class QutationsListing extends StatefulWidget {
  @override
  _QutationsListingState createState() => _QutationsListingState();
}

class _QutationsListingState extends State<QutationsListing> {
  bool _isLoading = true;
  String api_response = "";
  List<QutationReadResponse> qutationList = [];

  @override
  void initState() {
    _getQuotationsList();
  }

  _getQuotationsList() {
    HTTPManager()
        .getQutationsListing(
            QutationListRequest(companyId: globalSessionUser.companyId))
        .then((value) {
      setState(() {
        _isLoading = false;
        qutationList = value.values;
        api_response = jsonEncode(value.values);
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {}, () {
        _getQuotationsList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotations'),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 50.0,
              horizontal: 10.0,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text("Sr.No#")),
                    DataColumn(label: Text("Email")),
                    DataColumn(label: Text("Send Date")),
                    DataColumn(label: Text("Action")),
                  ],
                  rows: List.generate(
                    qutationList.length,
                    (index) => DataRow(cells: <DataCell>[
                      DataCell(Text('${index + 1}')),
                      DataCell(Text(qutationList[index].email)),
                      DataCell(Text(
                          //qutationList[index].createdAt
                          _FormatDate(qutationList[index]))),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_red_eye),
                            onPressed: () {
                              _QuoteDetail(qutationList[index]);
                            },
                          ),
                        ],
                      ))
                    ]),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _QuoteDetail(QutationReadResponse qutationReadResponse) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) => QuoteDetail(
                  qutationReadResponse: qutationReadResponse,
                )))
        .then((value) {
      _getQuotationsList();
    });
    _getQuotationsList();
  }

  String _FormatDate(QutationReadResponse qutationReadResponse) {
    String parseDate = qutationReadResponse.createdAt;

    DateTime date = DateTime.parse(parseDate);
    String formatteddate = formatDate(date, [
      mm,
      '-',
      dd,
      '-',
      yyyy,
    ]);

    return formatteddate;
  }
}

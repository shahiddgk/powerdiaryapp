import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:powerdiary/models/request/service_request.dart';
import 'package:powerdiary/models/response/service_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/utils/utils.dart';

import 'edit_service.dart';

class ServicesListing extends StatefulWidget {
  @override
  _ServicesListingState createState() => _ServicesListingState();
}

class _ServicesListingState extends State<ServicesListing> {
  bool _isLoading = true;
  List<ServiceReadResponse> serviceList = [];

  @override
  void initState() {
    _getServiceList();
  }

  _getServiceList() {
    setState(() {
      _isLoading = true;
    });
    HTTPManager().getServiceListing(
        ServiceListRequest(companyId: globalSessionUser.companyId),
        []).then((value) {
      setState(() {
        _isLoading = false;
        serviceList = value.values;
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _getServiceList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Service Listing'),
        ),
        body: Stack(
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: serviceList.length == 0
                    ? Text("No Service available")
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text("Sr.No#")),
                                DataColumn(label: Text("Name")),
                                DataColumn(label: Text("Price")),
                                DataColumn(label: Text("Service Color")),
                                DataColumn(label: Text("Customer Message")),
                                DataColumn(label: Text("Created At")),
                                DataColumn(label: Text("Updated At")),
                                DataColumn(label: Text("Status")),
                                DataColumn(label: Text("Actions")),
                              ],
                              rows: List.generate(
                                  serviceList.length,
                                  (index) => DataRow(cells: <DataCell>[
                                        DataCell(Text('${index + 1}')),
                                        DataCell(Text(serviceList[index].name)),
                                        DataCell(Text(
                                            '${serviceList[index].price}')),
                                        DataCell(Text(
                                            serviceList[index].serviceColor)),
                                        DataCell(Text(serviceList[index]
                                                    .customerMessage ==
                                                null
                                            ? " "
                                            : serviceList[index]
                                                .customerMessage)),
                                        DataCell(Text(DateFormat.yMMMd().format(
                                            serviceList[index].createdAt))),
                                        DataCell(Text(DateFormat.yMMMd().format(
                                            serviceList[index].updatedAt))),
                                        DataCell(Switch(
                                          value: serviceList[index].isActive,
                                          onChanged: (value) {
                                            setState(() {
                                              serviceList[index].isActive =
                                                  value;
                                            });
                                            _activateService(
                                                serviceList[index]);
                                          },
                                          activeTrackColor: Colors.blue,
                                          activeColor: Colors.white,
                                          inactiveThumbColor: Colors.grey,
                                        )),
                                        DataCell(Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.edit),
                                              onPressed: () {
                                                _updateService(
                                                    serviceList[index]);
                                              },
                                            ),
                                            // IconButton(
                                            //   icon: Icon(Icons.delete),
                                            //   onPressed: () {
                                            //     _deleteService(
                                            //         serviceList[index]);
                                            //   },
                                            // )
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

  _activateService(ServiceReadResponse serviceReadResponse) {
    setState(() {
      _isLoading = true;
    });
    HTTPManager()
        .statusService(ServiceStatusRequest(
            status: serviceReadResponse.isActive ? "1" : "0",
            id: "${serviceReadResponse.id}",
            companyId: "${serviceReadResponse.companyId}"))
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      showAlert(context, value.message, false, () {}, () {
        _getServiceList();
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _activateService(serviceReadResponse);
      });
    });
  }

  _updateService(ServiceReadResponse serviceReadResponse) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) => EditService(
                  serviceReadResponse: serviceReadResponse,
                )))
        .then((value) {
      _getServiceList();
    });
  }

  _deleteService(ServiceReadResponse serviceReadResponse) {
    confirmDelete(context, () {
      setState(() {
        _isLoading = true;
      });
      HTTPManager()
          .deleteService(ServiceDeleteRequest(
        id: '${serviceReadResponse.id}',
        companyId: '${serviceReadResponse.companyId}',
      ))
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        showAlert(context, value.message, false, () {}, () {
          _getServiceList();
        });
      }).catchError((e) {
        print(e);
        showAlert(context, e.toString(), true, () {
          setState(() {
            _isLoading = false;
          });
        }, () {
          _deleteService(serviceReadResponse);
        });
      });
    });
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:powerdiary/models/request/category_request.dart';
import 'package:powerdiary/models/response/category_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/pages/category/edit_category.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/utils/utils.dart';

class CategoryListing extends StatefulWidget {
  @override
  _CategoryListingState createState() => _CategoryListingState();
}

class _CategoryListingState extends State<CategoryListing> {
  bool _isLoading = true;
  String api_response = "";
  List<CategoryReadResponse> categoryList = [];

  @override
  void initState() {
    _getCategoryList();
  }

  _getCategoryList() {
    HTTPManager()
        .getCategoryListing(
            CategoryListRequest(companyId: globalSessionUser.companyId))
        .then((value) {
      setState(() {
        _isLoading = false;
        categoryList = value.values;
        api_response = jsonEncode(value.values);
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _getCategoryList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Category Listing'),
        ),
        body: Stack(
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: categoryList.length == 0
                    ? Text("No Category available")
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text("Sr.No#")),
                                DataColumn(label: Text("Category Name")),
                                //DataColumn(label: Text("Category Description")),
                                DataColumn(label: Text("Created At")),
                                DataColumn(label: Text("Status")),
                                DataColumn(label: Text("Action")),
                              ],
                              rows: List.generate(
                                  categoryList.length,
                                  (index) => DataRow(cells: <DataCell>[
                                        DataCell(Text('${index + 1}')),
                                        DataCell(
                                            Text(categoryList[index].name)),
                                        // DataCell(Text(
                                        //     categoryList[index].description)),
                                        DataCell(Text(DateFormat.yMMMd().format(
                                            categoryList[index].createdAt))),
                                        DataCell(Switch(
                                          value: categoryList[index].isActive,
                                          onChanged: (value) {
                                            setState(() {
                                              categoryList[index].isActive =
                                                  value;
                                            });
                                            _activateCategory(
                                                categoryList[index]);
                                          },
                                          //activeTrackColor: Colors.blue,
                                          // activeColor: Colors.white,
                                          //inactiveThumbColor: Colors.grey,
                                        )),
                                        DataCell(Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.edit,
                                              ),
                                              onPressed: () {
                                                _updateCategory(
                                                    categoryList[index]);
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                              ),
                                              onPressed: () {
                                                _deleteCategory(
                                                    categoryList[index]);
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

  _activateCategory(CategoryReadResponse categoryReadResponse) {
    setState(() {
      _isLoading = true;
    });
    HTTPManager()
        .statusCategory(CategoryStatusRequest(
            status: categoryReadResponse.isActive ? "1" : "0",
            id: "${categoryReadResponse.id}",
            companyId: "${categoryReadResponse.companyId}"))
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      showAlert(context, value.message, false, () {}, () {
        _getCategoryList();
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _activateCategory(categoryReadResponse);
      });
    });
  }

  _updateCategory(CategoryReadResponse categoryReadResponse) {
    Navigator.of(context)
        .push(new MaterialPageRoute(
            builder: (BuildContext context) => EditCategory(
                  categoryReadResponse: categoryReadResponse,
                )))
        .then((value) {
      _getCategoryList();
    });
  }

  _deleteCategory(CategoryReadResponse categoryReadResponse) {
    confirmDelete(context, () {
      setState(() {
        _isLoading = true;
      });
      HTTPManager()
          .deleteCategory(CategoryDeleteRequest(
        id: '${categoryReadResponse.id}',
        companyId: '${categoryReadResponse.companyId}',
        //name: categoryReadResponse.name,
      ))
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        showAlert(context, value.message, false, () {}, () {
          _getCategoryList();
        });
      }).catchError((e) {
        print(e);
        showAlert(context, e.toString(), true, () {
          setState(() {
            _isLoading = false;
          });
        }, () {
          _deleteCategory(categoryReadResponse);
        });
      });
    });
  }
}

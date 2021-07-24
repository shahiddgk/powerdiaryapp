import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerdiary/models/request/category_request.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/utils/utils.dart';

class CreateCategory extends StatefulWidget {
  @override
  _CreateCategoryState createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  final GlobalKey<FormState> _categoryFormKey = GlobalKey<FormState>();
  TextEditingController _nameController = new TextEditingController();
  //TextEditingController _descriptionController = new TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Category'),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 50.0,
              horizontal: 10.0,
            ),
            child: Form(
              key: _categoryFormKey,
              child: Column(
                children: <Widget>[
                  TextFeildWidget(
                    hint: 'Category Name',
                    controller: _nameController,
                  ),
                  // TextFeildWidget(
                  //   hint: 'Category Description',
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
                          onPressed: _submitCategory,
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

  _submitCategory() {
    if (_categoryFormKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      HTTPManager()
          .createCategory(CategoryCreateRequest(
        companyId: '${globalSessionUser.companyId}',
        name: _nameController.text,
        //  description: _descriptionController.text
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
        showAlert(context, e.toString(), true, () {
          setState(() {
            _isLoading = false;
          });
        }, () {
          _submitCategory();
        });
      });
    }
  }
}

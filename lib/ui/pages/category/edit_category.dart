import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerdiary/models/request/category_request.dart';
import 'package:powerdiary/models/response/category_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/utils/utils.dart';

class EditCategory extends StatefulWidget {
  final CategoryReadResponse categoryReadResponse;

  const EditCategory({Key key, this.categoryReadResponse}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final GlobalKey<FormState> _categoryFormKey = GlobalKey<FormState>();
  TextEditingController _nameController = new TextEditingController();
  //TextEditingController _descriptionController = new TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _nameController.text = widget.categoryReadResponse.name;
      //  _descriptionController.text = widget.categoryReadResponse.description;
      _isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Category'),
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
                          title: "Update",
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
          .updateCategory(CategoryUpdateRequest(
        id: '${widget.categoryReadResponse.id}',
        companyId: '${widget.categoryReadResponse.companyId}',
        name: _nameController.text,
        //     description: _descriptionController.text
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

import 'package:flutter/material.dart';
import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:powerdiary/models/request/QutationListRequest.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_progress_indicator.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:powerdiary/utils/utils.dart';

class SendQuote extends StatefulWidget {
  @override
  _SendQuoteState createState() => _SendQuoteState();
}

class _SendQuoteState extends State<SendQuote> {
  final GlobalKey<FormState> _quoteFormKey = GlobalKey<FormState>();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  bool _isLoading = false;

  GlobalKey<FlutterSummernoteState> _keyEditor = GlobalKey();
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Send Quote'),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 50.0,
              horizontal: 10.0,
            ),
            child: Form(
              key: _quoteFormKey,
              child: Column(
                children: [
                  TextFeildWidget(
                    hint: 'Email',
                    controller: _emailController,
                    isEmail:true
                  ),
                  Expanded(
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: FlutterSummernote(
                            //height: MediaQuery.of(context).size.height/1.5,
                            hint: "Your text here...",
                            key: _keyEditor,
                            hasAttachment: false,
                            customToolbar: """
                      [
                        ['style', ['bold', 'italic', 'underline', 'clear']],
                        ['font', ['strikethrough', 'superscript', 'subscript']],
                        ['insert', ['link', 'table', 'hr']]
                      ]
                    """,
                          ))),
                  ButtonWidget(
                    title: 'Send Quote',
                    onPressed: _submitQuote,
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

  _submitQuote() async {
    String keyeditortext = await _keyEditor.currentState.getText();
    if (_quoteFormKey.currentState.validate() && keyeditortext.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      HTTPManager()
          .createQuote(QutationCreateRequest(
        email: _emailController.text,
        message: keyeditortext,
        companyId: '${globalSessionUser.companyId}',
        createdAt: '${globalSessionUser.createdAt}',
        id: '${globalSessionUser.id}',
        updatedAt: '${globalSessionUser.updatedAt}',
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
          _submitQuote();
        });
      });
    }
  }
}

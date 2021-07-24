import 'package:flutter/material.dart';
import 'package:powerdiary/models/response/qutations_list_response.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:flutter_summernote/flutter_summernote.dart';

GlobalKey<FlutterSummernoteState> _keyEditor = GlobalKey();
final _scaffoldState = GlobalKey<ScaffoldState>();
String result = "";

class QuoteDetail extends StatefulWidget {
  final QutationReadResponse qutationReadResponse;
  const QuoteDetail({Key key, this.qutationReadResponse}) : super(key: key);
  @override
  _QuoteDetailState createState() => _QuoteDetailState();
}

class _QuoteDetailState extends State<QuoteDetail> {
  final GlobalKey<FormState> _quoteFormKey = GlobalKey<FormState>();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _emailController.text = widget.qutationReadResponse.email;
      _descriptionController.text = widget.qutationReadResponse.message;
      _isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quote Detail'),
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
                  ),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: FlutterSummernote(
                            //height: MediaQuery.of(context).size.height/1.5,
                            // hint: 'Your text here...',
                            key: _keyEditor,
                            hasAttachment: false,
                            value: _descriptionController.text,
                            customToolbar: """
                      [
                        ['style', ['bold', 'italic', 'underline', 'clear']],
                        ['font', ['strikethrough', 'superscript', 'subscript']],
                        ['insert', ['link', 'table', 'hr']]
                      ]
                    """,
                          ))),
                  ButtonWidget(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    title: 'Close',
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

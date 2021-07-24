import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerdiary/ui/widgets/widget_button.dart';
import 'package:powerdiary/ui/widgets/widget_text_field.dart';
import 'package:http/http.dart' as http;

class MailingService extends StatefulWidget {
  @override
  _MailingServiceState createState() => _MailingServiceState();
}

class _MailingServiceState extends State<MailingService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mailing Service'),
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
              child: Form(
                child: Column(
                  children: [
                    TextFeildWidget(
                      hint: 'Email',
                    ),
                    TextFeildWidget(
                      hint: 'Email heading',
                    ),
                    TextFeildWidget(
                      hint: 'offer',
                    ),
                    TextFeildWidget(
                      hint: 'First Message',
                    ),
                    TextFeildWidget(
                      hint: 'Second Message',
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFeildWidget(
                            hint: 'Upload First image',
                          ),
                        ),
                        Expanded(
                          child: TextFeildWidget(
                            hint: 'Upload Second image',
                          ),
                        ),
                      ],
                    ),
                    TextFeildWidget(
                      hint: 'Contact Us(Detail)',
                    ),
                    ButtonWidget(
                      title: "Send Mails",
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message'),
      ),
      body: Container(
        child: Center(
          child: Text(
            "Message",
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

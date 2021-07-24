import 'package:flutter/material.dart';

class Roles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roles'),
      ),
      body: Container(
        child: Center(
          child: Text(
            "Roles",
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

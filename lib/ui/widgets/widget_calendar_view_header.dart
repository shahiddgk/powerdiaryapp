import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarViewHeader extends StatelessWidget {
  final DateTime dateTime;

  CalendarViewHeader({this.dateTime});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            formatDate(dateTime),
            style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25,
              // color: Colors.blue
            ),
          ),
          Icon(
            Icons.calendar_today_outlined,
            // color: Colors.blue,
          )
        ],
      ),
    );
  }

  String formatDate(DateTime date) => new DateFormat("MMMM y").format(date);
}

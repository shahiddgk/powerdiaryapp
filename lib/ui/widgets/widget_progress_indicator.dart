import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PDProgressIndicator extends StatelessWidget {
  PDProgressIndicator(
      {Key key,
      this.opacity: 0.5,
      this.dismissibles: false,
      this.color: Colors.black})
      : super(key: key);

  final double opacity;
  final bool dismissibles;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: opacity,
          child: const ModalBarrier(dismissible: false, color: Colors.black),
        ),
        Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Center(child: CircularProgressIndicator())],
        )),
      ],
    );
  }
}

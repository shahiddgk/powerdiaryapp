import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageWidget extends StatefulWidget {
  final Function(File imageFile) onImagePick;
  final String networkImage;

  ProfileImageWidget({Key key, this.onImagePick, this.networkImage = null})
      : super(key: key);

  @override
  _ProfileImageWidgetState createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  File _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(
      children: [
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _imageFile == null
              ? widget.networkImage == null
                  ? AssetImage('assets/backgroundflutteruser.jpg')
                  : NetworkImage(widget.networkImage)
              : FileImage(_imageFile),
        ),
        Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  elevation: 5,
                  context: context,
                  builder: (builder) => bottomSheet(),
                );
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.black,
                size: 30.0,
              ),
            ))
      ],
    ));
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Column(
        children: [
          Text(
            "Choose profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton.icon(
                icon: Icon(Icons.camera_alt),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: Text("Camera"),
              ),
              FlatButton.icon(
                icon: Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: Text("Gallery"),
              )
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      widget.onImagePick(File(pickedFile.path));
    }
  }
}

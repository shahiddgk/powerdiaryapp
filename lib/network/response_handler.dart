import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:powerdiary/models/response/general_response_model.dart';
import 'package:powerdiary/models/response/post_code_address_response.dart';
import 'package:powerdiary/models/response/post_code_response_model.dart';

import 'app_exceptions.dart';

String MESSAGE_KEY = 'message';

class ResponseHandler {
  Map<String, String> setTokenHeader() {
    return {
      '': ''
    }; //{'Authorization': 'Bearer ${Constants.authenticatedToken}'};
  }

  Future<GeneralResponseModel> post(
      String url, Map<String, dynamic> params, bool isHeaderRequired) async {
    var head = Map<String, String>();
    head['content-type'] = 'application/x-www-form-urlencoded';
    var responseJson;
    try {
      final response = await http.post(url, body: params, headers: head);
      responseJson = json.decode(response.body.toString());
      print(responseJson);
      var res =
          GeneralResponseModel.fromJson(json.decode(response.body.toString()));
      if (!res.status) throw FetchDataException(res.message);
      return res;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<GeneralResponseModel> postImage(String url, Map<String, String> params,
      File image, bool isHeaderRequired, String message) async {
    var head = Map<String, String>();
    head['content-type'] = 'application/x-www-form-urlencoded';
    var res;
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      if (image != null) {
        final file = await http.MultipartFile.fromPath(
            'image',
            image
                .path); //,contentType: MediaType(mimeTypeData[0], mimeTypeData[1])
        request.files.add(file);
      }
      request.fields.addAll(params);
      await request.send().then((response) {
        if (response.statusCode == 200) print("Uploaded!");
        res = GeneralResponseModel(
            status: response.statusCode == 200,
            message: response.statusCode == 200
                ? "User $message"
                : "User Not $message",
            data: null);
      });
      return res;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<GeneralResponseModel> get(String url, bool isHeaderRequired) async {
    var head = Map<String, String>();
    head['content-type'] = 'application/json; charset=utf-8';
    var responseJson;
    try {
      final response = await http.get(url, headers: head);
      responseJson = json.decode(response.body.toString());
      print(responseJson);

      var res =
          GeneralResponseModel.fromJson(json.decode(response.body.toString()));
      if (!res.status) throw FetchDataException(res.message);
      return res;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<PostCodeResponseModel> getPost(
      String url, bool isHeaderRequired) async {
    var head = Map<String, String>();
    head['content-type'] = 'application/json; charset=utf-8';
    var responseJson;
    try {
      final response = await http.get(url, headers: head);
      responseJson = json.decode(response.body.toString());
      print(responseJson);

      var res =
          PostCodeResponseModel.fromJson(json.decode(response.body.toString()));
      if (res.code != 2000) throw FetchDataException(res.message);
      return res;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<PostCodeResponseModel> postAddress(
      String url, Map<String, dynamic> params, bool isHeaderRequired) async {
    var head = Map<String, String>();
    head['content-type'] = 'application/json; charset=utf-8';
    var responseJson;
    try {
      final response = await http.post(url, body: params, headers: head);
      responseJson = json.decode(response.body.toString());
      print(responseJson);
      var res =
          PostCodeResponseModel.fromJson(json.decode(response.body.toString()));
      if (res.total == 0) throw FetchDataException(res.message);
      return res;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }
}

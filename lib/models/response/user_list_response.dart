import 'package:flutter/cupertino.dart';

class UserReadResponse {
  int id;
  int roleId;
  int companyId;
  String role_name;
  String name;
  String email;
  String password;
  String image;
  bool isActive;
  int isDeleted;
  DateTime createdAt;
  DateTime updatedAt;

  UserReadResponse(
      {this.id,
      this.roleId,
      this.companyId,
      this.role_name,
      this.name,
      this.email,
      this.password,
      this.image,
      this.isActive,
      this.isDeleted,
      this.createdAt,
      this.updatedAt});

  UserReadResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? 0 : json['id'];
    roleId = json['role_id'] == null ? 0 : json['role_id'];
    role_name = json['role_name'] == null ? "" : json['role_name'];
    companyId = json['company_id'] == null ? 0 : json['company_id'];
    name = json['name'] == null ? "" : json['name'];
    email = json['email'] == null ? "" : json['email'];
    password = json['password'] == null ? "" : json['password'];
    image = json['image'] == null ? "" : json['image'];
    isActive = json['is_active'] == 1 ? true : false;
    isDeleted = json['is_deleted'] == null ? 0 : json['is_deleted'];
    createdAt = DateTime.parse(json['created_at']) == null
        ? DateTime.now()
        : DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']) == null
        ? DateTime.now()
        : DateTime.parse(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role_id'] = this.roleId;
    data['company_id'] = this.companyId;
    data['role_name'] = this.role_name;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['image'] = this.image;
    data['is_active'] = this.isActive;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt.toString();
    data['updated_at'] = this.updatedAt.toString();
    return data;
  }
}

class UserListModel {
  List<UserReadResponse> values = [];

  UserListModel() {
    values = [];
  }

  UserListModel.fromJson(var jsonObject) {
    for (var area in jsonObject) {
      UserReadResponse model = UserReadResponse.fromJson(area);
      this.values.add(model);
    }
  }
}

import 'dart:io';

class UserListRequest {
  int companyId;

  UserListRequest({
    this.companyId,
  });

  UserListRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId.toString();
    return data;
  }
}

class UserTokenRequest {
  String userId;
  String fcmToken;

  UserTokenRequest({this.userId, this.fcmToken});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userId;
    data['token'] = this.fcmToken;
    return data;
  }
}

class UserCreateRequest {
  String companyId;
  String name;
  String email;
  String password;
  String roleId;
  File file;

  UserCreateRequest(
      {this.companyId,
      this.name,
      this.email,
      this.password,
      this.roleId,
      this.file});

  UserCreateRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    roleId = json['role_id'];
    file = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['company_id'] = this.companyId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['role_id'] = this.roleId;
    data['image'] = this.file == null ? "" : this.file.path;
    return data;
  }
}

class UserUpdateRequest {
  String companyId;
  String name;
  String email;
  String password;
  String roleId;
  String id;
  File file;

  UserUpdateRequest(
      {this.companyId,
      this.name,
      this.email,
      this.password,
      this.roleId,
      this.id,
      this.file});

  UserUpdateRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    roleId = json['role_id'];
    id = json['id'];
    file = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['company_id'] = this.companyId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['role_id'] = this.roleId;
    data['id'] = this.id;
    data['image'] = this.file == null ? "" : this.file.path;
    return data;
  }
}

class UserDeleteRequest {
  String companyId;
  String id;

  UserDeleteRequest({this.companyId, this.id});

  UserDeleteRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId;
    data['id'] = this.id;
    return data;
  }
}

class CategoryShowRequest {
  String companyId;
  String id;

  CategoryShowRequest({this.companyId, this.id});

  CategoryShowRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId;
    data['id'] = this.id;
    return data;
  }
}

class UserStatusRequest {
  String id;
  String companyId;
  String status;

  UserStatusRequest({this.id, this.companyId, this.status});

  UserStatusRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['status'] = this.status;
    return data;
  }
}

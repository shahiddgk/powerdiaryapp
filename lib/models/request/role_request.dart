import 'dart:convert';

class RoleListRequest {
  int companyId;

  RoleListRequest({this.companyId});

  RoleListRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId.toString();
    return data;
  }
}

class RoleCreateRequest {
  int companyId;
  String role;
  Map<String, List<String>> accessIds;

  RoleCreateRequest({this.companyId, this.role, this.accessIds});

  RoleCreateRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    role = json['role'];
    accessIds = json['access_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId.toString();
    data['role'] = this.role;
    data['access_id'] = jsonEncode(accessIds);
    return data;
  }
}

class RoleUpdateRequest {
  int id;
  int companyId;
  String role;
  Map<String, List<String>> accessIds;

  RoleUpdateRequest({this.id, this.companyId, this.role, this.accessIds});

  RoleUpdateRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    role = json['role'];
    accessIds = json['access_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id.toString();
    data['company_id'] = this.companyId.toString();
    data['role'] = this.role.toString();
    data['access_id'] = jsonEncode(accessIds);
    return data;
  }
}

class RoleDeleteRequest {
  String companyId;
  String id;

  RoleDeleteRequest({
    this.companyId,
    this.id,
  });

  RoleDeleteRequest.fromJson(Map<String, dynamic> json) {
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

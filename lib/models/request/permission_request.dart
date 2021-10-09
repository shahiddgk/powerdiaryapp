class PermissionListRequest {
  int companyId;
  int roleId;

  PermissionListRequest({this.companyId, this.roleId});

  PermissionListRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    roleId = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId.toString();
    data['role_id'] = this.roleId.toString();
    return data;
  }
}

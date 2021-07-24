class RolesReadResponse {
  int id;
  String role;
  int companyId;
  bool isActive;
  int isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  Map<String, List<String>> accessIdMap;

  RolesReadResponse(
      {this.id,
      this.role,
      this.companyId,
      this.isActive,
      this.isDeleted,
      this.createdAt,
      this.updatedAt,
      this.accessIdMap});

  RolesReadResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? 0 : json['id'];
    role = json['role'] == null ? "" : json['role'];
    companyId = json['company_id'] == null ? 0 : json['company_id'];
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
    data['role'] = this.role;
    data['company_id'] = this.companyId;
    data['is_active'] = this.isActive;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt.toString();
    data['updated_at'] = this.updatedAt.toString();
    return data;
  }
}

class RolePermissions {
  int roleId;
  String permissionId;
  String accessId;
  int companyId;

  RolePermissions(
      {this.roleId, this.permissionId, this.accessId, this.companyId});

  RolePermissions.fromJson(Map<String, dynamic> json) {
    roleId = json['role_id'];
    permissionId = '${json['permission_id']}';
    accessId = json['access_id'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role_id'] = this.roleId;
    data['permission_id'] = this.permissionId;
    data['access_id'] = this.accessId;
    data['company_id'] = this.companyId;
    return data;
  }
}

class RoleListModel {
  List<RolesReadResponse> values = [];

  RoleListModel() {
    values = [];
  }

  RoleListModel.fromJson(var jsonObject) {
    List<RolePermissions> allRolePermissions = [];
    var roles = jsonObject["roles"];
    var rolePerms = jsonObject["role_permissions"];

    for (var permission in rolePerms) {
      RolePermissions model = RolePermissions.fromJson(permission);
      allRolePermissions.add(model);
    }

    for (var role in roles) {
      RolesReadResponse model = RolesReadResponse.fromJson(role);
      model.accessIdMap = new Map<String, List<String>>();
      var rolePermission = allRolePermissions.where((element) => element.roleId==model.id);
      for (var per in rolePermission) {
          List<String> aids = model.accessIdMap[per.permissionId] == null
              ? []
              : model.accessIdMap[per.permissionId];
          if (!aids.contains(per.accessId)) aids.add(per.accessId);
          model.accessIdMap[per.permissionId] = aids;
      }
      this.values.add(model);
    }
  }
}

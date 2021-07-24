class RolePermissionResponse {
  int id;
  String name;
  bool read, create, edit, delete, view, export, graph;
  List modulePermissions;

  RolePermissionResponse({this.id, this.name});

  RolePermissionResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? 0 : json['id'];
    name = json['name'] == null ? "" : json['name'];

    //Remove module permissions for 'category','services','customer', 'booking'
    if ([1, 2, 3, 6, 7, 8, 9].contains(id)) {
      modulePermissions = ["1", "2", "3", "4"];
    } else if (id == 4) {
      modulePermissions = ["1", "2", "3", "4", "5"];
    } else if (id == 10) {
      modulePermissions = ["1", "2"];
    } else if (id == 11) {
      modulePermissions = ["1"];
    } else {
      modulePermissions = ["1", "2", "3", "4", "5", "6", "7"];
    }
    read = false;
    create = false;
    edit = false;
    delete = false;
    view = false;
    export = false;
    graph = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class RolePermissionList {
  List<RolePermissionResponse> values = [];

  RolePermissionList() {
    values = [];
  }

  RolePermissionList.fromJson(
      Map<String, List<String>> accessIdMap, var jsonObject) {
    for (var area in jsonObject) {
      RolePermissionResponse model = RolePermissionResponse.fromJson(area);
      if (accessIdMap != null) {
        model.read = setCheckBoxValue(accessIdMap, model.id, '1');
        model.create = setCheckBoxValue(accessIdMap, model.id, '2');
        model.edit = setCheckBoxValue(accessIdMap, model.id, '3');
        model.delete = setCheckBoxValue(accessIdMap, model.id, '4');
        model.view = setCheckBoxValue(accessIdMap, model.id, '5');
        model.export = setCheckBoxValue(accessIdMap, model.id, '6');
        model.graph = setCheckBoxValue(accessIdMap, model.id, '7');
      }
      this.values.add(model);
    }
  }

  bool setCheckBoxValue(Map<String, List<String>> accessIdMap, int permissionId,
      String accessId) {
    List<String> aids = accessIdMap["$permissionId"];
    return aids == null ? false : aids.contains(accessId);
  }
}

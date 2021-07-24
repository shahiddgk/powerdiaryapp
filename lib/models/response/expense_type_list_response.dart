class ExpenseTypeReadResponse {
  int id;
  String type;
  String description;
  int companyId;
  int isActive;
  int isDeleted;
  DateTime createdAt;
  DateTime updatedAt;

  ExpenseTypeReadResponse(
      {this.id,
      this.type,
      this.description,
      this.companyId,
      this.isActive,
      this.isDeleted,
      this.createdAt,
      this.updatedAt});

  ExpenseTypeReadResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? 0 : json['id'];
    type = json['type'] == null ? "" : json['type'];
    description = json['description'] == null ? "" : json['description'];
    companyId = json['company_id'] == null ? 0 : json['company_id'];
    isActive = json['is_active'] == null ? 0 : json['is_active'];
    isDeleted = json['is_deleted'] == null ? 0 : json['is_deleted'];
    createdAt = DateTime.parse(json['created_at']) == null
        ?  DateTime.now()
        : DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']) == null
        ?  DateTime.now()
        : DateTime.parse(json['created_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['description'] = this.description;
    data['company_id'] = this.companyId;
    data['is_active'] = this.isActive;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt.toString();
    data['updated_at'] = this.updatedAt.toString();
    return data;
  }
}

class ExpenseTypeListModel {
  List<ExpenseTypeReadResponse> values = [];

  ExpenseTypeListModel() {
    values = [];
  }

  ExpenseTypeListModel.fromJson(var jsonObject) {
    for (var area in jsonObject) {
      ExpenseTypeReadResponse model = ExpenseTypeReadResponse.fromJson(area);
      this.values.add(model);
    }
  }
}

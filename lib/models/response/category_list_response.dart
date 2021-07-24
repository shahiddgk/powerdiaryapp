class CategoryReadResponse {
  int id;
  String name;
  String description;
  int companyId;
  bool isActive;
  int isDeleted;
  DateTime createdAt;
  DateTime updatedAt;

  CategoryReadResponse({this.id,
    this.name,
    this.description,
    this.companyId,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt});

  CategoryReadResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? 0 : json['id'];
    name = json['name'] == null ? "" : json['name'];
    description = json['description'] == null ? "" : json['description'];
    companyId = json['company_id'] == null ? 0 : json['company_id'];
    isActive = json['is_active'] == 1 ? true : false;
    isDeleted = json['is_deleted'] == null ? 0 : json['is_deleted'];
    createdAt = DateTime.parse(json['created_at']) == null ? DateTime.now() : DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']) == null ? DateTime.now() : DateTime.parse(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['company_id'] = this.companyId;
    data['is_active'] = this.isActive;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt.toString();
    data['updated_at'] = this.updatedAt.toString();
    return data;
  }
}

class CategoryListModel {
  List<CategoryReadResponse> values = [];

  CategoryListModel() {
    values = [];
  }

  CategoryListModel.fromJson(var jsonObject) {
    for (var area in jsonObject) {
      CategoryReadResponse model = CategoryReadResponse.fromJson(area);
      this.values.add(model);
    }
  }
}

class QutationReadResponse {
  int id;
  String email;
  String message;
  int companyId;
  String createdAt;
  String updatedAt;

  QutationReadResponse(
      {this.id,
        this.email,
        this.message,
        this.companyId,
        this.createdAt,
        this.updatedAt});

  QutationReadResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? 0 : json['id'] ;
    email = json['email'] == null ? "" : json['email'];
    message = json['message'] == null ? "" : json['message'];
    companyId = json['company_id'] == null ? 0 : json['company_id'];
    createdAt = json['created_at'] == null ?  "" : json['created_at'];
    updatedAt = json['updated_at'] == null ?  "" : json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['message'] = this.message;
    data['company_id'] = this.companyId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class  QutationsListModel {
  List<QutationReadResponse> values = [];

  CategoryListModel() {
    values = [];
  }

  QutationsListModel.fromJson(var jsonObject) {
    for (var area in jsonObject) {
      QutationReadResponse model = QutationReadResponse.fromJson(area);
      this.values.add(model);
    }
  }
}
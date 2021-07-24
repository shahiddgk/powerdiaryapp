class QutationListRequest {
  int companyId;

  QutationListRequest({this.companyId});

  QutationListRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId.toString();
    return data;
  }
}

class QutationCreateRequest {
  String email;
  String message;
  String companyId;
  String updatedAt;
  String createdAt;
  String id;

  QutationCreateRequest(
      {this.email,
        this.message,
        this.companyId,
        this.updatedAt,
        this.createdAt,
        this.id});

  QutationCreateRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    message = json['message'];
    companyId = json['company_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['message'] = this.message;
    data['company_id'] = this.companyId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
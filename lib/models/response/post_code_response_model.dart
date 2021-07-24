class PostCodeResponseModel {
  int code;
  String message;
  int total;
  int page;
  int limit;
  dynamic result;

  PostCodeResponseModel(
      {this.code,
      this.message,
      this.total,
      this.page,
      this.limit,
      this.result});

  PostCodeResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['total'] = this.total;
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['result'] = this.result;
    return data;
  }
}

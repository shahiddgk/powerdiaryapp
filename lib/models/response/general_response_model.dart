class GeneralResponseModel {
  bool status;
  String message;
  dynamic data;

  GeneralResponseModel({this.status, this.message, this.data});

  GeneralResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['success'];
    message = json['message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}

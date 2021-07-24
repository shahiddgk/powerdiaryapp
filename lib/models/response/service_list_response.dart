class ServiceReadResponse {
  int id;
  int categoryId;
  String name;
  int price;
  String serviceColor;
  String customerMessage;
  int companyId;
  bool isActive;
  int isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  bool isSelected;

  ServiceReadResponse(
      {this.id,
      this.categoryId,
      this.name,
      this.price,
      this.serviceColor,
      this.customerMessage,
      this.companyId,
      this.isActive,
      this.isDeleted,
      this.createdAt,
      this.updatedAt,
      this.isSelected = false});

  ServiceReadResponse.fromJson(Map<String, dynamic> json, List selected) {
    id = json['id'] == null ? 0 : json['id'];
    categoryId = json['category_id'] == null ? 0 : json['category_id'];
    name = json['name'] == null ? "" : json['name'];
    price = json['price'] == null ? 0 : json['price'];
    serviceColor = json['service_color'] == null ? "" : json['service_color'];
    customerMessage =
        json['customer_message'] == null ? "" : json['customer_message'];
    companyId = json['company_id'] == null ? 0 : json['company_id'];
    isActive = json['is_active'] == 1 ? true : false;
    isDeleted = json['is_deleted'] == null ? 0 : json['is_deleted'];
    createdAt = DateTime.parse(json['created_at']) == null
        ? DateTime.now()
        : DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']) == null
        ? DateTime.now()
        : DateTime.parse(json['updated_at']);
    isSelected = selected.contains("$id") ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['service_color'] = this.serviceColor;
    data['customer_message'] = this.customerMessage;
    data['company_id'] = this.companyId;
    data['is_active'] = this.isActive;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt.toString();
    data['updated_at'] = this.updatedAt.toString();
    return data;
  }
}

class ServiceListModel {
  List<ServiceReadResponse> values = [];

  ServiceListModel() {
    values = [];
  }

  ServiceListModel.fromJson(var jsonObject, List selected) {
    for (var service in jsonObject) {
      ServiceReadResponse model =
          ServiceReadResponse.fromJson(service, selected);
      this.values.add(model);
    }
  }
}

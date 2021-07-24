class ServiceListRequest {
  int companyId;

  ServiceListRequest({this.companyId});

  ServiceListRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId.toString();
    return data;
  }
}

class ServiceUpdateRequest {
  String id;
  String categoryId;
  String name;
  String price;
  String serviceColor;
  String customerMessage;
  String companyId;
  // int isActive;
  // int isDeleted;
  // String createdAt;
  // String updatedAt;

  ServiceUpdateRequest({
    this.id,
    this.categoryId,
    this.name,
    this.price,
    this.serviceColor,
    this.customerMessage,
    this.companyId,
    // this.isActive,
    // this.isDeleted,
    // this.createdAt,
    // this.updatedAt
  });

  ServiceUpdateRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    price = json['price'];
    serviceColor = json['service_color'];
    customerMessage = json['customer_message'];
    companyId = json['company_id'];
    // isActive = json['is_active'];
    // isDeleted = json['is_deleted'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
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
    // data['is_active'] = this.isActive;
    // data['is_deleted'] = this.isDeleted;
    // data['created_at'] = this.createdAt.toString();
    // data['updated_at'] = this.updatedAt.toString();
    return data;
  }
}

class ServiceCreateRequest {
  String categoryId;
  String name;
  String price;
  String serviceColor;
  String customerMessage;
  String companyId;
  String id;
  // int isActive;
  // int isDeleted;
  // String createdAt;
  // String updatedAt;

  ServiceCreateRequest({
    this.categoryId,
    this.name,
    this.price,
    this.serviceColor,
    this.customerMessage,
    this.companyId,
    this.id,
    // this.isActive,
    // this.isDeleted,
    // this.createdAt,
    // this.updatedAt
  });

  ServiceCreateRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    price = json['price'];
    serviceColor = json['service_color'];
    customerMessage = json['customer_message'];
    companyId = json['company_id'];
    // isActive = json['is_active'];
    // isDeleted = json['is_deleted'];
    // createdAt = json['created_at'];
    // updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['service_color'] = this.serviceColor;
    data['customer_message'] = this.customerMessage;
    data['company_id'] = this.companyId;
    // data['is_active'] = this.isActive;
    // data['is_deleted'] = this.isDeleted;
    // data['created_at'] = this.createdAt.toString();
    // data['updated_at'] = this.updatedAt.toString();
    return data;
  }
}

class ServiceDeleteRequest {
  String companyId;
  String id;

  ServiceDeleteRequest({this.companyId, this.id});

  ServiceDeleteRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId;
    data['id'] = this.id;
    return data;
  }
}

class ServiceStatusRequest {
  String id;
  String status;
  String companyId;

  ServiceStatusRequest({this.id, this.status, this.companyId});

  ServiceStatusRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['company_id'] = this.companyId;
    return data;
  }
}

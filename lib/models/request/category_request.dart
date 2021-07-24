class CategoryListRequest {
  int companyId;

  CategoryListRequest({this.companyId});

  CategoryListRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId.toString();
    return data;
  }
}

class CategoryCreateRequest {
  String companyId;
  String name;
  //String description;

  CategoryCreateRequest({
    this.companyId,
    this.name,
    //this.description
  });

  CategoryCreateRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    name = json['name'];
    // description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId;
    data['name'] = this.name;
    //data['description'] = this.description;
    return data;
  }
}

class CategoryUpdateRequest {
  String companyId;
  String name;
  //String description;
  String id;

  CategoryUpdateRequest(
      {this.companyId,
      this.name,
      //this.description,
      this.id});

  CategoryUpdateRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    name = json['name'];
    // description = json['description'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId;
    data['name'] = this.name;
    // data['description'] = this.description;
    data['id'] = this.id;
    return data;
  }
}

class CategoryDeleteRequest {
  String companyId;
  // String name;
  String id;

  CategoryDeleteRequest({this.companyId, this.id});

  CategoryDeleteRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    // name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId;
    // data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}

class CategoryShowRequest {
  String companyId;
  String id;

  CategoryShowRequest({this.companyId, this.id});

  CategoryShowRequest.fromJson(Map<String, dynamic> json) {
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

class CategoryStatusRequest {
  String id;
  String status;
  String companyId;

  CategoryStatusRequest({this.id, this.status, this.companyId});

  CategoryStatusRequest.fromJson(Map<String, dynamic> json) {
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

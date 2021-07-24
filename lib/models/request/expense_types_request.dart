class ExpenseTypeListRequest {
  int companyId;

  ExpenseTypeListRequest({this.companyId});

  ExpenseTypeListRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId.toString();
    return data;
  }
}

class ExpenseTypeShowRequest {
  String companyId;
  String id;

  ExpenseTypeShowRequest({this.companyId, this.id});

  ExpenseTypeShowRequest.fromJson(Map<String, dynamic> json) {
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

class ExpenseTypeUpdateRequest {
  String id;
  String type;
  //String description;
  String companyId;

  ExpenseTypeUpdateRequest({
    this.id,
    this.type,
    //this.description,
    this.companyId,
  });

  ExpenseTypeUpdateRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    //description = json['description'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    //data['description'] = this.description;
    data['company_id'] = this.companyId;
    return data;
  }
}

class ExpenseTypeDeleteRequest {
  String companyId;
  String id;

  ExpenseTypeDeleteRequest({this.companyId, this.id});

  ExpenseTypeDeleteRequest.fromJson(Map<String, dynamic> json) {
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

class ExpenseTypeCreateRequest {
  String companyId;
  String type;
  //String description;

  ExpenseTypeCreateRequest({
    this.companyId,
    this.type,
    // this.description,
  });

  ExpenseTypeCreateRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    type = json['type'];
    // description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId;
    data['type'] = this.type;
    //data['description'] = this.description;
    return data;
  }
}

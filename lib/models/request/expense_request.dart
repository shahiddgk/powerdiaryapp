class ExpenseListRequest {
  int companyId;

  ExpenseListRequest({this.companyId});

  ExpenseListRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId.toString();
    return data;
  }
}

class ExpenseCreateRequest {
  String companyId;
  String expenseType;
  String payable;
  String amount;
  //String description;

  ExpenseCreateRequest({
    this.companyId,
    this.expenseType,
    this.payable,
    this.amount,
    // this.description
  });

  ExpenseCreateRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    expenseType = json['expense_type'];
    payable = json['payable'];
    amount = json['amount'];
    // description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId;
    data['expense_type'] = this.expenseType;
    data['payable'] = this.payable;
    data['amount'] = this.amount;
    //data['description'] = this.description;
    return data;
  }
}

class ExpenseUpdateRequest {
  String id;
  String companyId;
  String expenseType;
  String payable;
  String amount;
  //String description;

  ExpenseUpdateRequest({
    this.id,
    this.companyId,
    this.expenseType,
    this.payable,
    this.amount,
    //this.description
  });

  ExpenseUpdateRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    expenseType = json['expense_type'];
    payable = json['payable'];
    amount = json['amount'];
    // description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['expense_type'] = this.expenseType;
    data['payable'] = this.payable;
    data['amount'] = this.amount;
    //data['description'] = this.description;
    return data;
  }
}

class ExpenseDeleteRequest {
  int companyId;
  int id;

  ExpenseDeleteRequest({this.companyId, this.id});

  ExpenseDeleteRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId.toString();
    data['id'] = this.id.toString();
    return data;
  }
}

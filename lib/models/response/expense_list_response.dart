class ExpenseReadResponse {
  int id;
  String expenseType;
  DateTime payable;
  String amount;
  String description;
  int companyId;
  int isActive;
  int isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  String type;

  ExpenseReadResponse({this.id,
    this.expenseType,
    this.payable,
    this.amount,
    this.description,
    this.companyId,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.type});

  ExpenseReadResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? 0 : json['id'];
    expenseType = json['expense_type'] == null ? "" : json['expense_type'];
    payable = DateTime.parse(json['payable']) == null
        ?  DateTime.now()
        : DateTime.parse(json['payable']);
    amount = json['amount'] == null ? "" : json['amount'];
    description = json['description'] == null ? "" : json['description'];
    companyId = json['company_id'] == null ? 0 : json['company_id'];
    isActive = json['is_active'] == null ? 0 : json['is_active'];
    isDeleted = json['is_deleted'] == null ? 0 : json['is_deleted'];
    createdAt = DateTime.parse(json['created_at']) == null
        ?  DateTime.now()
        : DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']) == null
        ?  DateTime.now()
        : DateTime.parse(json['updated_at']);
    type = json['type'] == null ? "" : json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['expense_type'] = this.expenseType;
    data['payable'] = this.payable;
    data['amount'] = this.amount;
    data['description'] = this.description;
    data['company_id'] = this.companyId;
    data['is_active'] = this.isActive;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['type'] = this.type;
    return data;
  }
}

class ExpenseListResponse {
  List<ExpenseReadResponse> values = [];

  ExpenseListResponse() {
    values = [];
  }

  ExpenseListResponse.fromJson(var jsonObject) {
    for (var area in jsonObject) {
      ExpenseReadResponse model = ExpenseReadResponse.fromJson(area);
      this.values.add(model);
    }
  }
}

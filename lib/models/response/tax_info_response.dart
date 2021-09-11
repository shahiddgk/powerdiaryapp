class TaxInfoResponse {
  int taxStatus;
  int vat;
  int amount;

  TaxInfoResponse({this.taxStatus, this.vat, this.amount});

  TaxInfoResponse.fromJson(Map<String, dynamic> json) {
    taxStatus = json['tax_status'] == null ? 0 : json['tax_status'];
    vat = json['vat'] == null ? 0 : json['vat'];
    amount = json['amount'] == null ? 0 : json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tax_status'] = this.taxStatus;
    data['vat'] = this.vat;
    data['amount'] = this.amount;
    return data;
  }
}

class TaxListModel {
  List<TaxInfoResponse> values = [];

  TaxListModel() {
    values = [];
  }

  TaxListModel.fromJson(var jsonObject) {
    for (var area in jsonObject) {
      TaxInfoResponse model = TaxInfoResponse.fromJson(area);
      this.values.add(model);
    }
  }
}

class CustomerReadResponse {
  int id;
  String firstName;
  String lastName;
  String primaryPhone;
  String secondaryPhone;
  String email;
  String zip;
  String address;
  dynamic longitude;
  dynamic latitude;
  String referredBy;
  dynamic companyId;
  bool isActive;
  int isDeleted;
  DateTime createdAt;
  DateTime updatedAt;

  CustomerReadResponse(
      {this.id,
      this.firstName,
      this.lastName,
      this.primaryPhone,
      this.secondaryPhone,
      this.email,
      this.zip,
      this.address,
      this.longitude,
      this.latitude,
      this.referredBy,
      this.companyId,
      this.isActive,
      this.isDeleted,
      this.createdAt,
      this.updatedAt});

  CustomerReadResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? 0 : json['id'];
    firstName = json['first_name'] == null ? "" : json['first_name'];
    lastName = json['last_name'] == null ? "" : json['last_name'];
    primaryPhone = json['primary_phone'] == null ? "" : json['primary_phone'];
    secondaryPhone =
        json['secondary_phone'] == null ? "" : json['secondary_phone'];
    email = json['email'] == null ? "" : json['email'];
    zip = json['zip'] == null ? "" : json['zip'];
    address = json['address'] == null ? "" : json['address'];
    longitude = json['longitude'] == null ? 0.0 : json['longitude'].toDouble();
    latitude = json['latitude'] == null ? 0.0 : json['latitude'].toDouble();
    referredBy = json['referred_by'] == null ? "" : json['referred_by'];
    companyId = json['company_id'] == null ? 0 : json['company_id'];
    isActive = json['is_active'] == 1 ? true : false;
    isDeleted = json['is_deleted'] == null ? 0 : json['is_deleted'];
    createdAt = DateTime.parse(json['created_at']) == null ? DateTime.now() : DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']) == null ? DateTime.now() : DateTime.parse(json['updated_at']);
  }

  CustomerReadResponse.fromBookingJson(Map<String, dynamic> json) {
    id = json['customer_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    primaryPhone = json['primary_phone'];
    secondaryPhone = json['secondary_phone'];
    email = json['email'];
    zip = json['zip'];
    address = json['address'];
    longitude = json['longitude'] == null ? 0.0 : json['longitude'];
    latitude = json['latitude'] == null ? 0.0 : json['latitude'];
    referredBy = json['referred_by'];
    companyId = json['company_id'];
    isActive = json['is_active'] == 1 ? true : false;
    isDeleted = json['is_deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['primary_phone'] = this.primaryPhone;
    data['secondary_phone'] = this.secondaryPhone;
    data['email'] = this.email;
    data['zip'] = this.zip;
    data['address'] = this.address;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['referred_by'] = this.referredBy;
    data['company_id'] = this.companyId;
    data['is_active'] = this.isActive;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt.toString();
    data['updated_at'] = this.updatedAt.toString();
    return data;
  }

  Map<String, dynamic> toJsonBooking() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['primary_phone'] = this.primaryPhone;
    data['secondary_phone'] = this.secondaryPhone;
    data['email'] = this.email;
    data['zip'] = this.zip;
    data['address'] = this.address;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['referred_by'] = this.referredBy;
    data['company_id'] = this.companyId;
    data['is_active'] = this.isActive;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt.toString();
    data['updated_at'] = this.updatedAt.toString();
    return data;
  }

//   @override
//   String toString() {
//     return '${firstName} ${lastName} ${primaryPhone}';
//   }
}

class CustomerListModel {
  List<CustomerReadResponse> values = [];

  CustomerListModel() {
    values = [];
  }

  CustomerListModel.fromJson(var jsonObject) {
    for (var area in jsonObject) {
      CustomerReadResponse model = CustomerReadResponse.fromJson(area);
      this.values.add(model);
    }
  }


}

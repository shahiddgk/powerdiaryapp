class CustomerListRequest {
  int companyId;

  CustomerListRequest({this.companyId});

  CustomerListRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId.toString();
    return data;
  }
}

class CustomerCreateRequest {
  String firstName;
  String lastName;
  String primaryPhone;
  String secondaryPhone;
  String email;
  String zip;
  String address;
  String referredBy;
  String companyId;
  String latitude;
  String longitude;

  CustomerCreateRequest(
      {this.firstName,
      this.lastName,
      this.primaryPhone,
      this.secondaryPhone,
      this.email,
      this.zip,
      this.address,
      this.latitude,
      this.longitude,
      this.referredBy,
      this.companyId});

  CustomerCreateRequest.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    primaryPhone = json['primary_phone'];
    secondaryPhone = json['secondary_phone'];
    email = json['email'];
    zip = json['zip'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    referredBy = json['referred_by'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['primary_phone'] = this.primaryPhone;
    data['secondary_phone'] = this.secondaryPhone;
    data['email'] = this.email;
    data['zip'] = this.zip;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['referred_by'] = this.referredBy;
    data['company_id'] = this.companyId;
    return data;
  }
}

class CustomerUpdateRequest {
  String firstName;
  String lastName;
  String primaryPhone;
  String secondaryPhone;
  String email;
  String zip;
  String latitude;
  String longitude;
  String address;
  String referredBy;
  String companyId;
  String id;

  CustomerUpdateRequest(
      {this.firstName,
      this.lastName,
      this.primaryPhone,
      this.secondaryPhone,
      this.email,
      this.zip,
      this.address,
      this.latitude,
      this.longitude,
      this.referredBy,
      this.companyId,
      this.id});

  CustomerUpdateRequest.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    primaryPhone = json['primary_phone'];
    secondaryPhone = json['secondary_phone'];
    email = json['email'];
    zip = json['zip'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    referredBy = json['referred_by'];
    companyId = json['company_id'];
    id = json['id'];
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
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['referred_by'] = this.referredBy;
    data['company_id'] = this.companyId;
    return data;
  }
}

class CustomerDeleteRequest {
  String companyId;
  String id;

  CustomerDeleteRequest({this.companyId, this.id});

  CustomerDeleteRequest.fromJson(Map<String, dynamic> json) {
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

class CustomerStatusRequest {
  String id;
  String status;
  String companyId;

  CustomerStatusRequest({this.id, this.status, this.companyId});

  CustomerStatusRequest.fromJson(Map<String, dynamic> json) {
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

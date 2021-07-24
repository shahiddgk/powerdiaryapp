class BookingShowResponse {
  List<BookingDetails> bookingDetails;
  CustomerDetails customerDetails;
  CompanyDetails companyDetails;

  BookingShowResponse(
      {this.bookingDetails, this.customerDetails, this.companyDetails});

  BookingShowResponse.fromJson(Map<String, dynamic> json) {
    if (json['booking_details'] != null) {
      bookingDetails = new List<BookingDetails>();
      json['booking_details'].forEach((v) {
        bookingDetails.add(new BookingDetails.fromJson(v));
      });
    }
    customerDetails = json['customer_details'] != null
        ? new CustomerDetails.fromJson(json['customer_details'])
        : null;
    companyDetails = json['company_details'] != null
        ? new CompanyDetails.fromJson(json['company_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bookingDetails != null) {
      data['booking_details'] =
          this.bookingDetails.map((v) => v.toJson()).toList();
    }
    if (this.customerDetails != null) {
      data['customer_details'] = this.customerDetails.toJson();
    }
    if (this.companyDetails != null) {
      data['company_details'] = this.companyDetails.toJson();
    }
    return data;
  }
}

class BookingDetails {
  String invoice;
  int companyId;
  DateTime bookingDate;
  String notes;
  int totalPrice;
  String serviceName;
  int servicePrice;
  String paymentMethod;
  String chequenumber;

  BookingDetails({
    this.invoice,
    this.companyId,
    this.bookingDate,
    this.notes,
    this.totalPrice,
    this.serviceName,
    this.servicePrice,
    this.paymentMethod,
    this.chequenumber,
  });

  BookingDetails.fromJson(Map<String, dynamic> json) {
    invoice = json['invoice'];
    companyId = json['company_id'];
    bookingDate = DateTime.parse(json['booking_date']);
    notes = json['notes'];
    totalPrice = json['total_price'];
    serviceName = json['service_name'];
    servicePrice = json['service_price'];
    paymentMethod = json['payment_method'];
    chequenumber = json['chequenumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoice'] = this.invoice;
    data['company_id'] = this.companyId;
    data['booking_date'] = this.bookingDate;
    data['notes'] = this.notes;
    data['total_price'] = this.totalPrice;
    data['service_name'] = this.serviceName;
    data['service_price'] = this.servicePrice;
    data['payment_method'] = this.paymentMethod;
    data['chequenumber'] = this.chequenumber;
    return data;
  }
}

class CustomerDetails {
  String customerName;
  String lastName;
  String primaryPhone;
  String email;
  String address;

  CustomerDetails(
      {this.customerName,
      this.lastName,
      this.primaryPhone,
      this.email,
      this.address});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_name'];
    lastName = json['last_name'];
    primaryPhone = json['primary_phone'];
    email = json['email'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_name'] = this.customerName;
    data['last_name'] = this.lastName;
    data['primary_phone'] = this.primaryPhone;
    data['email'] = this.email;
    data['address'] = this.address;
    return data;
  }
}

class CompanyDetails {
  String email;
  String image;
  String header;
  String footer;

  CompanyDetails({this.email, this.image, this.footer});

  CompanyDetails.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    image = json['image'];
    header = json['header'];
    footer = json['footer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['image'] = this.image;
    data['header'] = this.header;
    data['footer'] = this.footer;
    return data;
  }
}

import 'package:flutter/services.dart';

class BookingShowResponse {
  List<BookingDetails> bookingDetails;
  List<ServiceData> serviceData;
  CustomerDetails customerDetails;
  CompanyDetails companyDetails;

  BookingShowResponse(
      {this.bookingDetails,
      this.serviceData,
      this.customerDetails,
      this.companyDetails});

  BookingShowResponse.fromJson(Map<String, dynamic> json) {
    if (json['booking_details'] != null) {
      bookingDetails = new List<BookingDetails>();
      json['booking_details'].forEach((v) {
        bookingDetails.add(new BookingDetails.fromJson(v));
      });
    }

    if (json['services_data'] != null) {
      serviceData = new List<ServiceData>();
      json['services_data'].forEach((v) {
        serviceData.add(new ServiceData.fromJson(v));
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

    if (this.serviceData != null) {
      data['services_data'] = this.serviceData.map((v) => v.toJson()).toList();
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
  dynamic bookingId;
  dynamic invoice;
  dynamic companyId;
  DateTime bookingDate;
  dynamic notes;
  dynamic totalPrice;
  dynamic paymentMethod;
  dynamic chequenumber;
  dynamic paymentDays;
  dynamic vat;

  BookingDetails({
    this.bookingId,
    this.invoice,
    this.companyId,
    this.bookingDate,
    this.notes,
    this.totalPrice,
    this.paymentMethod,
    this.chequenumber,
    this.paymentDays,
    this.vat,
  });

  BookingDetails.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    invoice = json['invoice'];
    companyId = json['company_id'];
    bookingDate = DateTime.parse(json['booking_date']);
    notes = json['notes'];
    totalPrice = json['total_price'];
    paymentMethod = json['payment_method'];
    chequenumber = json['chequenumber'];
    paymentDays = json['payment_days'];
    vat = json['vat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['invoice'] = this.invoice;
    data['company_id'] = this.companyId;
    data['booking_date'] = this.bookingDate;
    data['notes'] = this.notes;
    data['total_price'] = this.totalPrice;
    data['payment_method'] = this.paymentMethod;
    data['chequenumber'] = this.chequenumber;
    data['payment_days'] = this.paymentDays;
    data['vat'] = this.vat;
    return data;
  }
}

class ServiceData {
  dynamic bookingId;
  dynamic serviceID;
  String serviceName;
  String serviceColor;
  dynamic servicePrice;

  ServiceData({
    this.bookingId,
    this.serviceID,
    this.serviceName,
    this.serviceColor,
    this.servicePrice,
  });

  ServiceData.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    serviceID = json['serivce_id'];
    serviceName = json['service_name'];
    serviceColor = json['service_color'];
    servicePrice = json['service_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['service_id'] = this.serviceID;
    data['service_name'] = this.serviceName;
    data['service_color'] = this.serviceColor;
    data['service_price'] = this.servicePrice;

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

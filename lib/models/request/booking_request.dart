import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BookingListRequest {
  int companyId;
  int roleId;
  int userId;

  BookingListRequest({this.companyId, this.userId, this.roleId});

  BookingListRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    userId = json['user_id'];
    roleId = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId.toString();
    data['user_id'] = this.userId.toString();
    data['role_id'] = this.roleId.toString();
    return data;
  }
}

class BookingCreateRequest {
  String companyId;
  String userId;
  String customerId;
  dynamic totalPrice;
  String dueDate;
  String dueTime;
  String finishTime;
  String comment;
  List serviceId;
  String paymentDays;

  BookingCreateRequest(
      {this.companyId,
      this.userId,
      this.customerId,
      this.totalPrice,
      this.dueDate,
      this.dueTime,
      this.finishTime,
      this.comment,
      this.serviceId,
      this.paymentDays});

  BookingCreateRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    userId = json['user_id'];
    customerId = json['customer_id'];
    totalPrice = json['total_price'];
    dueDate = json['due_date'];
    dueTime = json['due_time'];
    finishTime = json['finish_time'];
    comment = json['comment'];
    serviceId = json['service_id'];
    paymentDays = json['paymentDays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId;
    data['user_id'] = this.userId;
    data['customer_id'] = this.customerId;
    data['total_price'] = this.totalPrice;
    data['due_date'] = this.dueDate;
    data['due_time'] = this.dueTime;
    data['finish_time'] = this.finishTime;
    data['comment'] = this.comment;
    data['service_id'] = this.serviceId.join(",");
    data['paymentDays'] = this.paymentDays;
    return data;
  }
}

class BookingUpdateRequest {
  dynamic bookingId;
  String companyId;
  String userId;
  String customerId;
  dynamic totalPrice;
  String dueDate;
  String dueTime;
  String finishTime;
  dynamic comment;
  List serviceId;
  String paymentDays;

  BookingUpdateRequest(
      {this.bookingId,
      this.companyId,
      this.userId,
      this.customerId,
      this.totalPrice,
      this.dueDate,
      this.dueTime,
      this.finishTime,
      this.comment,
      this.serviceId,
      this.paymentDays});

  BookingUpdateRequest.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    customerId = json['customer_id'];
    totalPrice = json['total_price'];
    dueDate = json['due_date'];
    dueTime = json['due_time'];
    finishTime = json['finish_time'];
    comment = json['comment'];
    serviceId = json['service_id'];
    paymentDays = json['paymentDays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['company_id'] = this.companyId;
    data['user_id'] = this.userId;
    data['customer_id'] = this.customerId;
    data['total_price'] = this.totalPrice;
    data['due_date'] = this.dueDate;
    data['due_time'] = this.dueTime;
    data['finish_time'] = this.finishTime;
    data['comment'] = this.comment;
    data['service_id'] = this.serviceId.join(",");
    data['paymentDays'] = this.paymentDays;
    return data;
  }
}

class BookingShowRequest {
  String companyId;
  String bookingId;

  BookingShowRequest({this.companyId, this.bookingId});

  BookingShowRequest.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    bookingId = json['booking_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId;
    data['booking_id'] = this.bookingId;
    return data;
  }
}

class BookingSendInvoice {
  String bookingId;
  String companyId;

  BookingSendInvoice({
    this.bookingId,
    this.companyId,
  });

  BookingSendInvoice.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['company_id'] = this.companyId;
    return data;
  }
}

class BookingStatusRequest {
  String bookingId;
  String companyId;
  String serviceStatus;
  String paymentMethod;
  String chequenumber;

  BookingStatusRequest(
      {this.bookingId,
      this.companyId,
      this.serviceStatus,
      this.paymentMethod,
      this.chequenumber});

  BookingStatusRequest.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    companyId = json['company_id'];
    paymentMethod = json['payment_method'];
    serviceStatus = json['service_status'];
    chequenumber = json['cheque_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['company_id'] = this.companyId;
    data['payment_method'] = this.paymentMethod;
    data['service_status'] = this.serviceStatus;
    data['cheque_number'] = this.chequenumber;
    return data;
  }
}

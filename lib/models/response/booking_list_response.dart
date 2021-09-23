import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:powerdiary/models/response/customer_list_response.dart';
import 'package:powerdiary/ui/pages/dashboard/dashboard.dart';

class BookingReadResponse {
  String address;

  String services;
  String serviceIds;
  String serviceColor;
  String customerName;
  String userName;
  dynamic totalPrice;
  DateTime dueDate;
  String startTime;
  int endTime;
  String comment;
  int serviceStatus;
  String paymentMethod;
  String chequenumber;
  int isDeleted;
  dynamic companyId;
  int bookingId;
  dynamic invoice;
  dynamic customerId;
  int paymentDays;

  int userId;
  int roleId;
  String services_color;

  CustomerReadResponse customerReadResponse;

  DateTime formatedStartTime;
  DateTime formatedEndTime;
  String formatedDetails;

  BookingReadResponse(
      {this.address,
      this.services,
      this.serviceIds,
      this.serviceColor,
      this.customerName,
      this.userName,
      this.totalPrice,
      this.dueDate,
      this.startTime,
      this.endTime,
      this.comment,
      this.serviceStatus,
      this.paymentMethod,
      this.chequenumber,
      this.isDeleted,
      this.companyId,
      this.bookingId,
      this.invoice,
      this.customerId,
      this.paymentDays,
      this.formatedStartTime,
      this.formatedEndTime,
      this.formatedDetails,
      this.customerReadResponse,
      this.roleId,
      this.userId,
      this.services_color});

  BookingReadResponse.fromJson(Map<String, dynamic> json) {
    address = json['address'] == null ? "" : json['address'];

    services = json['services'] == null ? "" : json['services'];
    serviceIds = json['services_id'] == null ? "" : json['services_id'];
    serviceColor =
        json['services_colors'] == null ? "" : json['services_colors'];

    customerName = json['customer_name'] == null ? "" : json['customer_name'];
    userName = json['user_name'] == null ? "" : json['user_name'];
    totalPrice = json['total_price'] == null ? 0 : json['total_price'];
    dueDate = DateTime.parse(json['due_date']) == null
        ? DateTime.now()
        : DateTime.parse(json['due_date']);
    startTime = json['start_time'] == null ? "" : json['start_time'];
    endTime = json['end_time'] == null ? 0 : json['end_time'];
    comment = json['comment'] == null ? "" : json['comment'];
    serviceStatus = json['service_status'] == null ? 0 : json['service_status'];
    paymentMethod =
        json['payment_method'] == null ? "" : json['payment_method'];
    chequenumber = json['chequenumber'] == null ? "" : json['chequenumber'];
    isDeleted = json['is_deleted'] == null ? 0 : json['is_deleted'];
    companyId = json['company_id'] == null ? 0 : json['company_id'];
    bookingId = json['booking_id'] == null ? 0 : json['booking_id'];
    invoice = json['invoice'] == null ? 0 : json['invoice'];
    customerId = json['customer_id'] == null ? 0 : json['customer_id'];
    paymentDays = json['paymentDays'] == null ? 0 : json['paymentDays'];
    userId = json['user_id'] == null ? 0 : json['user_id'];
    roleId = json['role_id'] == null ? 0 : json['role_id'];
    services_color =
        json['services_color'] == null ? 0 : json['services_color'];

    //Formated Time for Dashboard Calender view
    formatedStartTime = formatStartTime(dueDate, startTime);
    formatedEndTime = formatEndTime(dueDate, startTime, endTime);
    formatedDetails = customerName + " (" + services + ")";

    customerReadResponse = json['customer_detail'] != null
        ? new CustomerReadResponse.fromBookingJson(json['customer_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['address'] = this.address;

    data['services'] = this.services;
    data['services_id'] = this.serviceIds;
    data['services_colors'] = this.serviceColor;
    data['customer_name'] = this.customerName;
    data['user_name'] = this.userName;
    data['total_price'] = this.totalPrice;
    data['due_date'] = this.dueDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['comment'] = this.comment;
    data['service_status'] = this.serviceStatus;
    data['payment_method'] = this.paymentMethod;
    data['chequenumber'] = this.chequenumber;
    data['is_deleted'] = this.isDeleted;
    data['company_id'] = this.companyId;
    data['booking_id'] = this.bookingId;
    data['invoice'] = this.invoice;
    data['customer_id'] = this.customerId;
    data['paymentdays'] = this.paymentDays;
    data['user_id'] = this.userId;
    data['role_id'] = this.roleId;
    data['services_color'] = this.services_color;
    if (this.customerReadResponse != null) {
      data['customer_detail'] = this.customerReadResponse.toJsonBooking();
    }
    return data;
  }

  DateTime formatStartTime(DateTime dateTime, String st) {
    String stnew =
        st.replaceAll(" ", "").replaceAll("PM", "").replaceAll("AM", "");
    int hours = int.parse(stnew.split(":")[0]);
    int minutes = int.parse(stnew.split(":")[1]);
    if (hours != 12) {
      TimeOfDay time = TimeOfDay(
          hour: (st.contains("PM") ? hours + 12 : hours), minute: minutes);
      return DateTime(
          dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute);
    } else if (hours == 12) {
      TimeOfDay time = TimeOfDay(
          hour: (st.contains("PM") ? hours : hours + 12), minute: minutes);
      return DateTime(dateTime.year, dateTime.month, dateTime.day - 1,
          time.hour, time.minute);
    }
  }

  DateTime formatEndTime(DateTime dateTime, String st, int endTime) {
    String stnew =
        st.replaceAll(" ", "").replaceAll("PM", "").replaceAll("AM", "");
    int hours = int.parse(stnew.split(":")[0]);
    int minutes = int.parse(stnew.split(":")[1]);
    if (hours != 12) {
      TimeOfDay time = TimeOfDay(
          hour: (st.contains("PM") ? hours + 12 : hours), minute: minutes);
      DateTime endDate = DateTime(
          dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute);
      return endDate.add(Duration(seconds: endTime * 60));
    } else if (hours == 12) {
      TimeOfDay time = TimeOfDay(
          hour: (st.contains("PM") ? hours : hours + 12), minute: minutes);
      DateTime endDate = DateTime(dateTime.year, dateTime.month,
          dateTime.day - 1, time.hour, time.minute);
      return endDate.add(Duration(seconds: endTime * 60));
    }
  }
}

class BookingListResponse {
  List<BookingReadResponse> values = [];

  BookingListResponse() {
    values = [];
  }

  BookingListResponse.fromJson(var jsonObject) {
    for (var area in jsonObject) {
      BookingReadResponse model = BookingReadResponse.fromJson(area);
      this.values.add(model);
    }
  }
}

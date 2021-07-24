import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:powerdiary/ui/pages/Roles/create_role.dart';
import 'package:powerdiary/ui/pages/Roles/roles_listing.dart';
import 'package:powerdiary/ui/pages/User/create_user.dart';
import 'package:powerdiary/ui/pages/User/user_listing.dart';
import 'package:powerdiary/ui/pages/bookings/booking_listing.dart';
import 'package:powerdiary/ui/pages/bookings/create_booking.dart';
import 'package:powerdiary/ui/pages/category/category_listing.dart';
import 'package:powerdiary/ui/pages/category/create_category.dart';
import 'package:powerdiary/ui/pages/customer/create_customer.dart';
import 'package:powerdiary/ui/pages/customer/customer_listing.dart';
import 'package:powerdiary/ui/pages/email_tools/mailing_service.dart';
import 'package:powerdiary/ui/pages/expense_types/create_type.dart';
import 'package:powerdiary/ui/pages/expense_types/expense_types.dart';
import 'package:powerdiary/ui/pages/expenses/add_expense.dart';
import 'package:powerdiary/ui/pages/expenses/expenses_list.dart';
import 'package:powerdiary/ui/pages/login.dart';
import 'package:powerdiary/ui/pages/message.dart';
import 'package:powerdiary/ui/pages/navigation_drawer.dart';
import 'package:powerdiary/ui/pages/qoute/qutations.dart';
import 'package:powerdiary/ui/pages/qoute/send_qoute.dart';
import 'package:powerdiary/ui/pages/service/create_service.dart';
import 'package:powerdiary/ui/pages/service/service_listing.dart';
import 'package:powerdiary/ui/pages/splash.dart';

class RouteManager {
  static const String route_splash = "/splash";
  static const String route_login = "/login";
  static const String route_dashboard = "/dashboard";

  //Category Routes
  static const String route_category_list = "/category_listing";
  static const String route_category_create = "/category_create";
  static const String route_category_update = "/category_update";

  //Services Route
  static const String route_service_list = "/service_listing";
  static const String route_service_create = "/service_create";
  static const String route_service_update = "/service_update";

  //Services Route
  static const String route_customer_list = "/customer_listing";
  static const String route_customer_create = "/customer_create";
  static const String route_customer_update = "/customer_update";

  //Booking Route
  static const String route_booking_list = "/booking_listing";
  static const String route_booking_create = "/booking_create";
  static const String route_booking_update = "/booking_update";

  //Qoutation Route
  static const String route_qoute_list = "/qoute_listing";
  static const String route_qoute_create = "/qoute_create";
  static const String route_qoute_update = "/qouteg_update";

  //Email Tools
  static const String route_mailingservice = "/mailing_service";

  //Users
  static const String route_user_list = "/user_listing";
  static const String route_user_update = "/user_update";
  static const String route_user_create = "/user_create";

  //Roles
  static const String route_role_list = "/role_listing";
  static const String route_role_create = "/role_create";
  static const String route_role_update = "/role_update";

  //Settings
  static const String route_message = "/site_messages";

  //Expense Types
  static const String route_expense_types = "/expense_types";
  static const String route_expense_types_create = "/create_types";

  //expenses
  static const String route_expenses_sub = "/expense_sub";
  static const String route_expenses = "/add_expense";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;
    switch (settings.name) {
      case route_splash:
        return MaterialPageRoute(builder: (_) => Splash());
      case route_login:
        return MaterialPageRoute(builder: (_) => Login());
      case route_dashboard:
        return MaterialPageRoute(builder: (_) => NavigationDrawer());
      case route_category_list:
        return MaterialPageRoute(builder: (_) => CategoryListing());
      case route_category_create:
        return MaterialPageRoute(builder: (_) => CreateCategory());
      case route_service_list:
        return MaterialPageRoute(builder: (_) => ServicesListing());
      case route_service_create:
        return MaterialPageRoute(builder: (_) => CreateService());
      case route_customer_list:
        return MaterialPageRoute(builder: (_) => CustomersListing());
      case route_customer_create:
        return MaterialPageRoute(builder: (_) => CreateCustomer());
      case route_booking_list:
        return MaterialPageRoute(builder: (_) => BookingListing());
      case route_booking_create:
        return MaterialPageRoute(builder: (_) => CreateBooking());
      case route_qoute_list:
        return MaterialPageRoute(builder: (_) => QutationsListing());
      case route_qoute_create:
        return MaterialPageRoute(builder: (_) => SendQuote());
      case route_mailingservice:
        return MaterialPageRoute(builder: (_) => MailingService());
      case route_user_list:
        return MaterialPageRoute(builder: (_) => UserListing());
      case route_user_create:
        return MaterialPageRoute(builder: (_) => CreateUser());
      case route_role_list:
        return MaterialPageRoute(builder: (_) => RolesListing());
      case route_role_create:
        return MaterialPageRoute(builder: (_) => CreateRole());
      case route_message:
        return MaterialPageRoute(builder: (_) => Message());
      case route_expense_types:
        return MaterialPageRoute(builder: (_) => ExpenseType());
      case route_expense_types_create:
        return MaterialPageRoute(builder: (_) => Type());
      case route_expenses_sub:
        return MaterialPageRoute(builder: (_) => ExpensesList());
      case route_expenses:
        return MaterialPageRoute(builder: (_) => AddExpenses());

      default:
        return null;
    }
  }
}

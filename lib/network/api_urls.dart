class ApplicationURLs {
  static const BASE_URL = "https://app.diarymaster.co.uk/api/";

  static const POSTCODEURL = "https://api.ideal-postcodes.co.uk/v1/postcodes/";

  //Authentication
  static const API_LOGIN = BASE_URL + "login";
  static const API_PUSH_TOKEN = BASE_URL + "device-token";

  //Category
  static const API_CATEGORY_LIST = BASE_URL + "categories";
  static const API_CATEGORY_CREATE = BASE_URL + "categories/create";
  static const API_CATEGORY_UPDATE = BASE_URL + "categories/update";
  static const API_CATEGORY_DELETE = BASE_URL + "categories/delete";
  static const API_CATEGORY_SHOW = BASE_URL + "categories/show";
  static const API_CATEGORY_STATUS = BASE_URL + "category-status";

  //Customer
  static const API_CUSTOMER_LIST = BASE_URL + "customers";
  static const API_CUSTOMER_UPDATE = BASE_URL + "customers/update";
  static const API_CUSTOMER_CREATE = BASE_URL + "customers/create";
  static const API_CUSTOMER_DELETE = BASE_URL + "customers/delete";

  //PostCodeAddress
  static const API_POST_CODE_ADDRESS_LIST = POSTCODEURL;

  //Service
  static const API_SERVICE_LIST = BASE_URL + "services";
  static const API_SERVICE_UPDATE = BASE_URL + "services/update";
  static const API_SERVICE_CREATE = BASE_URL + "services/create";
  static const API_SERVICE_DELETE = BASE_URL + "services/delete";
  static const API_SERVICE_STATUS = BASE_URL + "service-status";

  //Bookings
  static const API_BOOKING_LIST = BASE_URL + "service-bookings";
  static const API_BOOKING_CREATE = BASE_URL + "service-bookings/create";
  static const API_BOOKING_UPDATE = BASE_URL + "service-bookings/update";
  static const API_BOOKING_SHOW = BASE_URL + "service-bookings/show";
  static const API_BOOKING_DELETE = BASE_URL + "service-bookings/delete";
  static const API_BOOKING_STATUS = BASE_URL + "booking-status";
  static const API_BOOKING_SEND_INVOICE = BASE_URL + "send-invoice";

  //User
  static const API_USER_LIST = BASE_URL + "users";
  static const API_USER_CREATE = BASE_URL + "users/create";
  static const API_USER_UPDATE = BASE_URL + "users/update";
  static const API_USER_DELETE = BASE_URL + "users/delete";
  static const API_USER_SHOW = BASE_URL + "users/show";
  static const API_USER_STATUS = BASE_URL + "user-status";

  //Roles

  static const API_ROLE_LIST = BASE_URL + "roles";
  static const API_ROLE_CREATE = BASE_URL + "roles/store";
  static const API_ROLE_UPDATE = BASE_URL + "roles/update";
  static const API_ROLE_DELETE = BASE_URL + "roles/delete";
  static const API_ROLE_PERMISSIONS = BASE_URL + "roles/permissions-name";

  //Expense Types
  static const API_EXPENSE_TYPE_LIST = BASE_URL + "expense-types";
  static const API_EXPENSE_TYPE_UPDATE = BASE_URL + "expense-types/update";
  static const API_EXPENSE_TYPE_DELETE = BASE_URL + "expense-types/delete";
  static const API_EXPENSE_TYPE_CREATE = BASE_URL + "expense-types/create";

  //Qutations
  static const API_QUTATIONS_LIST = BASE_URL + "quotations";
  static const API_QUTATION_CREATE = BASE_URL + "quotations/create";

  //Expense
  static const API_EXPENSE_LIST = BASE_URL + "expenses";
  static const API_EXPENSE_CREATE = BASE_URL + "expenses/create";
  static const API_EXPENSE_UPDATE = BASE_URL + "expenses/update";
  static const API_EXPENSE_DELETE = BASE_URL + "expenses/delete";

  //sms alert
  static const API_SEND_SMS = BASE_URL + "receiving-notification";
}

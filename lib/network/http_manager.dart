import 'package:powerdiary/models/request/QutationListRequest.dart';
import 'package:powerdiary/models/request/booking_request.dart';
import 'package:powerdiary/models/request/booking_weekly_request.dart';
import 'package:powerdiary/models/request/category_request.dart';
import 'package:powerdiary/models/request/customer_request.dart';
import 'package:powerdiary/models/request/expense_request.dart';
import 'package:powerdiary/models/request/expense_types_request.dart';
import 'package:powerdiary/models/request/login_request.dart';
import 'package:powerdiary/models/request/permission_request.dart';
import 'package:powerdiary/models/request/post_code_address_request.dart';
import 'package:powerdiary/models/request/role_request.dart';
import 'package:powerdiary/models/request/service_request.dart';
import 'package:powerdiary/models/request/tax_info_request.dart';
import 'package:powerdiary/models/request/user_request.dart';
import 'package:powerdiary/models/response/booking_list_response.dart';
import 'package:powerdiary/models/response/booking_list_weekly_response.dart';
import 'package:powerdiary/models/response/booking_show_reponse.dart';
import 'package:powerdiary/models/response/category_list_response.dart';
import 'package:powerdiary/models/response/customer_list_response.dart';
import 'package:powerdiary/models/response/expense_list_response.dart';
import 'package:powerdiary/models/response/expense_type_list_response.dart';
import 'package:powerdiary/models/response/general_response_model.dart';
import 'package:powerdiary/models/response/permission_list_response.dart';
import 'package:powerdiary/models/response/post_code_address_response.dart';
import 'package:powerdiary/models/response/post_code_response_model.dart';
import 'package:powerdiary/models/response/qutations_list_response.dart';
import 'package:powerdiary/models/response/role_permission_response.dart';
import 'package:powerdiary/models/response/roles_list_response.dart';
import 'package:powerdiary/models/response/service_list_response.dart';
import 'package:powerdiary/models/response/session_user_model.dart';
import 'package:powerdiary/models/response/tax_info_response.dart';
import 'package:powerdiary/models/response/user_list_response.dart';
import 'package:powerdiary/network/response_handler.dart';
import 'package:powerdiary/models/response/post_code_address_response.dart';

import 'api_urls.dart';

class HTTPManager {
  static bool internetCheck;
  ResponseHandler _handler = ResponseHandler();

  Future<SessionUserModel> loginUser(LoginRequest loginRequest) async {
    final url = ApplicationURLs.API_LOGIN;
    final GeneralResponseModel response =
        await _handler.post(url, loginRequest.toJson(), false);
    SessionUserModel sessionUserModel =
        SessionUserModel.fromJson(response.data);
    return sessionUserModel;
  }

  Future<GeneralResponseModel> updateFcmToken(
      UserTokenRequest userTokenRequest) async {
    final url = ApplicationURLs.API_PUSH_TOKEN;
    final GeneralResponseModel response =
        await _handler.post(url, userTokenRequest.toJson(), false);
    return response;
  }

  Future<CategoryListModel> getCategoryListing(
      CategoryListRequest categoryListRequest) async {
    final url = ApplicationURLs.API_CATEGORY_LIST;
    final GeneralResponseModel response =
        await _handler.post(url, categoryListRequest.toJson(), false);
    CategoryListModel categoryListModel =
        CategoryListModel.fromJson(response.data);
    return categoryListModel;
  }

  Future<PostCodeAddressListModel> getPostCodeAddressListing(
      PostCodeAddressListRequest postCodeAddressListRequest) async {
    final url =
        "https://api.ideal-postcodes.co.uk/v1/postcodes/${postCodeAddressListRequest.postcode}?api_key=${postCodeAddressListRequest.apiKey}";
    print(url);
    //ApplicationURLs.API_POST_CODE_ADDRESS_LIST;
    final PostCodeResponseModel response = await _handler.getPost(url, false);
    print(response);
    PostCodeAddressListModel postCodeAddressListModel =
        PostCodeAddressListModel.fromJson(response.result);
    print(postCodeAddressListModel);
    return postCodeAddressListModel;
  }

  Future<GeneralResponseModel> createCategory(
      CategoryCreateRequest categoryCreateRequest) async {
    final url = ApplicationURLs.API_CATEGORY_CREATE;
    final GeneralResponseModel response =
        await _handler.post(url, categoryCreateRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> updateCategory(
      CategoryUpdateRequest categoryUpdateRequest) async {
    final url = ApplicationURLs.API_CATEGORY_UPDATE;
    final GeneralResponseModel response =
        await _handler.post(url, categoryUpdateRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> deleteCategory(
      CategoryDeleteRequest categoryDeleteRequest) async {
    final url = ApplicationURLs.API_CATEGORY_DELETE;
    final GeneralResponseModel response =
        await _handler.post(url, categoryDeleteRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> statusCategory(
      CategoryStatusRequest categoryStatusRequest) async {
    final url = ApplicationURLs.API_CATEGORY_STATUS;
    final GeneralResponseModel response =
        await _handler.post(url, categoryStatusRequest.toJson(), false);
    return response;
  }

  Future<CustomerListModel> getCustomerListing(
      CustomerListRequest customerListRequest) async {
    final url = ApplicationURLs.API_CUSTOMER_LIST;
    final GeneralResponseModel response =
        await _handler.post(url, customerListRequest.toJson(), false);
    CustomerListModel customerListModel =
        CustomerListModel.fromJson(response.data);
    return customerListModel;
  }

  Future<GeneralResponseModel> createCustomer(
      CustomerCreateRequest customerCreateRequest) async {
    final url = ApplicationURLs.API_CUSTOMER_CREATE;
    final GeneralResponseModel response =
        await _handler.post(url, customerCreateRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> updateCustomer(
      CustomerUpdateRequest customerUpdateRequest) async {
    final url = ApplicationURLs.API_CUSTOMER_UPDATE;
    final GeneralResponseModel response =
        await _handler.post(url, customerUpdateRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> deleteCustomer(
      CustomerDeleteRequest customerDeleteRequest) async {
    final url = ApplicationURLs.API_CUSTOMER_DELETE;
    final GeneralResponseModel response =
        await _handler.post(url, customerDeleteRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> statusCustomer(
      CustomerStatusRequest customerStatusRequest) async {
    final url = ApplicationURLs.API_CUSTOMER_STATUS;
    final GeneralResponseModel response =
        await _handler.post(url, customerStatusRequest.toJson(), false);
    return response;
  }

  Future<ServiceListModel> getServiceListing(
      ServiceListRequest serviceListRequest, List selected) async {
    final url = ApplicationURLs.API_SERVICE_LIST;
    final GeneralResponseModel response =
        await _handler.post(url, serviceListRequest.toJson(), false);
    ServiceListModel serviceListModel =
        ServiceListModel.fromJson(response.data, selected);
    return serviceListModel;
  }

  Future<GeneralResponseModel> createService(
      ServiceCreateRequest serviceCreateRequest) async {
    final url = ApplicationURLs.API_SERVICE_CREATE;
    final GeneralResponseModel response =
        await _handler.post(url, serviceCreateRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> updateService(
      ServiceUpdateRequest serviceUpdateRequest) async {
    final url = ApplicationURLs.API_SERVICE_UPDATE;
    final GeneralResponseModel response =
        await _handler.post(url, serviceUpdateRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> deleteService(
      ServiceDeleteRequest serviceDeleteRequest) async {
    final url = ApplicationURLs.API_SERVICE_DELETE;
    final GeneralResponseModel response =
        await _handler.post(url, serviceDeleteRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> statusService(
      ServiceStatusRequest serviceStatusRequest) async {
    final url = ApplicationURLs.API_SERVICE_STATUS;
    final GeneralResponseModel response =
        await _handler.post(url, serviceStatusRequest.toJson(), false);
    return response;
  }

  Future<BookingListResponse> getBookingListing(
      BookingListRequest bookingListRequest) async {
    final url = ApplicationURLs.API_BOOKING_LIST;
    final GeneralResponseModel response =
        await _handler.post(url, bookingListRequest.toJson(), false);
    BookingListResponse bookingListResponse =
        BookingListResponse.fromJson(response.data);
    return bookingListResponse;
  }

  Future<BookingWeeklyListResponse> getBookingWeeklyListing(
      BookingWeeklyListRequest bookingWeeklyListRequest) async {
    final url = ApplicationURLs.API_BOOKING_LIST;
    final GeneralResponseModel response =
        await _handler.post(url, bookingWeeklyListRequest.toJson(), false);
    BookingWeeklyListResponse bookingWeeklyListResponse =
        BookingWeeklyListResponse.fromJson(response.data);
    return bookingWeeklyListResponse;
  }

  Future<GeneralResponseModel> createBooking(
      BookingCreateRequest bookingCreateRequest) async {
    final url = ApplicationURLs.API_BOOKING_CREATE;
    final GeneralResponseModel response =
        await _handler.post(url, bookingCreateRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> updateBooking(
      BookingUpdateRequest bookingUpdateRequest) async {
    final url = ApplicationURLs.API_BOOKING_UPDATE;
    final GeneralResponseModel response =
        await _handler.post(url, bookingUpdateRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> updateWeeklyBooking(
      BookingWeeklyUpdateRequest bookingUpdateRequest) async {
    final url = ApplicationURLs.API_BOOKING_UPDATE;
    final GeneralResponseModel response =
        await _handler.post(url, bookingUpdateRequest.toJson(), false);
    return response;
  }

  Future<BookingShowResponse> showBookingInvoice(
      BookingShowRequest bookingShowRequest) async {
    final url = ApplicationURLs.API_BOOKING_SHOW;
    final GeneralResponseModel response =
        await _handler.post(url, bookingShowRequest.toJson(), false);
    BookingShowResponse bookingShowResponse =
        BookingShowResponse.fromJson(response.data);
    return bookingShowResponse;
  }

  Future<GeneralResponseModel> deleteBooking(
      BookingShowRequest bookingDeleteRequest) async {
    final url = ApplicationURLs.API_BOOKING_DELETE;
    final GeneralResponseModel response =
        await _handler.post(url, bookingDeleteRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> statusBooking(
      BookingStatusRequest bookingStatusRequest) async {
    final url = ApplicationURLs.API_BOOKING_STATUS;
    final GeneralResponseModel response =
        await _handler.post(url, bookingStatusRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> statusWeeklyBooking(
      BookingWeeklyStatusRequest bookingStatusRequest) async {
    final url = ApplicationURLs.API_BOOKING_STATUS;
    final GeneralResponseModel response =
        await _handler.post(url, bookingStatusRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> sendInvoiceBooking(
      BookingSendInvoice bookingSendInvoice) async {
    final url = ApplicationURLs.API_BOOKING_SEND_INVOICE;
    final GeneralResponseModel response =
        await _handler.post(url, bookingSendInvoice.toJson(), false);
    return response;
  }

  Future<TaxListModel> getTaxListing(TaxListRequest taxListRequest) async {
    final url = ApplicationURLs.API_TAX_INFO;
    final GeneralResponseModel response =
        await _handler.post(url, taxListRequest.toJson(), false);
    TaxListModel taxListModel = TaxListModel.fromJson(response.data);
    return taxListModel;
  }

  Future<UserListModel> getUserListing(UserListRequest userListRequest) async {
    final url = ApplicationURLs.API_USER_LIST;
    final GeneralResponseModel response =
        await _handler.post(url, userListRequest.toJson(), false);
    UserListModel userListModel = UserListModel.fromJson(response.data);
    return userListModel;
  }

  Future<GeneralResponseModel> createUser(
      UserCreateRequest userCreateRequest) async {
    final url = ApplicationURLs.API_USER_CREATE;
    final GeneralResponseModel response = await _handler.postImage(url,
        userCreateRequest.toJson(), userCreateRequest.file, false, "Created");
    return response;
  }

  Future<GeneralResponseModel> updateUser(
      UserUpdateRequest userUpdateRequest) async {
    final url = ApplicationURLs.API_USER_UPDATE;
    final GeneralResponseModel response = await _handler.postImage(url,
        userUpdateRequest.toJson(), userUpdateRequest.file, false, "Updated");
    return response;
  }

  Future<GeneralResponseModel> deleteUser(
      UserDeleteRequest userDeleteRequest) async {
    final url = ApplicationURLs.API_USER_DELETE;
    final GeneralResponseModel response =
        await _handler.post(url, userDeleteRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> statusUser(
      UserStatusRequest userStatusRequest) async {
    final url = ApplicationURLs.API_USER_STATUS;
    final GeneralResponseModel response =
        await _handler.post(url, userStatusRequest.toJson(), false);
    return response;
  }

  Future<RoleListModel> getRolesListing(RoleListRequest roleListRequest) async {
    final url = ApplicationURLs.API_ROLE_LIST;
    final GeneralResponseModel response =
        await _handler.post(url, roleListRequest.toJson(), false);
    RoleListModel roleListModel = RoleListModel.fromJson(response.data);
    return roleListModel;
  }

  Future<RolePermissionList> getRolesPermissions(
      Map<String, List<String>> accessIdMap) async {
    final url = ApplicationURLs.API_ROLE_PERMISSIONS;
    final GeneralResponseModel response = await _handler.post(url, null, false);
    RolePermissionList roleListModel =
        RolePermissionList.fromJson(accessIdMap, response.data);
    return roleListModel;
  }

  Future<PermissionShowResponse> getPermissionList(
      PermissionListRequest permissionListRequest) async {
    final url = ApplicationURLs.API_ROLE_PERMISSIONS_LIST;
    final GeneralResponseModel response =
        await _handler.post(url, permissionListRequest.toJson(), false);
    PermissionShowResponse permissionShowResponse =
        PermissionShowResponse.fromJson(response.data);
    return permissionShowResponse;
  }

  Future<GeneralResponseModel> createRole(
      RoleCreateRequest roleCreateRequest) async {
    final url = ApplicationURLs.API_ROLE_CREATE;
    final GeneralResponseModel response =
        await _handler.post(url, roleCreateRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> updateRole(
      RoleUpdateRequest roleUpdateRequest) async {
    final url = ApplicationURLs.API_ROLE_UPDATE;
    final GeneralResponseModel response =
        await _handler.post(url, roleUpdateRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> deleteRole(
      RoleDeleteRequest rolesDeleteRequest) async {
    final url = ApplicationURLs.API_ROLE_DELETE;
    final GeneralResponseModel response =
        await _handler.post(url, rolesDeleteRequest.toJson(), false);
    return response;
  }

  Future<ExpenseTypeListModel> getExpenseTypeListing(
      ExpenseTypeListRequest expenseTypeListRequest) async {
    final url = ApplicationURLs.API_EXPENSE_TYPE_LIST;
    final GeneralResponseModel response =
        await _handler.post(url, expenseTypeListRequest.toJson(), false);
    ExpenseTypeListModel expenseTypeListModel =
        ExpenseTypeListModel.fromJson(response.data);
    return expenseTypeListModel;
  }

  Future<ExpenseListResponse> getExpenseListing(
      ExpenseListRequest expenseListRequest) async {
    final url = ApplicationURLs.API_EXPENSE_LIST;
    final GeneralResponseModel response =
        await _handler.post(url, expenseListRequest.toJson(), false);
    ExpenseListResponse expenseListResponse =
        ExpenseListResponse.fromJson(response.data);
    return expenseListResponse;
  }

  Future<GeneralResponseModel> createExpense(
      ExpenseCreateRequest expenseCreateRequest) async {
    final url = ApplicationURLs.API_EXPENSE_CREATE;
    final GeneralResponseModel response =
        await _handler.post(url, expenseCreateRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> updateExpense(
      ExpenseUpdateRequest expenseUpdateRequest) async {
    final url = ApplicationURLs.API_EXPENSE_UPDATE;
    final GeneralResponseModel response =
        await _handler.post(url, expenseUpdateRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> deleteExpense(
      ExpenseDeleteRequest expenseDeleteRequest) async {
    final url = ApplicationURLs.API_EXPENSE_DELETE;
    final GeneralResponseModel response =
        await _handler.post(url, expenseDeleteRequest.toJson(), false);
    return response;
  }

  Future<QutationsListModel> getQutationsListing(
      QutationListRequest qutationsListRequest) async {
    final url = ApplicationURLs.API_QUTATIONS_LIST;
    final GeneralResponseModel response =
        await _handler.post(url, qutationsListRequest.toJson(), false);
    QutationsListModel qutationsListModel =
        QutationsListModel.fromJson(response.data);
    return qutationsListModel;
  }

  Future<GeneralResponseModel> createQuote(
      QutationCreateRequest qutationCreateRequest) async {
    final url = ApplicationURLs.API_QUTATION_CREATE;
    final GeneralResponseModel response =
        await _handler.post(url, qutationCreateRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> updateExpenseType(
      ExpenseTypeUpdateRequest expenseTypeUpdateRequest) async {
    final url = ApplicationURLs.API_EXPENSE_TYPE_UPDATE;
    final GeneralResponseModel response =
        await _handler.post(url, expenseTypeUpdateRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> deleteExpenseType(
      ExpenseTypeDeleteRequest expenseTypeDeleteRequest) async {
    final url = ApplicationURLs.API_EXPENSE_TYPE_DELETE;
    final GeneralResponseModel response =
        await _handler.post(url, expenseTypeDeleteRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> createExpenseType(
      ExpenseTypeCreateRequest expenseTypeCreateRequest) async {
    final url = ApplicationURLs.API_EXPENSE_TYPE_CREATE;
    final GeneralResponseModel response =
        await _handler.post(url, expenseTypeCreateRequest.toJson(), false);
    return response;
  }

  Future<GeneralResponseModel> sendSms(
      int companyId, int customerId, String time) async {
    final url = ApplicationURLs.API_SEND_SMS +
        "?company_id=$companyId&customer_id=$customerId&time=$time";
    final GeneralResponseModel response = await _handler.post(url, null, false);
    return response;
  }
}

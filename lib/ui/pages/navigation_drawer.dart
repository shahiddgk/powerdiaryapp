import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:powerdiary/models/request/permission_request.dart';
import 'package:powerdiary/models/response/permission_list_response.dart';
import 'package:powerdiary/network/http_manager.dart';
import 'package:powerdiary/ui/pages/dashboard/dashboard.dart';
import 'package:powerdiary/ui/pages/theme/app_theme.dart';
import 'package:powerdiary/ui/widgets/widget_timepicker_field.dart';
import 'package:powerdiary/utils/route_manager.dart';
import 'package:powerdiary/utils/utils.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  bool _isLoading = true;
  final createcategory = GlobalKey<NavigatorState>();
  PermissionShowResponse permissionShowResponse;
  int _counter = 7;
  Timer _timer;

  void _startTimer() {
    _counter = 7;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  _getPermissionList() {
    HTTPManager()
        .getPermissionList(PermissionListRequest(
            companyId: globalSessionUser.companyId,
            roleId: globalSessionUser.roleId))
        .then((value) {
      setState(() {
        _isLoading = false;
        permissionShowResponse = value;
      });
    }).catchError((e) {
      print(e);
      showAlert(context, e.toString(), true, () {
        setState(() {
          _isLoading = false;
        });
      }, () {
        _getPermissionList();
      });
    });
  }

  @override
  void initState() {
    _startTimer();
    _getPermissionList();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        drawer: _counter > 0
            ? Center(child: CircularProgressIndicator())
            : MultiLevelDrawer(
                backgroundColor: AppTheme.colours.white,
                rippleColor: AppTheme.colours.white,
                subMenuBackgroundColor: Colors.grey.shade100,
                header: Container(
                  height: size.height * 0.25,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 35.0,
                          backgroundImage:
                              NetworkImage('${globalSessionUser.image}'),
                        ),
                        Text("${globalSessionUser.name}"),
                        Text("${globalSessionUser.email}"),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                children: [
                  MLMenuItem(
                      leading: Row(
                        children: [
                          SizedBox(width: 2),
                          Icon(Icons.home_rounded),
                        ],
                      ),
                      content: Text("  Dashboard"),
                      onClick: () {
                        Navigator.pushNamed(
                            context, RouteManager.route_dashboard);
                      }),
                  permissionShowResponse.category[0].read == 1 ||
                          permissionShowResponse.category[0].create == 1 ||
                          permissionShowResponse.category[0].update == 1 ||
                          permissionShowResponse.category[0].delete == 1
                      ? MLMenuItem(
                          leading: Row(
                            children: [
                              SizedBox(width: 2),
                              Icon(Icons.business_center)
                            ],
                          ),
                          trailing: Icon(Icons.arrow_right),
                          content: Text('  Category'),
                          onClick: () {},
                          subMenuItems: [
                              permissionShowResponse.category[0].create == 1
                                  ? MLSubmenu(
                                      onClick: () {
                                        Navigator.pushNamed(context,
                                            RouteManager.route_category_list);
                                      },
                                      submenuContent: Text('Category Listing'))
                                  : MLSubmenu(
                                      onClick: () {
                                        // Navigator.pushNamed(
                                        //     context, RouteManager.route_category_list);
                                      },
                                      submenuContent: Text(
                                        'Category Listing',
                                        style: TextStyle(color: Colors.grey),
                                      )),
                              permissionShowResponse.category[0].read == 1
                                  ? MLSubmenu(
                                      onClick: () {
                                        Navigator.pushNamed(context,
                                            RouteManager.route_category_create);
                                      },
                                      submenuContent: Text('Create Category'))
                                  : MLSubmenu(
                                      // onClick: () {
                                      //   Navigator.pushNamed(
                                      //       context, RouteManager.route_category_create);
                                      // },
                                      submenuContent: Text(
                                      'Create Category',
                                      style: TextStyle(color: Colors.grey),
                                    ))
                            ])
                      : MLMenuItem(
                          leading: Row(
                            children: [
                              SizedBox(width: 2),
                              Icon(Icons.business_center)
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_right,
                            color: Colors.grey,
                          ),
                          content: Text(
                            '  Category',
                            style: TextStyle(color: Colors.grey),
                          ),
                          onClick: () {},
                          // subMenuItems: [
                          //   MLSubmenu(
                          //       onClick: () {
                          //         Navigator.pushNamed(
                          //             context, RouteManager.route_category_list);
                          //       },
                          //       submenuContent: Text('Category Listing')),
                          //   MLSubmenu(
                          //       onClick: () {
                          //         Navigator.pushNamed(
                          //             context, RouteManager.route_category_create);
                          //       },
                          //       submenuContent: Text('Create Category')),
                          // ]
                        ),
                  permissionShowResponse.service[0].read == 1 ||
                          permissionShowResponse.service[0].create == 1 ||
                          permissionShowResponse.service[0].update == 1 ||
                          permissionShowResponse.service[0].delete == 1
                      ? MLMenuItem(
                          leading: Row(
                            children: [
                              SizedBox(width: 2),
                              Icon(Icons.insert_chart)
                            ],
                          ),
                          trailing: Icon(Icons.arrow_right),
                          content: Text('  Services'),
                          onClick: () {},
                          subMenuItems: [
                              permissionShowResponse.service[0].create == 1
                                  ? MLSubmenu(
                                      onClick: () {
                                        Navigator.pushNamed(context,
                                            RouteManager.route_service_list);
                                      },
                                      submenuContent: Text('Service Listing'))
                                  : MLSubmenu(
                                      // onClick: () {
                                      //   Navigator.pushNamed(
                                      //       context, RouteManager.route_service_list);
                                      // },
                                      submenuContent: Text(
                                      'Service Listing',
                                      style: TextStyle(color: Colors.grey),
                                    )),
                              permissionShowResponse.service[0].read == 1
                                  ? MLSubmenu(
                                      onClick: () {
                                        Navigator.pushNamed(context,
                                            RouteManager.route_service_create);
                                      },
                                      submenuContent: Text('Create Service'))
                                  : MLSubmenu(
                                      // onClick: () {
                                      //   Navigator.pushNamed(
                                      //       context, RouteManager.route_service_create);
                                      // },
                                      submenuContent: Text(
                                      'Create Service',
                                      style: TextStyle(color: Colors.grey),
                                    )),
                            ])
                      : MLMenuItem(
                          leading: Row(
                            children: [
                              SizedBox(width: 2),
                              Icon(Icons.insert_chart, color: Colors.grey)
                            ],
                          ),
                          trailing: Icon(Icons.arrow_right, color: Colors.grey),
                          content: Text('  Services',
                              style: TextStyle(color: Colors.grey)),
                          onClick: () {},
                          // subMenuItems: [
                          //   MLSubmenu(
                          //       onClick: () {
                          //         Navigator.pushNamed(
                          //             context, RouteManager.route_service_list);
                          //       },
                          //       submenuContent: Text('Service Listing')),
                          //   MLSubmenu(
                          //       onClick: () {
                          //         Navigator.pushNamed(
                          //             context, RouteManager.route_service_create);
                          //       },
                          //       submenuContent: Text('Create Service')),
                          // ]
                        ),

                  permissionShowResponse.customer[0].read == 1 ||
                          permissionShowResponse.customer[0].create == 1 ||
                          permissionShowResponse.customer[0].update == 1 ||
                          permissionShowResponse.customer[0].delete == 1
                      ? MLMenuItem(
                          leading: Row(
                            children: [
                              SizedBox(width: 2),
                              Icon(Icons.people_alt_rounded)
                            ],
                          ),
                          trailing: Icon(Icons.arrow_right),
                          content: Text('  Customers'),
                          onClick: () {},
                          subMenuItems: [
                              permissionShowResponse.customer[0].create == 1
                                  ? MLSubmenu(
                                      onClick: () {
                                        Navigator.pushNamed(context,
                                            RouteManager.route_customer_list);
                                      },
                                      submenuContent: Text('Customer Listing'))
                                  : MLSubmenu(
                                      // onClick: () {
                                      //   Navigator.pushNamed(
                                      //       context, RouteManager.route_customer_list);
                                      // },
                                      submenuContent: Text(
                                      'Customer Listing',
                                      style: TextStyle(color: Colors.grey),
                                    )),
                              permissionShowResponse.customer[0].read == 1
                                  ? MLSubmenu(
                                      onClick: () {
                                        Navigator.pushNamed(context,
                                            RouteManager.route_customer_create);
                                      },
                                      submenuContent: Text('Add Customer'))
                                  : MLSubmenu(
                                      // onClick: () {
                                      //   Navigator.pushNamed(
                                      //       context, RouteManager.route_customer_create);
                                      // },
                                      submenuContent: Text('Add Customer',
                                          style:
                                              TextStyle(color: Colors.grey))),
                            ])
                      : MLMenuItem(
                          leading: Row(
                            children: [
                              SizedBox(
                                width: 2,
                              ),
                              Icon(Icons.people_alt_rounded, color: Colors.grey)
                            ],
                          ),
                          trailing: Icon(Icons.arrow_right, color: Colors.grey),
                          content: Text('  Customers',
                              style: TextStyle(color: Colors.grey)),
                          onClick: () {},
                          // subMenuItems: [
                          //   MLSubmenu(
                          //       onClick: () {
                          //         Navigator.pushNamed(
                          //             context, RouteManager.route_customer_list);
                          //       },
                          //       submenuContent: Text('Customer Listing')),
                          //   MLSubmenu(
                          //       onClick: () {
                          //         Navigator.pushNamed(
                          //             context, RouteManager.route_customer_create);
                          //       },
                          //       submenuContent: Text('Add Customer')),
                          // ]
                        ),

                  permissionShowResponse.booking[0].read == 1 ||
                          permissionShowResponse.booking[0].create == 1 ||
                          permissionShowResponse.booking[0].update == 1 ||
                          permissionShowResponse.booking[0].delete == 1
                      ? MLMenuItem(
                          leading: Row(
                            children: [
                              SizedBox(
                                width: 2,
                              ),
                              Icon(Icons.airport_shuttle_rounded)
                            ],
                          ),
                          trailing: Icon(Icons.arrow_right),
                          content: Text('  Bookings'),
                          onClick: () {},
                          subMenuItems: [
                              permissionShowResponse.booking[0].create == 1
                                  ? MLSubmenu(
                                      onClick: () {
                                        Navigator.pushNamed(context,
                                            RouteManager.route_booking_list);
                                      },
                                      submenuContent: Text('Service Bookings'))
                                  : MLSubmenu(
                                      // onClick: () {
                                      //   Navigator.pushNamed(
                                      //       context, RouteManager.route_booking_list);
                                      // },
                                      submenuContent: Text(
                                      'Service Bookings',
                                      style: TextStyle(color: Colors.grey),
                                    )),
                              permissionShowResponse.booking[0].read == 1
                                  ? MLSubmenu(
                                      onClick: () {
                                        Navigator.pushNamed(context,
                                            RouteManager.route_booking_create);
                                      },
                                      submenuContent: Text('Create Booking'))
                                  : MLSubmenu(
                                      // onClick: () {
                                      //   Navigator.pushNamed(
                                      //       context, RouteManager.route_booking_create);
                                      // },
                                      submenuContent: Text(
                                      'Create Booking',
                                      style: TextStyle(color: Colors.grey),
                                    )),
                            ])
                      : MLMenuItem(
                          leading: Row(
                            children: [
                              SizedBox(
                                width: 2,
                              ),
                              Icon(Icons.airport_shuttle_rounded,
                                  color: Colors.grey)
                            ],
                          ),
                          trailing: Icon(Icons.arrow_right, color: Colors.grey),
                          content: Text('  Bookings',
                              style: TextStyle(color: Colors.grey)),
                          onClick: () {},
                          // subMenuItems: [
                          //   MLSubmenu(
                          //       onClick: () {
                          //         Navigator.pushNamed(
                          //             context, RouteManager.route_booking_list);
                          //       },
                          //       submenuContent: Text('Service Bookings')),
                          //   MLSubmenu(
                          //       onClick: () {
                          //         Navigator.pushNamed(
                          //             context, RouteManager.route_booking_create);
                          //       },
                          //       submenuContent: Text('Create Booking')),
                          // ]
                        ),

                  if (Platform.isIOS)
                    permissionShowResponse.quotation[0].read == 1 ||
                            permissionShowResponse.quotation[0].create == 1
                        ? MLMenuItem(
                            leading: Row(
                              children: [
                                SizedBox(
                                  width: 2,
                                ),
                                Icon(Icons.help)
                              ],
                            ),
                            trailing: Icon(Icons.arrow_right),
                            content: Text('  Quotation'),
                            onClick: () {},
                            subMenuItems: [
                                permissionShowResponse.quotation[0].create == 1
                                    ? MLSubmenu(
                                        onClick: () {
                                          Navigator.pushNamed(context,
                                              RouteManager.route_qoute_list);
                                        },
                                        submenuContent: Text('Quotations'))
                                    : MLSubmenu(
                                        // onClick: () {
                                        //   Navigator.pushNamed(
                                        //       context, RouteManager.route_qoute_list);
                                        // },
                                        submenuContent: Text(
                                        'Quotations',
                                        style: TextStyle(color: Colors.grey),
                                      )),
                                permissionShowResponse.quotation[0].read == 1
                                    ? MLSubmenu(
                                        onClick: () {
                                          Navigator.pushNamed(context,
                                              RouteManager.route_qoute_create);
                                        },
                                        submenuContent: Text('Send Quote'))
                                    : MLSubmenu(
                                        // onClick: () {
                                        //   Navigator.pushNamed(
                                        //       context, RouteManager.route_qoute_create);
                                        // },
                                        submenuContent: Text(
                                        'Send Quote',
                                        style: TextStyle(color: Colors.grey),
                                      )),
                              ])
                        : MLMenuItem(
                            leading: Row(
                              children: [
                                SizedBox(
                                  width: 2,
                                ),
                                Icon(Icons.help, color: Colors.grey)
                              ],
                            ),
                            trailing:
                                Icon(Icons.arrow_right, color: Colors.grey),
                            content: Text('  Quotation',
                                style: TextStyle(color: Colors.grey)),
                            onClick: () {},
                            // subMenuItems: [
                            //   MLSubmenu(
                            //       onClick: () {
                            //         Navigator.pushNamed(
                            //             context, RouteManager.route_qoute_list);
                            //       },
                            //       submenuContent: Text('Quotations')),
                            //   MLSubmenu(
                            //       onClick: () {
                            //         Navigator.pushNamed(
                            //             context, RouteManager.route_qoute_create);
                            //       },
                            //       submenuContent: Text('Send Quote')),
                            // ]
                          ),
                  // MLMenuItem(
                  //     leading: Icon(Icons.email),
                  //     trailing: Icon(Icons.arrow_right),
                  //     content: Text('Email Tools'),
                  //     onClick: () {},
                  //     subMenuItems: [
                  //       MLSubmenu(
                  //         onClick: () {
                  //           Navigator.pushNamed(
                  //               context, RouteManager.route_mailingservice);
                  //         },
                  //         submenuContent: Text("Mailing Service"),
                  //       ),
                  //     ]),
                  // MLMenuItem(
                  //     leading: Icon(Icons.person_add_alt_1_rounded),
                  //     trailing: Icon(Icons.arrow_right),
                  //     content: Text('User Settings'),
                  //     onClick: () {},
                  //     subMenuItems: [
                  //       MLSubmenu(
                  //           onClick: () {
                  //             Navigator.pushNamed(
                  //                 context, RouteManager.route_user_list);
                  //           },
                  //           submenuContent: Text('User')),
                  //       MLSubmenu(
                  //           onClick: () {
                  //             Navigator.pushNamed(
                  //                 context, RouteManager.route_role_list);
                  //           },
                  //           submenuContent: Text('Roles')),
                  //     ]),
                  // MLMenuItem(
                  //     leading: Icon(Icons.miscellaneous_services_rounded),
                  //     trailing: Icon(Icons.arrow_right),
                  //     content: Text('Site Settings'),
                  //     onClick: () {},
                  //     subMenuItems: [
                  //       MLSubmenu(
                  //           onClick: () {
                  //             Navigator.pushNamed(context, RouteManager.route_message);
                  //           },
                  //           submenuContent: Text('Message')),
                  //     ]),
                  if (Platform.isIOS)
                    permissionShowResponse.expenseTypes[0].read == 1 ||
                            permissionShowResponse.expenseTypes[0].create ==
                                1 ||
                            permissionShowResponse.expenseTypes[0].update == 1
                        ? MLMenuItem(
                            content: Text('  Expense Types'),
                            leading: Row(
                              children: [
                                SizedBox(
                                  width: 2,
                                ),
                                Icon(Icons.add)
                              ],
                            ),
                            trailing: Icon(Icons.arrow_right),
                            onClick: () {},
                            subMenuItems: [
                              permissionShowResponse.expenseTypes[0].create == 1
                                  ? MLSubmenu(
                                      onClick: () {
                                        Navigator.pushNamed(context,
                                            RouteManager.route_expense_types);
                                      },
                                      submenuContent: Text('Expense Types'),
                                    )
                                  : MLSubmenu(
                                      // onClick: () {
                                      //   Navigator.pushNamed(
                                      //       context, RouteManager.route_expense_types);
                                      // },
                                      submenuContent: Text(
                                        'Expense Types',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                              permissionShowResponse.expenseTypes[0].read == 1
                                  ? MLSubmenu(
                                      onClick: () {
                                        Navigator.pushNamed(
                                            context,
                                            RouteManager
                                                .route_expense_types_create);
                                      },
                                      submenuContent: Text('Create Type'),
                                    )
                                  : MLSubmenu(
                                      // onClick: () {
                                      //   Navigator.pushNamed(
                                      //       context, RouteManager.route_expense_types_create);
                                      // },
                                      submenuContent: Text(
                                        'Create Type',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                            ],
                          )
                        : MLMenuItem(
                            content: Text('  Expense Types',
                                style: TextStyle(color: Colors.grey)),
                            leading: Row(
                              children: [
                                SizedBox(
                                  width: 2,
                                ),
                                Icon(Icons.add, color: Colors.grey)
                              ],
                            ),
                            trailing:
                                Icon(Icons.arrow_right, color: Colors.grey),
                            onClick: () {},
                            // subMenuItems: [
                            //   MLSubmenu(
                            //     onClick: () {
                            //       Navigator.pushNamed(
                            //           context, RouteManager.route_expense_types);
                            //     },
                            //     submenuContent: Text('Expense Types'),
                            //   ),
                            //   MLSubmenu(
                            //     onClick: () {
                            //       Navigator.pushNamed(
                            //           context, RouteManager.route_expense_types_create);
                            //     },
                            //     submenuContent: Text('Create Type'),
                            //   ),
                            // ],
                          ),
                  if (Platform.isIOS)
                    permissionShowResponse.expenses[0].read == 1 ||
                            permissionShowResponse.expenses[0].create == 1
                        ? MLMenuItem(
                            content: Text('  Expenses'),
                            leading: Row(
                              children: [
                                SizedBox(
                                  width: 2,
                                ),
                                Icon(Icons.indeterminate_check_box)
                              ],
                            ),
                            trailing: Icon(Icons.arrow_right),
                            onClick: () {},
                            subMenuItems: [
                              // permissionShowResponse.expenses[0].create == 1
                              //     ? MLSubmenu(
                              //         onClick: () {
                              //           Navigator.pushNamed(context,
                              //               RouteManager.route_expenses_sub);
                              //         },
                              //         submenuContent: Text('Expenses'),
                              //       )
                              //     : MLSubmenu(
                              //         // onClick: () {
                              //         //   Navigator.pushNamed(
                              //         //       context, RouteManager.route_expenses_sub);
                              //         // },
                              //         submenuContent: Text(
                              //           'Expenses',
                              //           style: TextStyle(color: Colors.grey),
                              //         ),
                              //       ),
                              permissionShowResponse.expenses[0].read == 1
                                  ? MLSubmenu(
                                      onClick: () {
                                        Navigator.pushNamed(context,
                                            RouteManager.route_expenses);
                                      },
                                      submenuContent: Text('Add Expense'),
                                    )
                                  : MLSubmenu(
                                      // onClick: () {
                                      //   Navigator.pushNamed(
                                      //       context, RouteManager.route_expenses);
                                      // },
                                      submenuContent: Text(
                                        'Add Expense',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                            ],
                          )
                        : MLMenuItem(
                            content: Text(
                              '  Expenses',
                              style: TextStyle(color: Colors.grey),
                            ),
                            leading: Row(
                              children: [
                                SizedBox(
                                  width: 2,
                                ),
                                Icon(Icons.indeterminate_check_box,
                                    color: Colors.grey)
                              ],
                            ),
                            trailing:
                                Icon(Icons.arrow_right, color: Colors.grey),
                            onClick: () {},
                            // subMenuItems: [
                            //   MLSubmenu(
                            //     onClick: () {
                            //       Navigator.pushNamed(
                            //           context, RouteManager.route_expenses_sub);
                            //     },
                            //     submenuContent: Text('Expenses'),
                            //   ),
                            //   MLSubmenu(
                            //     onClick: () {
                            //       Navigator.pushNamed(context, RouteManager.route_expenses);
                            //     },
                            //     submenuContent: Text('Add Expense'),
                            //   ),
                            // ],
                          ),
                  MLMenuItem(
                      leading: Row(
                        children: [
                          SizedBox(
                            width: 2,
                          ),
                          Icon(Icons.logout)
                        ],
                      ),
                      content: Text("  Logout"),
                      onClick: () {
                        logoutSessionUser();
                        Navigator.of(context)
                            .pushReplacementNamed(RouteManager.route_login);
                      }),
                ],
              ),
        appBar: AppBar(
          title: Text('Dashboard'),
        ),
        body: Container(
          child: dashboard(),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:powerdiary/ui/pages/dashboard/dashboard.dart';
import 'package:powerdiary/ui/pages/theme/app_theme.dart';
import 'package:powerdiary/utils/route_manager.dart';
import 'package:powerdiary/utils/utils.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  final createcategory = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        drawer: MultiLevelDrawer(
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
                    backgroundImage: NetworkImage('${globalSessionUser.image}'),
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
                leading: Icon(Icons.home_rounded),
                content: Text("Dashboard"),
                onClick: () {
                  Navigator.pushNamed(context, RouteManager.route_dashboard);
                }),
            globalSessionUser.roleId == 60
                ? MLMenuItem(
                    leading: Icon(Icons.business_center),
                    trailing: Icon(Icons.arrow_right),
                    content: Text('Category'),
                    onClick: () {},
                    subMenuItems: [
                        MLSubmenu(
                            onClick: () {
                              Navigator.pushNamed(
                                  context, RouteManager.route_category_list);
                            },
                            submenuContent: Text('Category Listing')),
                        MLSubmenu(
                            // onClick: () {
                            //   Navigator.pushNamed(
                            //       context, RouteManager.route_category_create);
                            // },
                            submenuContent: Text('Create Category')),
                      ])
                : MLMenuItem(
                    leading: Icon(Icons.business_center),
                    trailing: Icon(Icons.arrow_right),
                    content: Text('Category'),
                    onClick: () {},
                    subMenuItems: [
                        MLSubmenu(
                            onClick: () {
                              Navigator.pushNamed(
                                  context, RouteManager.route_category_list);
                            },
                            submenuContent: Text('Category Listing')),
                        MLSubmenu(
                            onClick: () {
                              Navigator.pushNamed(
                                  context, RouteManager.route_category_create);
                            },
                            submenuContent: Text('Create Category')),
                      ]),
            MLMenuItem(
                leading: Icon(Icons.insert_chart),
                trailing: Icon(Icons.arrow_right),
                content: Text('Services'),
                onClick: () {},
                subMenuItems: [
                  MLSubmenu(
                      onClick: () {
                        Navigator.pushNamed(
                            context, RouteManager.route_service_list);
                      },
                      submenuContent: Text('Service Listing')),
                  MLSubmenu(
                      onClick: () {
                        Navigator.pushNamed(
                            context, RouteManager.route_service_create);
                      },
                      submenuContent: Text('Create Service')),
                ]),
            MLMenuItem(
                leading: Icon(Icons.people_alt_rounded),
                trailing: Icon(Icons.arrow_right),
                content: Text('Customers'),
                onClick: () {},
                subMenuItems: [
                  MLSubmenu(
                      onClick: () {
                        Navigator.pushNamed(
                            context, RouteManager.route_customer_list);
                      },
                      submenuContent: Text('Customer Listing')),
                  MLSubmenu(
                      onClick: () {
                        Navigator.pushNamed(
                            context, RouteManager.route_customer_create);
                      },
                      submenuContent: Text('Add Customer')),
                ]),
            MLMenuItem(
                leading: Icon(Icons.airport_shuttle_rounded),
                trailing: Icon(Icons.arrow_right),
                content: Text('Bookings'),
                onClick: () {},
                subMenuItems: [
                  MLSubmenu(
                      onClick: () {
                        Navigator.pushNamed(
                            context, RouteManager.route_booking_list);
                      },
                      submenuContent: Text('Service Bookings')),
                  MLSubmenu(
                      onClick: () {
                        Navigator.pushNamed(
                            context, RouteManager.route_booking_create);
                      },
                      submenuContent: Text('Create Booking')),
                ]),
            MLMenuItem(
                leading: Icon(Icons.help),
                trailing: Icon(Icons.arrow_right),
                content: Text('Quotation'),
                onClick: () {},
                subMenuItems: [
                  MLSubmenu(
                      onClick: () {
                        Navigator.pushNamed(
                            context, RouteManager.route_qoute_list);
                      },
                      submenuContent: Text('Quotations')),
                  MLSubmenu(
                      onClick: () {
                        Navigator.pushNamed(
                            context, RouteManager.route_qoute_create);
                      },
                      submenuContent: Text('Send Quote')),
                ]),
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
            MLMenuItem(
                leading: Icon(Icons.person_add_alt_1_rounded),
                trailing: Icon(Icons.arrow_right),
                content: Text('User Settings'),
                onClick: () {},
                subMenuItems: [
                  MLSubmenu(
                      onClick: () {
                        Navigator.pushNamed(
                            context, RouteManager.route_user_list);
                      },
                      submenuContent: Text('User')),
                  MLSubmenu(
                      onClick: () {
                        Navigator.pushNamed(
                            context, RouteManager.route_role_list);
                      },
                      submenuContent: Text('Roles')),
                ]),
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
            MLMenuItem(
              content: Text('Expense Types'),
              leading: Icon(Icons.add),
              trailing: Icon(Icons.arrow_right),
              onClick: () {},
              subMenuItems: [
                MLSubmenu(
                  onClick: () {
                    Navigator.pushNamed(
                        context, RouteManager.route_expense_types);
                  },
                  submenuContent: Text('Expense Types'),
                ),
                MLSubmenu(
                  onClick: () {
                    Navigator.pushNamed(
                        context, RouteManager.route_expense_types_create);
                  },
                  submenuContent: Text('Create Type'),
                ),
              ],
            ),
            MLMenuItem(
              content: Text('Expenses'),
              leading: Icon(Icons.indeterminate_check_box),
              trailing: Icon(Icons.arrow_right),
              onClick: () {},
              subMenuItems: [
                MLSubmenu(
                  onClick: () {
                    Navigator.pushNamed(
                        context, RouteManager.route_expenses_sub);
                  },
                  submenuContent: Text('Expenses'),
                ),
                MLSubmenu(
                  onClick: () {
                    Navigator.pushNamed(context, RouteManager.route_expenses);
                  },
                  submenuContent: Text('Add Expense'),
                ),
              ],
            ),
            MLMenuItem(
                leading: Icon(Icons.logout),
                content: Text("Logout"),
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

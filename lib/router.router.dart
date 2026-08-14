// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i38;
import 'package:flutter/material.dart';
import 'package:geolocation/model/add_order_model.dart' as _i39;
import 'package:geolocation/model/addquotation_model.dart' as _i40;
import 'package:geolocation/screens/attendence_screen/attendence_view.dart'
    as _i20;
import 'package:geolocation/screens/change_password/change_password_screen.dart'
    as _i26;
import 'package:geolocation/screens/customer_screen/add_customer/add_customer_view.dart'
    as _i28;
import 'package:geolocation/screens/customer_screen/customer_list/customer_list_screen.dart'
    as _i27;
import 'package:geolocation/screens/customer_screen/Update_Customer/update_customer_screen.dart'
    as _i29;
import 'package:geolocation/screens/delivery_note.dart' as _i35;
import 'package:geolocation/screens/delivery_note_list.dart' as _i34;
import 'package:geolocation/screens/Distributor%20Sales%20Order/add_sales_order/add_distributor_order_screen.dart'
    as _i11;
import 'package:geolocation/screens/Distributor%20Sales%20Order/list_sales_order/list_sales_distributor_order_screen.dart'
    as _i10;
import 'package:geolocation/screens/expense_screen/add_expense/add_expense_view.dart'
    as _i22;
import 'package:geolocation/screens/expense_screen/list_expense/list_expense_view.dart'
    as _i21;
import 'package:geolocation/screens/geolocation/geolocation_view.dart' as _i5;
import 'package:geolocation/screens/holiday_screen/holiday_view.dart' as _i19;
import 'package:geolocation/screens/home_screen/home_page.dart' as _i3;
import 'package:geolocation/screens/lead_screen/add_lead_screen/add_lead_screen.dart'
    as _i14;
import 'package:geolocation/screens/lead_screen/lead_list/lead_screen.dart'
    as _i13;
import 'package:geolocation/screens/lead_screen/update_screen/update_screen.dart'
    as _i15;
import 'package:geolocation/screens/leave_screen/add_leave/add_leave_view.dart'
    as _i24;
import 'package:geolocation/screens/leave_screen/list_leave/list_leave_view.dart'
    as _i23;
import 'package:geolocation/screens/location_tracking/location_tracker.dart'
    as _i6;
import 'package:geolocation/screens/login/login_view.dart' as _i4;
import 'package:geolocation/screens/profile_screen/profile_screen.dart' as _i25;
import 'package:geolocation/screens/Quotation/Add%20Quotation/add_quotation_screen.dart'
    as _i16;
import 'package:geolocation/screens/Quotation/Items/items_screen.dart' as _i18;
import 'package:geolocation/screens/Quotation/List%20Quotation/list_quotation_view.dart'
    as _i17;
import 'package:geolocation/screens/retailer_registration/add_retailer/add_retailer_screen.dart'
    as _i33;
import 'package:geolocation/screens/sales_order/add_sales_order/add_order_screen.dart'
    as _i8;
import 'package:geolocation/screens/sales_order/items/add_items_screen.dart'
    as _i12;
import 'package:geolocation/screens/sales_order/list_sales_order/list_sales_order_screen.dart'
    as _i7;
import 'package:geolocation/screens/sales_order_uom/sales_order_uom_screen.dart'
    as _i9;
import 'package:geolocation/screens/self_orders/items/add_self_order_screen.dart'
    as _i37;
import 'package:geolocation/screens/self_orders/list_sales_order/list_self_order_screen.dart'
    as _i36;
import 'package:geolocation/screens/splash_screen/splash_screen.dart' as _i2;
import 'package:geolocation/screens/visit_screens/add_visit/add_visit_view.dart'
    as _i31;
import 'package:geolocation/screens/visit_screens/update_visit/update_visit_view.dart'
    as _i32;
import 'package:geolocation/screens/visit_screens/visit_List/visit_list_screen.dart'
    as _i30;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i41;

class Routes {
  static const splashScreen = '/';

  static const homePage = '/home-page';

  static const loginViewScreen = '/login-view-screen';

  static const geolocation = '/Geolocation';

  static const locationTracker = '/location-tracker';

  static const listOrderScreen = '/list-order-screen';

  static const addOrderScreen = '/add-order-screen';

  static const salesOrderUomScreen = '/sales-order-uom-screen';

  static const listDistributorOrderScreen = '/list-distributor-order-screen';

  static const addDistributorOrderScreen = '/add-distributor-order-screen';

  static const itemScreen = '/item-screen';

  static const leadListScreen = '/lead-list-screen';

  static const addLeadScreen = '/add-lead-screen';

  static const updateLeadScreen = '/update-lead-screen';

  static const addQuotationView = '/add-quotation-view';

  static const listQuotationScreen = '/list-quotation-screen';

  static const quotationItemScreen = '/quotation-item-screen';

  static const holidayScreen = '/holiday-screen';

  static const attendanceScreen = '/attendance-screen';

  static const expenseScreen = '/expense-screen';

  static const addExpenseScreen = '/add-expense-screen';

  static const listLeaveScreen = '/list-leave-screen';

  static const addLeaveScreen = '/add-leave-screen';

  static const profileScreen = '/profile-screen';

  static const changePasswordScreen = '/change-password-screen';

  static const customerList = '/customer-list';

  static const addCustomer = '/add-customer';

  static const updateCustomer = '/update-customer';

  static const visitScreen = '/visit-screen';

  static const addVisitScreen = '/add-visit-screen';

  static const updateVisitScreen = '/update-visit-screen';

  static const retailerFormView = '/retailer-form-view';

  static const listDeliveryNoteScreen = '/list-delivery-note-screen';

  static const deliveryNoteScreen = '/delivery-note-screen';

  static const listSelfOrderScreen = '/list-self-order-screen';

  static const createSelfOrderScreen = '/create-self-order-screen';

  static const all = <String>{
    splashScreen,
    homePage,
    loginViewScreen,
    geolocation,
    locationTracker,
    listOrderScreen,
    addOrderScreen,
    salesOrderUomScreen,
    listDistributorOrderScreen,
    addDistributorOrderScreen,
    itemScreen,
    leadListScreen,
    addLeadScreen,
    updateLeadScreen,
    addQuotationView,
    listQuotationScreen,
    quotationItemScreen,
    holidayScreen,
    attendanceScreen,
    expenseScreen,
    addExpenseScreen,
    listLeaveScreen,
    addLeaveScreen,
    profileScreen,
    changePasswordScreen,
    customerList,
    addCustomer,
    updateCustomer,
    visitScreen,
    addVisitScreen,
    updateVisitScreen,
    retailerFormView,
    listDeliveryNoteScreen,
    deliveryNoteScreen,
    listSelfOrderScreen,
    createSelfOrderScreen,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(Routes.splashScreen, page: _i2.SplashScreen),
    _i1.RouteDef(Routes.homePage, page: _i3.HomePage),
    _i1.RouteDef(Routes.loginViewScreen, page: _i4.LoginViewScreen),
    _i1.RouteDef(Routes.geolocation, page: _i5.Geolocation),
    _i1.RouteDef(Routes.locationTracker, page: _i6.LocationTracker),
    _i1.RouteDef(Routes.listOrderScreen, page: _i7.ListOrderScreen),
    _i1.RouteDef(Routes.addOrderScreen, page: _i8.AddOrderScreen),
    _i1.RouteDef(Routes.salesOrderUomScreen, page: _i9.SalesOrderUomScreen),
    _i1.RouteDef(
      Routes.listDistributorOrderScreen,
      page: _i10.ListDistributorOrderScreen,
    ),
    _i1.RouteDef(
      Routes.addDistributorOrderScreen,
      page: _i11.AddDistributorOrderScreen,
    ),
    _i1.RouteDef(Routes.itemScreen, page: _i12.ItemScreen),
    _i1.RouteDef(Routes.leadListScreen, page: _i13.LeadListScreen),
    _i1.RouteDef(Routes.addLeadScreen, page: _i14.AddLeadScreen),
    _i1.RouteDef(Routes.updateLeadScreen, page: _i15.UpdateLeadScreen),
    _i1.RouteDef(Routes.addQuotationView, page: _i16.AddQuotationView),
    _i1.RouteDef(Routes.listQuotationScreen, page: _i17.ListQuotationScreen),
    _i1.RouteDef(Routes.quotationItemScreen, page: _i18.QuotationItemScreen),
    _i1.RouteDef(Routes.holidayScreen, page: _i19.HolidayScreen),
    _i1.RouteDef(Routes.attendanceScreen, page: _i20.AttendanceScreen),
    _i1.RouteDef(Routes.expenseScreen, page: _i21.ExpenseScreen),
    _i1.RouteDef(Routes.addExpenseScreen, page: _i22.AddExpenseScreen),
    _i1.RouteDef(Routes.listLeaveScreen, page: _i23.ListLeaveScreen),
    _i1.RouteDef(Routes.addLeaveScreen, page: _i24.AddLeaveScreen),
    _i1.RouteDef(Routes.profileScreen, page: _i25.ProfileScreen),
    _i1.RouteDef(Routes.changePasswordScreen, page: _i26.ChangePasswordScreen),
    _i1.RouteDef(Routes.customerList, page: _i27.CustomerList),
    _i1.RouteDef(Routes.addCustomer, page: _i28.AddCustomer),
    _i1.RouteDef(Routes.updateCustomer, page: _i29.UpdateCustomer),
    _i1.RouteDef(Routes.visitScreen, page: _i30.VisitScreen),
    _i1.RouteDef(Routes.addVisitScreen, page: _i31.AddVisitScreen),
    _i1.RouteDef(Routes.updateVisitScreen, page: _i32.UpdateVisitScreen),
    _i1.RouteDef(Routes.retailerFormView, page: _i33.RetailerFormView),
    _i1.RouteDef(
      Routes.listDeliveryNoteScreen,
      page: _i34.ListDeliveryNoteScreen,
    ),
    _i1.RouteDef(Routes.deliveryNoteScreen, page: _i35.DeliveryNoteScreen),
    _i1.RouteDef(Routes.listSelfOrderScreen, page: _i36.ListSelfOrderScreen),
    _i1.RouteDef(
      Routes.createSelfOrderScreen,
      page: _i37.CreateSelfOrderScreen,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.SplashScreen: (data) {
      final args = data.getArgs<SplashScreenArguments>(
        orElse: () => const SplashScreenArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.SplashScreen(key: args.key),
        settings: data,
      );
    },
    _i3.HomePage: (data) {
      final args = data.getArgs<HomePageArguments>(
        orElse: () => const HomePageArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.HomePage(key: args.key),
        settings: data,
      );
    },
    _i4.LoginViewScreen: (data) {
      final args = data.getArgs<LoginViewScreenArguments>(
        orElse: () => const LoginViewScreenArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.LoginViewScreen(key: args.key),
        settings: data,
      );
    },
    _i5.Geolocation: (data) {
      final args = data.getArgs<GeolocationArguments>(
        orElse: () => const GeolocationArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.Geolocation(key: args.key),
        settings: data,
      );
    },
    _i6.LocationTracker: (data) {
      final args = data.getArgs<LocationTrackerArguments>(
        orElse: () => const LocationTrackerArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i6.LocationTracker(key: args.key),
        settings: data,
      );
    },
    _i7.ListOrderScreen: (data) {
      final args = data.getArgs<ListOrderScreenArguments>(
        orElse: () => const ListOrderScreenArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i7.ListOrderScreen(key: args.key),
        settings: data,
      );
    },
    _i8.AddOrderScreen: (data) {
      final args = data.getArgs<AddOrderScreenArguments>(nullOk: false);
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i8.AddOrderScreen(key: args.key, orderid: args.orderid),
        settings: data,
      );
    },
    _i9.SalesOrderUomScreen: (data) {
      final args = data.getArgs<SalesOrderUomScreenArguments>(
        orElse: () => const SalesOrderUomScreenArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i9.SalesOrderUomScreen(key: args.key),
        settings: data,
      );
    },
    _i10.ListDistributorOrderScreen: (data) {
      final args = data.getArgs<ListDistributorOrderScreenArguments>(
        orElse: () => const ListDistributorOrderScreenArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i10.ListDistributorOrderScreen(key: args.key),
        settings: data,
      );
    },
    _i11.AddDistributorOrderScreen: (data) {
      final args = data.getArgs<AddDistributorOrderScreenArguments>(
        nullOk: false,
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i11.AddDistributorOrderScreen(
          key: args.key,
          orderId: args.orderId,
        ),
        settings: data,
      );
    },
    _i12.ItemScreen: (data) {
      final args = data.getArgs<ItemScreenArguments>(nullOk: false);
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i12.ItemScreen(
          key: args.key,
          warehouse: args.warehouse,
          items: args.items,
          selectedItems: args.selectedItems,
        ),
        settings: data,
      );
    },
    _i13.LeadListScreen: (data) {
      final args = data.getArgs<LeadListScreenArguments>(
        orElse: () => const LeadListScreenArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i13.LeadListScreen(key: args.key),
        settings: data,
      );
    },
    _i14.AddLeadScreen: (data) {
      final args = data.getArgs<AddLeadScreenArguments>(nullOk: false);
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i14.AddLeadScreen(key: args.key, leadId: args.leadId),
        settings: data,
      );
    },
    _i15.UpdateLeadScreen: (data) {
      final args = data.getArgs<UpdateLeadScreenArguments>(nullOk: false);
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i15.UpdateLeadScreen(key: args.key, updateId: args.updateId),
        settings: data,
      );
    },
    _i16.AddQuotationView: (data) {
      final args = data.getArgs<AddQuotationViewArguments>(nullOk: false);
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i16.AddQuotationView(key: args.key, quotationid: args.quotationid),
        settings: data,
      );
    },
    _i17.ListQuotationScreen: (data) {
      final args = data.getArgs<ListQuotationScreenArguments>(
        orElse: () => const ListQuotationScreenArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i17.ListQuotationScreen(key: args.key),
        settings: data,
      );
    },
    _i18.QuotationItemScreen: (data) {
      final args = data.getArgs<QuotationItemScreenArguments>(nullOk: false);
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i18.QuotationItemScreen(key: args.key, items: args.items),
        settings: data,
      );
    },
    _i19.HolidayScreen: (data) {
      final args = data.getArgs<HolidayScreenArguments>(
        orElse: () => const HolidayScreenArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i19.HolidayScreen(key: args.key),
        settings: data,
      );
    },
    _i20.AttendanceScreen: (data) {
      final args = data.getArgs<AttendanceScreenArguments>(
        orElse: () => const AttendanceScreenArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i20.AttendanceScreen(key: args.key),
        settings: data,
      );
    },
    _i21.ExpenseScreen: (data) {
      final args = data.getArgs<ExpenseScreenArguments>(
        orElse: () => const ExpenseScreenArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i21.ExpenseScreen(key: args.key),
        settings: data,
      );
    },
    _i22.AddExpenseScreen: (data) {
      final args = data.getArgs<AddExpenseScreenArguments>(nullOk: false);
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i22.AddExpenseScreen(key: args.key, expenseId: args.expenseId),
        settings: data,
      );
    },
    _i23.ListLeaveScreen: (data) {
      final args = data.getArgs<ListLeaveScreenArguments>(
        orElse: () => const ListLeaveScreenArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i23.ListLeaveScreen(key: args.key),
        settings: data,
      );
    },
    _i24.AddLeaveScreen: (data) {
      final args = data.getArgs<AddLeaveScreenArguments>(nullOk: false);
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i24.AddLeaveScreen(key: args.key, leaveId: args.leaveId),
        settings: data,
      );
    },
    _i25.ProfileScreen: (data) {
      final args = data.getArgs<ProfileScreenArguments>(
        orElse: () => const ProfileScreenArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i25.ProfileScreen(key: args.key),
        settings: data,
      );
    },
    _i26.ChangePasswordScreen: (data) {
      final args = data.getArgs<ChangePasswordScreenArguments>(
        orElse: () => const ChangePasswordScreenArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i26.ChangePasswordScreen(key: args.key),
        settings: data,
      );
    },
    _i27.CustomerList: (data) {
      final args = data.getArgs<CustomerListArguments>(
        orElse: () => const CustomerListArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i27.CustomerList(key: args.key),
        settings: data,
      );
    },
    _i28.AddCustomer: (data) {
      final args = data.getArgs<AddCustomerArguments>(nullOk: false);
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i28.AddCustomer(key: args.key, id: args.id),
        settings: data,
      );
    },
    _i29.UpdateCustomer: (data) {
      final args = data.getArgs<UpdateCustomerArguments>(nullOk: false);
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i29.UpdateCustomer(key: args.key, id: args.id),
        settings: data,
      );
    },
    _i30.VisitScreen: (data) {
      final args = data.getArgs<VisitScreenArguments>(
        orElse: () => const VisitScreenArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i30.VisitScreen(key: args.key),
        settings: data,
      );
    },
    _i31.AddVisitScreen: (data) {
      final args = data.getArgs<AddVisitScreenArguments>(nullOk: false);
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i31.AddVisitScreen(key: args.key, VisitId: args.VisitId),
        settings: data,
      );
    },
    _i32.UpdateVisitScreen: (data) {
      final args = data.getArgs<UpdateVisitScreenArguments>(nullOk: false);
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i32.UpdateVisitScreen(key: args.key, updateId: args.updateId),
        settings: data,
      );
    },
    _i33.RetailerFormView: (data) {
      final args = data.getArgs<RetailerFormViewArguments>(nullOk: false);
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i33.RetailerFormView(key: args.key, retailerId: args.retailerId),
        settings: data,
      );
    },
    _i34.ListDeliveryNoteScreen: (data) {
      final args = data.getArgs<ListDeliveryNoteScreenArguments>(
        orElse: () => const ListDeliveryNoteScreenArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i34.ListDeliveryNoteScreen(key: args.key),
        settings: data,
      );
    },
    _i35.DeliveryNoteScreen: (data) {
      final args = data.getArgs<DeliveryNoteScreenArguments>(nullOk: false);
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i35.DeliveryNoteScreen(key: args.key, orderData: args.orderData),
        settings: data,
      );
    },
    _i36.ListSelfOrderScreen: (data) {
      final args = data.getArgs<ListSelfOrderScreenArguments>(
        orElse: () => const ListSelfOrderScreenArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) => _i36.ListSelfOrderScreen(key: args.key),
        settings: data,
      );
    },
    _i37.CreateSelfOrderScreen: (data) {
      final args = data.getArgs<CreateSelfOrderScreenArguments>(
        orElse: () => const CreateSelfOrderScreenArguments(),
      );
      return _i38.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i37.CreateSelfOrderScreen(key: args.key, orderId: args.orderId),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class SplashScreenArguments {
  const SplashScreenArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant SplashScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class HomePageArguments {
  const HomePageArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant HomePageArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class LoginViewScreenArguments {
  const LoginViewScreenArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant LoginViewScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class GeolocationArguments {
  const GeolocationArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant GeolocationArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class LocationTrackerArguments {
  const LocationTrackerArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant LocationTrackerArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ListOrderScreenArguments {
  const ListOrderScreenArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ListOrderScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AddOrderScreenArguments {
  const AddOrderScreenArguments({this.key, required this.orderid});

  final _i38.Key? key;

  final String orderid;

  @override
  String toString() {
    return '{"key": "$key", "orderid": "$orderid"}';
  }

  @override
  bool operator ==(covariant AddOrderScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.orderid == orderid;
  }

  @override
  int get hashCode {
    return key.hashCode ^ orderid.hashCode;
  }
}

class SalesOrderUomScreenArguments {
  const SalesOrderUomScreenArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant SalesOrderUomScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ListDistributorOrderScreenArguments {
  const ListDistributorOrderScreenArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ListDistributorOrderScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AddDistributorOrderScreenArguments {
  const AddDistributorOrderScreenArguments({this.key, required this.orderId});

  final _i38.Key? key;

  final String orderId;

  @override
  String toString() {
    return '{"key": "$key", "orderId": "$orderId"}';
  }

  @override
  bool operator ==(covariant AddDistributorOrderScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.orderId == orderId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ orderId.hashCode;
  }
}

class ItemScreenArguments {
  const ItemScreenArguments({
    this.key,
    required this.warehouse,
    required this.items,
    required this.selectedItems,
  });

  final _i38.Key? key;

  final String warehouse;

  final List<_i39.Items> items;

  final List<_i39.Items> selectedItems;

  @override
  String toString() {
    return '{"key": "$key", "warehouse": "$warehouse", "items": "$items", "selectedItems": "$selectedItems"}';
  }

  @override
  bool operator ==(covariant ItemScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.warehouse == warehouse &&
        other.items == items &&
        other.selectedItems == selectedItems;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        warehouse.hashCode ^
        items.hashCode ^
        selectedItems.hashCode;
  }
}

class LeadListScreenArguments {
  const LeadListScreenArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant LeadListScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AddLeadScreenArguments {
  const AddLeadScreenArguments({this.key, required this.leadId});

  final _i38.Key? key;

  final String leadId;

  @override
  String toString() {
    return '{"key": "$key", "leadId": "$leadId"}';
  }

  @override
  bool operator ==(covariant AddLeadScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.leadId == leadId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ leadId.hashCode;
  }
}

class UpdateLeadScreenArguments {
  const UpdateLeadScreenArguments({this.key, required this.updateId});

  final _i38.Key? key;

  final String updateId;

  @override
  String toString() {
    return '{"key": "$key", "updateId": "$updateId"}';
  }

  @override
  bool operator ==(covariant UpdateLeadScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.updateId == updateId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ updateId.hashCode;
  }
}

class AddQuotationViewArguments {
  const AddQuotationViewArguments({this.key, required this.quotationid});

  final _i38.Key? key;

  final String quotationid;

  @override
  String toString() {
    return '{"key": "$key", "quotationid": "$quotationid"}';
  }

  @override
  bool operator ==(covariant AddQuotationViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.quotationid == quotationid;
  }

  @override
  int get hashCode {
    return key.hashCode ^ quotationid.hashCode;
  }
}

class ListQuotationScreenArguments {
  const ListQuotationScreenArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ListQuotationScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class QuotationItemScreenArguments {
  const QuotationItemScreenArguments({this.key, required this.items});

  final _i38.Key? key;

  final List<_i40.Items> items;

  @override
  String toString() {
    return '{"key": "$key", "items": "$items"}';
  }

  @override
  bool operator ==(covariant QuotationItemScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.items == items;
  }

  @override
  int get hashCode {
    return key.hashCode ^ items.hashCode;
  }
}

class HolidayScreenArguments {
  const HolidayScreenArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant HolidayScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AttendanceScreenArguments {
  const AttendanceScreenArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant AttendanceScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ExpenseScreenArguments {
  const ExpenseScreenArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ExpenseScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AddExpenseScreenArguments {
  const AddExpenseScreenArguments({this.key, required this.expenseId});

  final _i38.Key? key;

  final String expenseId;

  @override
  String toString() {
    return '{"key": "$key", "expenseId": "$expenseId"}';
  }

  @override
  bool operator ==(covariant AddExpenseScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.expenseId == expenseId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ expenseId.hashCode;
  }
}

class ListLeaveScreenArguments {
  const ListLeaveScreenArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ListLeaveScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AddLeaveScreenArguments {
  const AddLeaveScreenArguments({this.key, required this.leaveId});

  final _i38.Key? key;

  final String leaveId;

  @override
  String toString() {
    return '{"key": "$key", "leaveId": "$leaveId"}';
  }

  @override
  bool operator ==(covariant AddLeaveScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.leaveId == leaveId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ leaveId.hashCode;
  }
}

class ProfileScreenArguments {
  const ProfileScreenArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ProfileScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ChangePasswordScreenArguments {
  const ChangePasswordScreenArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ChangePasswordScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class CustomerListArguments {
  const CustomerListArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant CustomerListArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AddCustomerArguments {
  const AddCustomerArguments({this.key, required this.id});

  final _i38.Key? key;

  final String id;

  @override
  String toString() {
    return '{"key": "$key", "id": "$id"}';
  }

  @override
  bool operator ==(covariant AddCustomerArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.id == id;
  }

  @override
  int get hashCode {
    return key.hashCode ^ id.hashCode;
  }
}

class UpdateCustomerArguments {
  const UpdateCustomerArguments({this.key, required this.id});

  final _i38.Key? key;

  final String id;

  @override
  String toString() {
    return '{"key": "$key", "id": "$id"}';
  }

  @override
  bool operator ==(covariant UpdateCustomerArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.id == id;
  }

  @override
  int get hashCode {
    return key.hashCode ^ id.hashCode;
  }
}

class VisitScreenArguments {
  const VisitScreenArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant VisitScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AddVisitScreenArguments {
  const AddVisitScreenArguments({this.key, required this.VisitId});

  final _i38.Key? key;

  final String VisitId;

  @override
  String toString() {
    return '{"key": "$key", "VisitId": "$VisitId"}';
  }

  @override
  bool operator ==(covariant AddVisitScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.VisitId == VisitId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ VisitId.hashCode;
  }
}

class UpdateVisitScreenArguments {
  const UpdateVisitScreenArguments({this.key, required this.updateId});

  final _i38.Key? key;

  final String updateId;

  @override
  String toString() {
    return '{"key": "$key", "updateId": "$updateId"}';
  }

  @override
  bool operator ==(covariant UpdateVisitScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.updateId == updateId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ updateId.hashCode;
  }
}

class RetailerFormViewArguments {
  const RetailerFormViewArguments({this.key, required this.retailerId});

  final _i38.Key? key;

  final String retailerId;

  @override
  String toString() {
    return '{"key": "$key", "retailerId": "$retailerId"}';
  }

  @override
  bool operator ==(covariant RetailerFormViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.retailerId == retailerId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ retailerId.hashCode;
  }
}

class ListDeliveryNoteScreenArguments {
  const ListDeliveryNoteScreenArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ListDeliveryNoteScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class DeliveryNoteScreenArguments {
  const DeliveryNoteScreenArguments({this.key, required this.orderData});

  final _i38.Key? key;

  final _i39.AddOrderModel orderData;

  @override
  String toString() {
    return '{"key": "$key", "orderData": "$orderData"}';
  }

  @override
  bool operator ==(covariant DeliveryNoteScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.orderData == orderData;
  }

  @override
  int get hashCode {
    return key.hashCode ^ orderData.hashCode;
  }
}

class ListSelfOrderScreenArguments {
  const ListSelfOrderScreenArguments({this.key});

  final _i38.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ListSelfOrderScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class CreateSelfOrderScreenArguments {
  const CreateSelfOrderScreenArguments({this.key, this.orderId = ""});

  final _i38.Key? key;

  final String orderId;

  @override
  String toString() {
    return '{"key": "$key", "orderId": "$orderId"}';
  }

  @override
  bool operator ==(covariant CreateSelfOrderScreenArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.orderId == orderId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ orderId.hashCode;
  }
}

extension NavigatorStateExtension on _i41.NavigationService {
  Future<dynamic> navigateToSplashScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.splashScreen,
      arguments: SplashScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToHomePage({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.homePage,
      arguments: HomePageArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToLoginViewScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.loginViewScreen,
      arguments: LoginViewScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToGeolocation({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.geolocation,
      arguments: GeolocationArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToLocationTracker({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.locationTracker,
      arguments: LocationTrackerArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToListOrderScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.listOrderScreen,
      arguments: ListOrderScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddOrderScreen({
    _i38.Key? key,
    required String orderid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.addOrderScreen,
      arguments: AddOrderScreenArguments(key: key, orderid: orderid),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToSalesOrderUomScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.salesOrderUomScreen,
      arguments: SalesOrderUomScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToListDistributorOrderScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.listDistributorOrderScreen,
      arguments: ListDistributorOrderScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddDistributorOrderScreen({
    _i38.Key? key,
    required String orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.addDistributorOrderScreen,
      arguments: AddDistributorOrderScreenArguments(key: key, orderId: orderId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToItemScreen({
    _i38.Key? key,
    required String warehouse,
    required List<_i39.Items> items,
    required List<_i39.Items> selectedItems,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.itemScreen,
      arguments: ItemScreenArguments(
        key: key,
        warehouse: warehouse,
        items: items,
        selectedItems: selectedItems,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToLeadListScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.leadListScreen,
      arguments: LeadListScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddLeadScreen({
    _i38.Key? key,
    required String leadId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.addLeadScreen,
      arguments: AddLeadScreenArguments(key: key, leadId: leadId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToUpdateLeadScreen({
    _i38.Key? key,
    required String updateId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.updateLeadScreen,
      arguments: UpdateLeadScreenArguments(key: key, updateId: updateId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddQuotationView({
    _i38.Key? key,
    required String quotationid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.addQuotationView,
      arguments: AddQuotationViewArguments(key: key, quotationid: quotationid),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToListQuotationScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.listQuotationScreen,
      arguments: ListQuotationScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToQuotationItemScreen({
    _i38.Key? key,
    required List<_i40.Items> items,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.quotationItemScreen,
      arguments: QuotationItemScreenArguments(key: key, items: items),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToHolidayScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.holidayScreen,
      arguments: HolidayScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAttendanceScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.attendanceScreen,
      arguments: AttendanceScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToExpenseScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.expenseScreen,
      arguments: ExpenseScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddExpenseScreen({
    _i38.Key? key,
    required String expenseId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.addExpenseScreen,
      arguments: AddExpenseScreenArguments(key: key, expenseId: expenseId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToListLeaveScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.listLeaveScreen,
      arguments: ListLeaveScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddLeaveScreen({
    _i38.Key? key,
    required String leaveId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.addLeaveScreen,
      arguments: AddLeaveScreenArguments(key: key, leaveId: leaveId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToProfileScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.profileScreen,
      arguments: ProfileScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToChangePasswordScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.changePasswordScreen,
      arguments: ChangePasswordScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToCustomerList({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.customerList,
      arguments: CustomerListArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddCustomer({
    _i38.Key? key,
    required String id,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.addCustomer,
      arguments: AddCustomerArguments(key: key, id: id),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToUpdateCustomer({
    _i38.Key? key,
    required String id,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.updateCustomer,
      arguments: UpdateCustomerArguments(key: key, id: id),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToVisitScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.visitScreen,
      arguments: VisitScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddVisitScreen({
    _i38.Key? key,
    required String VisitId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.addVisitScreen,
      arguments: AddVisitScreenArguments(key: key, VisitId: VisitId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToUpdateVisitScreen({
    _i38.Key? key,
    required String updateId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.updateVisitScreen,
      arguments: UpdateVisitScreenArguments(key: key, updateId: updateId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToRetailerFormView({
    _i38.Key? key,
    required String retailerId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.retailerFormView,
      arguments: RetailerFormViewArguments(key: key, retailerId: retailerId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToListDeliveryNoteScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.listDeliveryNoteScreen,
      arguments: ListDeliveryNoteScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToDeliveryNoteScreen({
    _i38.Key? key,
    required _i39.AddOrderModel orderData,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.deliveryNoteScreen,
      arguments: DeliveryNoteScreenArguments(key: key, orderData: orderData),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToListSelfOrderScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.listSelfOrderScreen,
      arguments: ListSelfOrderScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToCreateSelfOrderScreen({
    _i38.Key? key,
    String orderId = "",
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.createSelfOrderScreen,
      arguments: CreateSelfOrderScreenArguments(key: key, orderId: orderId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithSplashScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.splashScreen,
      arguments: SplashScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithHomePage({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.homePage,
      arguments: HomePageArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithLoginViewScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.loginViewScreen,
      arguments: LoginViewScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithGeolocation({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.geolocation,
      arguments: GeolocationArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithLocationTracker({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.locationTracker,
      arguments: LocationTrackerArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithListOrderScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.listOrderScreen,
      arguments: ListOrderScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAddOrderScreen({
    _i38.Key? key,
    required String orderid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.addOrderScreen,
      arguments: AddOrderScreenArguments(key: key, orderid: orderid),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithSalesOrderUomScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.salesOrderUomScreen,
      arguments: SalesOrderUomScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithListDistributorOrderScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.listDistributorOrderScreen,
      arguments: ListDistributorOrderScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAddDistributorOrderScreen({
    _i38.Key? key,
    required String orderId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.addDistributorOrderScreen,
      arguments: AddDistributorOrderScreenArguments(key: key, orderId: orderId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithItemScreen({
    _i38.Key? key,
    required String warehouse,
    required List<_i39.Items> items,
    required List<_i39.Items> selectedItems,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.itemScreen,
      arguments: ItemScreenArguments(
        key: key,
        warehouse: warehouse,
        items: items,
        selectedItems: selectedItems,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithLeadListScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.leadListScreen,
      arguments: LeadListScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAddLeadScreen({
    _i38.Key? key,
    required String leadId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.addLeadScreen,
      arguments: AddLeadScreenArguments(key: key, leadId: leadId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithUpdateLeadScreen({
    _i38.Key? key,
    required String updateId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.updateLeadScreen,
      arguments: UpdateLeadScreenArguments(key: key, updateId: updateId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAddQuotationView({
    _i38.Key? key,
    required String quotationid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.addQuotationView,
      arguments: AddQuotationViewArguments(key: key, quotationid: quotationid),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithListQuotationScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.listQuotationScreen,
      arguments: ListQuotationScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithQuotationItemScreen({
    _i38.Key? key,
    required List<_i40.Items> items,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.quotationItemScreen,
      arguments: QuotationItemScreenArguments(key: key, items: items),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithHolidayScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.holidayScreen,
      arguments: HolidayScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAttendanceScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.attendanceScreen,
      arguments: AttendanceScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithExpenseScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.expenseScreen,
      arguments: ExpenseScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAddExpenseScreen({
    _i38.Key? key,
    required String expenseId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.addExpenseScreen,
      arguments: AddExpenseScreenArguments(key: key, expenseId: expenseId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithListLeaveScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.listLeaveScreen,
      arguments: ListLeaveScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAddLeaveScreen({
    _i38.Key? key,
    required String leaveId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.addLeaveScreen,
      arguments: AddLeaveScreenArguments(key: key, leaveId: leaveId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithProfileScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.profileScreen,
      arguments: ProfileScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithChangePasswordScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.changePasswordScreen,
      arguments: ChangePasswordScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithCustomerList({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.customerList,
      arguments: CustomerListArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAddCustomer({
    _i38.Key? key,
    required String id,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.addCustomer,
      arguments: AddCustomerArguments(key: key, id: id),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithUpdateCustomer({
    _i38.Key? key,
    required String id,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.updateCustomer,
      arguments: UpdateCustomerArguments(key: key, id: id),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithVisitScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.visitScreen,
      arguments: VisitScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAddVisitScreen({
    _i38.Key? key,
    required String VisitId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.addVisitScreen,
      arguments: AddVisitScreenArguments(key: key, VisitId: VisitId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithUpdateVisitScreen({
    _i38.Key? key,
    required String updateId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.updateVisitScreen,
      arguments: UpdateVisitScreenArguments(key: key, updateId: updateId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithRetailerFormView({
    _i38.Key? key,
    required String retailerId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.retailerFormView,
      arguments: RetailerFormViewArguments(key: key, retailerId: retailerId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithListDeliveryNoteScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.listDeliveryNoteScreen,
      arguments: ListDeliveryNoteScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithDeliveryNoteScreen({
    _i38.Key? key,
    required _i39.AddOrderModel orderData,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.deliveryNoteScreen,
      arguments: DeliveryNoteScreenArguments(key: key, orderData: orderData),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithListSelfOrderScreen({
    _i38.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.listSelfOrderScreen,
      arguments: ListSelfOrderScreenArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithCreateSelfOrderScreen({
    _i38.Key? key,
    String orderId = "",
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.createSelfOrderScreen,
      arguments: CreateSelfOrderScreenArguments(key: key, orderId: orderId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:geolocation/model/dashboard.dart';
import 'package:geolocation/screens/comp_off_screen/list_comp_off/list_comp_off_view.dart';
import 'package:geolocation/screens/home_screen/home_view_model.dart';
import 'package:geolocation/screens/reports/main_report_list.dart';
import 'package:geolocation/screens/tour_forms/list_tour/list_tour_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:stacked/stacked.dart';

import '../../constants.dart';
import '../../router.router.dart';
import '../../widgets/drop_down.dart';
import '../Marketing Material Issue/list_marketing/list_marketing_screen.dart';
import '../attendance_request/list_attendance_request/list_attendance_request_screen.dart';
import '../attendence_screen/attendence_view.dart';
import '../holiday_screen/holiday_view.dart';
import '../profile_screen/profile_screen.dart';
import '../self_orders/list_sales_order/list_self_order_screen.dart';
import '../stock_screen/stock_screen.dart';
import '../tracking_screen/background_service.dart';
import '../tracking_screen/track_person_page.dart';
import '../sales_order/list_sales_order/list_sales_order_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _ensureTrackingAlive();
  }

  Future<void> _ensureTrackingAlive() async {
    await initializeService();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (vm) => vm.initialize(context),
      builder: (context, model, child) {
        // Wait until initial check loaded
        if (!model.checkInStatusLoaded) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (model.dashboard.isEmployee == false) {
          return DistributorHomePage();
        }
        // If NOT checked in -> show full-screen lock page
        if (!model.isCheckedIn && !model.skipCheckInScreen) {
          return CheckInLockScreen(model: model);
        }

        // Otherwise show normal dashboard
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: SafeArea(child: dashboardPage(context, model)),
        );
      },
    );
  }

  Widget dashboardPage(BuildContext context, HomeViewModel model) {
    final bool hasDashboardPermission =
    model.isFormAvailableForDocType("Dashboard");
    return RefreshIndicator(
      onRefresh: () => model.onRefresh(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Row(
            children: [
              // Logo (kept your fade-in, but wrapped + sized consistently)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // 👇 TOP ROW
                    Row(
                      children: [
                        Container(
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.business,
                            color: Colors.redAccent,
                            size: 22,
                          ),
                        ),

                        const SizedBox(width: 8),

                        // 👇 TEXT NOW USES FULL WIDTH
                        Expanded(
                          child:Text(
                            model.dashboard.company ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.visible, // 🔥 KEY
                            softWrap: false, // 🔥 IMPORTANT
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold, // 🔥 THIS MAKES IT BOLD
                            ),
                          )
                        ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    Text(
                      "Welcome back",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),
              if (model.dashboard.role.toString().toLowerCase() == "manager")
                IconButton(
                  tooltip: "Tracking",
                  icon: const Icon(Icons.my_location),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TrackPersonPage(),
                      ),
                    );
                  },
                ),
              // Profile button
            if (model.isFormAvailableForDocType("Employee"))
              Tooltip(
                message: 'Profile',
                child: InkResponse(
                  radius: 24,
                  onTap: () =>
                      Navigator.pushNamed(context, Routes.profileScreen),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.person_rounded,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Logout button
              GestureDetector(
                child: const Icon(Icons.logout),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        title: const Text('Logout'),
                        content:
                            const Text('Are you sure you want to log out?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel')),
                          TextButton(
                            onPressed: () {
                              logout(context);
                              // implement logout
                            },
                            child: const Text('Logout',
                                style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---- TOP ROW: Welcome + Date + Button ----
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Left side (Welcome + Date)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome, ${model.dashboard.empName ?? ''}!",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('EEEE, dd/MM/yyyy')
                                .format(DateTime.now()),
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),

                    /// Right side button
                    ElevatedButton(
                      onPressed: () async {

                        // bool isTrackingEnabled =
                        //     model.dashboard.trackingEnabled == true;

                        final nextType = model.isCheckedIn ? "OUT" : "IN";

                        String? meterReading;
                        File? photoFile;
                        Position? position;

                        try {
                          const settings = LocationSettings(
                            accuracy: LocationAccuracy.high,
                          );

                          await Geolocator.getCurrentPosition(
                            locationSettings: settings,
                          );
                        } catch (e) {
                          _showError(context, "Unable to get current location");
                          return;
                        }

                        // =========================
                        // 🔴 DAY-OUT LOGIC
                        // =========================
                        if (model.isCheckedIn) {

                          // 👉 TRACKING OFF → SLIDE SCREEN
                          // if (!isTrackingEnabled) {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (_) => CheckOutScreen(model: model),
                          //     ),
                          //   );
                          //   return;
                          // }

                          // 👉 TRACKING ON → FULL FLOW
                          // 1️⃣ Meter Reading
                          // print("UI isMeter = ${model.dashboard.isMeter}");
                          // print("UI isPhoto = ${model.dashboard.isPhoto}");
                          // print("UI isLocation = ${model.dashboard.isLocation}");
                          if (model.dashboard.isMeter == true) {
                            meterReading = await Navigator.push<String>(
                              context,
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (_) => MeterReadingScreen(type: nextType),
                              ),
                            );

                            if (!mounted || meterReading == null) return;
                          }



                          // 2️⃣ Photo
                          if (model.dashboard.isPhoto == true) {
                            final photoPath = await Navigator.push<String>(
                              context,
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (_) => PhotoCaptureScreen(type: nextType),
                              ),
                            );

                            if (!mounted || photoPath == null) return;

                            photoFile = File(photoPath);
                          }


                          // 3️⃣ Location
                          if (model.dashboard.isLocation == true) {
                            position = await Navigator.push<Position>(
                              context,
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (_) => LocationScreen(
                                  type: nextType,
                                  initialPosition: position,
                                ),
                              ),
                            );

                            if (!mounted || position == null) {
                              _showError(context, "Location access failed");
                              return;
                            }
                          }
                        }

                        // =========================
                        // 🟢 DAY-IN LOGIC
                        // =========================
                        else {

                          // 👉 TRACKING ON → FULL FLOW
                          // if (isTrackingEnabled) {
                            // 1️⃣ Meter Reading
                          // print("UI isMeter = ${model.dashboard.isMeter}");
                          // print("UI isPhoto = ${model.dashboard.isPhoto}");
                          // print("UI isLocation = ${model.dashboard.isLocation}");
                            if (model.dashboard.isMeter == true) {
                              meterReading = await Navigator.push<String>(
                                context,
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (_) => MeterReadingScreen(type: nextType),
                                ),
                              );

                              if (!mounted || meterReading == null) return;
                            }

                            // 2️⃣ Photo
                            if (model.dashboard.isPhoto == true) {
                              final photoPath = await Navigator.push<String>(
                                context,
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (_) => PhotoCaptureScreen(type: nextType),
                                ),
                              );

                              if (!mounted || photoPath == null) return;

                              photoFile = File(photoPath);
                            }

                            // 3️⃣ Location
                            if (model.dashboard.isLocation == true) {
                              position = await Navigator.push<Position>(
                                context,
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (_) => LocationScreen(
                                    type: nextType,
                                    initialPosition: position,
                                  ),
                                ),
                              );

                              if (!mounted || position == null) {
                                _showError(context, "Location access failed");
                                return;
                              }
                            }


                          // 👉 TRACKING OFF → DIRECT LOCATION
                          // else {
                          //   position = await Geolocator.getCurrentPosition(
                          //     desiredAccuracy: LocationAccuracy.high,
                          //   );
                          // }
                        }

                        // =========================
                        // PROCESSING SCREEN
                        // =========================
                        if (!mounted) return;

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => ProcessingScreen(type: nextType),
                        );

                        // =========================
                        // API CALL
                        // =========================
                        final success = await model.employeeLog(
                          nextType,
                          context,
                          photoFile: photoFile,
                          meterReading: meterReading,
                          position: position,
                        );

                        if (!mounted) return;
                        Navigator.pop(context);

                        // =========================
                        // RESULT MESSAGE
                        // =========================
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(success
                                ? "Employee $nextType successful"
                                : "Failed to update log"),
                            backgroundColor: success ? Colors.green : Colors.red,
                          ),
                        );

                        model.notifyListeners();
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: Text(
                        model.isCheckedIn ? "Day-Out" : "Day-In",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// ---- BOTTOM ROW: Day-In | Spend | Day-Out ----
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Day In
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            "Day In",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(model.dashboard.inTime ?? "Not Marked"),
                        ],
                      ),
                    ),

                    /// Divider
                    Container(
                        width: 1, height: 40, color: Colors.grey.shade300),

                    /// Spend
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            "Spend",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(model.spendHours),
                        ],
                      ),
                    ),

                    /// Divider
                    Container(
                        width: 1, height: 40, color: Colors.grey.shade300),

                    /// Day Out
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            "Day Out",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(model.dashboard.outTime?.isNotEmpty == true
                              ? model.dashboard.outTime!
                              : "Not Marked"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 20),
          // Container(
          //   padding: const EdgeInsets.all(16),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(16),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withOpacity(0.05),
          //         blurRadius: 10,
          //         offset: const Offset(0, 4),
          //       ),
          //     ],
          //   ),
            // child: Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Row(
            //       children: const [
            //         Icon(Icons.location_on, color: Colors.blueAccent),
            //         SizedBox(width: 8),
            //         Text(
            //           "Current Area",
            //           style: TextStyle(
            //             fontSize: 18,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ],
            //     ),
            //     const SizedBox(height: 4),
            //     const Text(
            //       "Tap to change area",
            //       style: TextStyle(
            //         fontSize: 13,
            //         color: Colors.black45,
            //       ),
            //     ),
            //     const SizedBox(height: 14),
            //     CustomDropdownButton2(
            //       value: model.selectedTerritory,
            //       items: model.territoryList,
            //       hintText: 'Select Area / Territory',
            //       onChanged: (value) {
            //         if (value != null) {
            //           model.setSelectedTerritory(value);
            //         }
            //       },
            //       validator: (value) => (value == null || value.isEmpty)
            //           ? 'Please select an area'
            //           : null,
            //       labelText: '',
            //     ),
            //   ],
            // ),


          // ---------------------------------------------------------
          // If NO Territory → Show Friendly Message, Hide Dashboard
          // ---------------------------------------------------------
          // if (model.selectedTerritory == null) ...[
          //   Center(
          //     child: Container(
          //       padding: const EdgeInsets.all(20),
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(16),
          //         boxShadow: [
          //           BoxShadow(
          //               color: Colors.black12,
          //               blurRadius: 6,
          //               offset: Offset(0, 2))
          //         ],
          //       ),
          //       child: Column(
          //         children: const [
          //           Icon(Icons.info, color: Colors.blueAccent, size: 40),
          //           SizedBox(height: 12),
          //           Text(
          //             "Please select your Territory to continue",
          //             textAlign: TextAlign.center,
          //             style:
          //                 TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          //   SizedBox(height: 40),
          // ] else ...[
            // Quick Actions + rest of dashboard content
            const Text("Quick Actions",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            SizedBox(
              height: 120, // adjust based on your card height
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: _QuickActionCard(
                      icon: Iconsax.filter_search,
                      label: "Search",
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  QuickActionGrid(model: model))),
                    ),
                  ),
                  if (model.isFormAvailableForDocType("Customer"))
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: _QuickActionCard(
                        icon: Iconsax.user_add,
                        label: "Customer",
                        onTap: () =>
                            Navigator.pushNamed(context, Routes.customerList),
                      ),
                    ),
                  if (model.isFormAvailableForDocType("Tours"))
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: _QuickActionCard(
                        icon: Iconsax.map_1,
                        label: "Tours",
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListTourScreen())),
                      ),
                    ),
                  if (model.isFormAvailableForDocType("Lead"))
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: _QuickActionCard(
                        icon: Iconsax.activity,
                        label: "Lead",
                        onTap: () => Navigator.pushNamed(
                          context,
                          Routes.leadListScreen,
                          arguments: const LeadListScreenArguments(),
                        ),
                      ),
                    ),
                  if (model.isFormAvailableForDocType("Visit"))
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: _QuickActionCard(
                        icon: Iconsax.location,
                        label: "Visit",
                        onTap: () =>
                            Navigator.pushNamed(context, Routes.visitScreen),
                      ),
                    ),
                  if (model.isFormAvailableForDocType("Quotation"))
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: _QuickActionCard(
                        icon: Iconsax.shopping_cart,
                        label: "Quotation",
                        onTap: () => Navigator.pushNamed(
                            context, Routes.listQuotationScreen),
                      ),
                    ),
                  if (model.isFormAvailableForDocType("Expense Claim"))
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: _QuickActionCard(
                        icon: Iconsax.wallet,
                        label: "Expense",
                        onTap: () =>
                            Navigator.pushNamed(context, Routes.expenseScreen),
                      ),
                    ),
                  if (model.isFormAvailableForDocType("Leave Application"))
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: _QuickActionCard(
                        icon: Iconsax.briefcase,
                        label: "Leaves",
                        onTap: () => Navigator.pushNamed(
                            context, Routes.listLeaveScreen),
                      ),
                    ),
                  // if (model.isFormAvailableForDocType("Delivery Note"))
                  //   Padding(
                  //     padding: const EdgeInsets.only(right: 16.0),
                  //     child: _QuickActionCard(
                  //       icon: Iconsax.box,
                  //       label: "Delivery",
                  //       onTap: () => Navigator.pushNamed(
                  //           context, Routes.listDeliveryNoteScreen),
                  //     ),
                  //   ),

                  if (model.isFormAvailableForDocType("Stock Entry"))
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: _QuickActionCard(
                        icon: Iconsax.graph,
                        label: "Actual Stock",
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ItemStockScreen())),
                      ),
                    ),

                  // Padding(
                  //   padding: const EdgeInsets.only(right: 16.0),
                  //   child: _QuickActionCard(
                  //     icon: Iconsax.receipt,
                  //     label: "Report",
                  //     onTap: () => Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => ReportsPage())),
                  //   ),
                  // ),
                ],
              ),
            ),
            CurrentLocationMapCard(),

            const SizedBox(height: 16),

            // Sales Dashboard
          if (hasDashboardPermission) ...[
            const Text(
              "Visit & Tour Dashboard",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "The Visit & Tour",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Icon(
                        Iconsax.trend_up,
                        color: Colors.green,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  weeklySummary(model.weekData),
                  const SizedBox(height: 16),
                  weeklyBarChart(model.weekData),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
          const SizedBox(height: 24),


            /// ===== MONTH SUMMARY =====
            Text(
              "This Month Summary",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            itemCount: hasDashboardPermission ? 6 : 2,

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
            ),

            itemBuilder: (context, index) {

              final summaries = hasDashboardPermission
                  ? [
                {
                  "title": "Visits",
                  "value": model.monthlySummary.visit?.total.toString() ?? "0",
                },
                {
                  "title": "Attendance",
                  "value": model.monthlySummary.attendance?.total ?? 0,
                },
                {
                  "title": "Leaves",
                  "value": model.monthlySummary.leave?.total ?? 0,
                },
                {
                  "title": "Orders",
                  "value": model.monthlySummary.orders?.total ?? 0,
                },
                {
                  "title": "Leads",
                  "value": model.monthlySummary.leads?.total.toString() ?? "0",
                },
                {
                  "title": "Tours",
                  "value": model.monthlySummary.tours?.total.toString() ?? "0",
                },
              ]
                  : [
                {
                  "title": "Attendance",
                  "value": model.monthlySummary.attendance?.total ?? 0,
                },
                {
                  "title": "Leaves",
                  "value": model.monthlySummary.leave?.total ?? 0,
                },
              ];

              final summary = summaries[index];

              return MonthSummary(
                title: summary["title"].toString(),
                value: int.tryParse(summary["value"].toString()) ?? 0,
              );
            },
          ),

        ]),
      ),
    );
  }

  void _showError(BuildContext c, String msg) {
    ScaffoldMessenger.of(c).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));
  }

  Widget weeklyBarChart(List<SalesPerson> data) {
    if (data.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            "No data for this week",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final maxY = data
            .map((e) => (e.visitCount ?? 0) + (e.tourCount ?? 0))
            .fold<int>(0, (prev, el) => el > prev ? el : prev)
            .toDouble() +
        1;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          barTouchData: BarTouchData(enabled: true),
          gridData: FlGridData(show: true, horizontalInterval: 1),
          borderData: FlBorderData(show: false),
          barGroups: data.asMap().entries.map((e) {
            final day = DateTime.parse(e.value.date!).weekday;

            return BarChartGroupData(
              x: day,
              barsSpace: 6,
              barRods: [
                BarChartRodData(
                  toY: (e.value.visitCount ?? 0).toDouble(),
                  width: 7,
                  color: Colors.blue.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: (e.value.tourCount ?? 0).toDouble(),
                  width: 7,
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = [
                    "",
                    "Mon",
                    "Tue",
                    "Wed",
                    "Thu",
                    "Fri",
                    "Sat",
                    "Sun"
                  ];
                  return Text(
                    days[value.toInt()],
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }

  Widget weeklySummary(List<SalesPerson> data) {
    final totalVisits =
        data.fold<int>(0, (sum, e) => sum + (e.visitCount ?? 0));
    final totalTours = data.fold<int>(0, (sum, e) => sum + (e.tourCount ?? 0));

    return Row(
      children: [
        _summaryCard(
          title: "Visits",
          value: totalVisits.toString(),
          color: Colors.blue.shade400,
        ),
        const SizedBox(width: 12),
        _summaryCard(
          title: "Tours",
          value: totalTours.toString(),
          color: Colors.blue.shade100,
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            Text(value,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class MonthSummary extends StatelessWidget {
  final String title;
  final int value;

  const MonthSummary({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// VALUE
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),

          const SizedBox(height: 6),

          /// TITLE
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 4),

          /// SUB TEXT
          const Text(
            "Total Count",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class QuickActionGrid extends StatefulWidget {
  final dynamic model;

  const QuickActionGrid({super.key, required this.model});

  @override
  State<QuickActionGrid> createState() => _QuickActionGridState();
}

class _QuickActionGridState extends State<QuickActionGrid>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _anim;

  Map<String, List<Map<String, dynamic>>> sections = {};
  List<Map<String, dynamic>> allActionsFlat = [];

  @override
  void initState() {
    super.initState();

    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.92,
      upperBound: 1.0,
    );

    _buildSections();
  }

  void _buildSections() {
    // SALES
    List<Map<String, dynamic>> sales = [
      if (widget.model.isFormAvailableForDocType("Customer"))
        {
          "label": "Customer",
          "icon": Iconsax.user_add,
          "route": Routes.customerList
        },
      if (widget.model.isFormAvailableForDocType("Lead"))
        {
          "label": "Lead",
          "icon": Iconsax.activity,
          "route": Routes.leadListScreen
        },
      if (widget.model.isFormAvailableForDocType("Quotation"))
        {
          "label": "Quotation",
          "icon": Iconsax.shopping_cart,
          "route": Routes.listQuotationScreen
        },
      if (widget.model.isFormAvailableForDocType("Sales Order"))
        {
          "label": "Sales Order",
          "icon": Iconsax.shopping_cart,
          "route": Routes.listOrderScreen
        },
      // if (widget.model.isFormAvailableForDocType("Delivery Note"))
      //   {
      //     "label": "Delivery",
      //     "icon": Iconsax.box,
      //     "route": Routes.listDeliveryNoteScreen
      //   },
      if (widget.model.isFormAvailableForDocType("Visit"))
        {
          "label": "Visit",
          "icon": Iconsax.location,
          "route": Routes.visitScreen,
        },
    ];

    // HR
    List<Map<String, dynamic>> hr = [
      if (widget.model.isFormAvailableForDocType("Leave Application"))
        {
          "label": "Leaves",
          "icon": Iconsax.briefcase,
          "route": Routes.listLeaveScreen
        },
      if (widget.model.isFormAvailableForDocType("Attendance"))
        {
          "label": "Attendance",
          "icon": Iconsax.calendar,
          "screen": AttendanceScreen()
        },
      if (widget.model.isFormAvailableForDocType("Compensatory Leave Request"))
        {
          "label": "Comp off Request",
          "icon": Iconsax.receipt_add,
          "screen": ListCompOffView()
        },
      if (widget.model.isFormAvailableForDocType("Attendance Request"))
        {
          "label": "Attendance Request",
          "icon": Iconsax.document_text,
          "screen": AttendanceRequestScreen()
        },
      if (widget.model.isFormAvailableForDocType("Expense Claim"))
        {
          "label": "Expense",
          "icon": Iconsax.wallet,
          "route": Routes.expenseScreen
        },
      if (widget.model.isFormAvailableForDocType("Holiday List"))
        {
          "label": "Holiday",
          "icon": Iconsax.calendar_search5,
          "screen": HolidayScreen()
        },
      if (widget.model.isFormAvailableForDocType("Employee"))
        {
          "label": "Profile",
          "icon": Iconsax.personalcard,
          "screen": ProfileScreen()
        },
    ];

    // OPERATIONS
    List<Map<String, dynamic>> operations = [
      if (widget.model.isFormAvailableForDocType("Stock Entry"))
        {"label": "Stock", "icon": Iconsax.graph, "screen": ItemStockScreen()},
      if (widget.model.isFormAvailableForDocType("Marketing Material Issue"))
        {
          "label": "Merchandise",
          "icon": Iconsax.shopping_cart,
          "screen": MarketingListScreen()
        },
      if (widget.model.isFormAvailableForDocType("Tours"))
        {
          "label": "Tours",
          "icon": Iconsax.calendar,
          "screen": ListTourScreen(),
        },
      if (widget.model.isFormAvailableForDocType("Reports"))
        {
          "label": "Reports",
          "icon": Iconsax.receipt,
          "screen": ReportsPage(),
        },
    ];

    sections = {
      "Sales": sales,
      "HR": hr,
      "Operations": operations,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Options")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildSectionView(),
            ],
          ),
        ),
      ),
    );
  }

  // SEARCH BAR
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: "Search actions...",
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(14),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  // SECTION VIEW — FIXED (NO LISTVIEW!)
  Widget _buildSectionView() {
    final query = _searchController.text.toLowerCase();

    return Column(
      children: [
        for (var entry in sections.entries)
          if (_hasVisibleItems(entry.value, query))
            _buildSectionCard(entry.key, entry.value, query),
      ],
    );
  }

  bool _hasVisibleItems(List<Map<String, dynamic>> list, String query) =>
      list.any((a) => a["label"].toLowerCase().contains(query));

  // SECTION CARD
  Widget _buildSectionCard(
      String title, List<Map<String, dynamic>> items, String query) {
    final filtered =
        items.where((a) => a["label"].toLowerCase().contains(query)).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Container(height: 1, color: Colors.black12),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (_, i) => _buildActionButton(filtered[i]),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        if (item["route"] != null) {
          Navigator.pushNamed(context, item["route"]);
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => item["screen"]));
        }
      },
      child: Column(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueAccent.withOpacity(.1),
              border: Border.all(color: Colors.blueAccent.withOpacity(.3)),
            ),
            child: Icon(item["icon"], color: Colors.blueAccent, size: 28),
          ),
          const SizedBox(height: 6),
          AutoSizeText(
            item["label"],
            textAlign: TextAlign.center,
            minFontSize: 10,
            style: const TextStyle(
              fontSize: 11, // 👈 smaller text
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
          )
        ],
      ),
    );
  }
}

// -----------------------------
// CHECK-IN LOCK SCREEN
// -----------------------------
class CheckInLockScreen extends StatefulWidget {
  final HomeViewModel model;
  const CheckInLockScreen({super.key, required this.model});

  @override
  State<CheckInLockScreen> createState() => _CheckInLockScreenState();
}

class _CheckInLockScreenState extends State<CheckInLockScreen> {
  final GlobalKey<SlideActionState> _slideKey = GlobalKey();
  bool _processing = false;

  @override
  void dispose() {
    _processing = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔒 Animated Glass Icon
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.85, end: 1),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: Container(
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.28),
                        Colors.white.withOpacity(0.08),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_clock_rounded,
                    size: 96,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Slide to check-in and start your workday",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.4,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),

              const SizedBox(height: 44),

              // 🟢 SLIDE TO CHECK-IN
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(4),
                child: SwipeToConfirm(
                  processing: _processing,
                  text: "Slide to Check-In 🌟",
                  onConfirm: () => _handleCheckIn(context),
                ),
              ),


              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    widget.model.skipCheckInScreen = true;
                    widget.model.notifyListeners();
                  },
                  icon: const Icon(Icons.dashboard_outlined),
                  label: const Text(
                    "Go To Dashboard",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(
                      color: Colors.white,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= CHECK-IN FLOW =================

  Future<void> _handleCheckIn(BuildContext context) async {
    const nextType = "IN";
    if (_processing) return;

    setState(() {
      _processing = true;
    });

    try {
      // 🔥 CHECK TRACKING FIRST
      bool isTrackingEnabled =
          widget.model.dashboard.trackingEnabled == true;

      String? meterReading;
      File? photoFile;
      Position? position;


      // Always fetch GPS once
      try {
        const settings = LocationSettings(
          accuracy: LocationAccuracy.high,
        );

        await Geolocator.getCurrentPosition(
          locationSettings: settings,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Unable to get current location"),
          ),
        );
        return;
      }

      // =========================
      // ✅ IF TRACKING ENABLED
      // =========================

        // 1️⃣ Meter reading
        if (widget.model.dashboard.isMeter == true) {
          meterReading = await Navigator.push<String>(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => MeterReadingScreen(type: nextType),
            ),
          );

          if (!mounted || meterReading == null) return;
        }


        // 2️⃣ Photo
        if (widget.model.dashboard.isPhoto == true) {
          final photoPath = await Navigator.push<String>(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => PhotoCaptureScreen(type: nextType),
            ),
          );

          if (!mounted || photoPath == null) return;

          photoFile = File(photoPath);
        }
        // 3️⃣ Location
      if (widget.model.dashboard.isLocation == true) {
        position = await Navigator.push<Position>(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => LocationScreen(
              type: nextType,
              initialPosition: position,   // <-- pass existing position
            ),
          ),
        );

        if (!mounted || position == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location access failed")),
          );
          return;
        }
      }


      // =========================
      // 🚀 IF TRACKING DISABLED
      // =========================


      // =========================
      // API CALL
      // =========================
      final success = await widget.model.employeeLog(
        "IN",
        context,
        photoFile: photoFile,
        meterReading: meterReading,
        position: position,
      );
      // print("CHECKIN SUCCESS: $success");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text(success ? "Check-in successful ✅" : "Check-in failed ❌"),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      _reset();
    }
  }

  void _reset() {
    if (!mounted) return;

    try {
      _slideKey.currentState?.reset();
    } catch (e, stack) {
      debugPrint("SlideAction reset skipped: $e\n$stack");
    }

    if (mounted) {
      setState(() => _processing = false);
    }
  }
}

class CheckOutScreen extends StatefulWidget {
  final HomeViewModel model;

  const CheckOutScreen({super.key, required this.model});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  bool _processing = false;

  Future<void> _handleCheckOut() async {
    if (_processing) return;

    setState(() => _processing = true);

    try {
      bool isTrackingEnabled =
          widget.model.dashboard.trackingEnabled == true;

      Position? position;


        position = await Navigator.push<Position>(
          context,
          MaterialPageRoute(
            builder: (_) => const LocationScreen(type: "OUT"),
          ),
        );

        if (!mounted) return;

        if (position == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location not found")),
          );
          return;
        }


      if (position == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location not found")),
        );
        return;
      }

      final success = await widget.model.employeeLog(
        "OUT",
        context,
        photoFile: null,
        meterReading: null,
        position: position!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? "Check-out successful ✅"
              : "Check-out failed ❌"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      print(e);
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE53935), Color(0xFFEF5350)], // 🔴 red theme
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔓 Icon (changed from lock to logout)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.85, end: 1),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: Container(
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.28),
                        Colors.white.withOpacity(0.08),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.logout_rounded, // 🔥 changed icon
                    size: 96,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                "Ready to Wrap Up?",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Slide to check-out and end your workday",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.4,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),

              const SizedBox(height: 44),

              // 🔴 SLIDE TO CHECK-OUT
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(4),
                child: SwipeToConfirm(
                  processing: _processing,
                  text: "Slide to Check-Out 🔚", // 🔥 changed text
                  onConfirm: _handleCheckOut,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SwipeToConfirm extends StatefulWidget {
  final VoidCallback onConfirm;
  final bool processing;
  final String text;

  const SwipeToConfirm({
    super.key,
    required this.onConfirm,
    required this.processing,
    this.text = "Slide to Check-In",
  });

  @override
  State<SwipeToConfirm> createState() => _SwipeToConfirmState();
}

class _SwipeToConfirmState extends State<SwipeToConfirm> {
  double _dragX = 0;
  final double _buttonSize = 52;

  @override
  Widget build(BuildContext context) {
    final maxDrag = MediaQuery.of(context).size.width - _buttonSize - 64;

    return Container(
      height: 60,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // 📝 Text
          Center(
            child: widget.processing
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  )
                : Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),

          // 👉 Draggable button
          Positioned(
            left: _dragX,
            child: GestureDetector(
              onHorizontalDragUpdate: widget.processing
                  ? null
                  : (details) {
                      setState(() {
                        _dragX += details.delta.dx;
                        _dragX = _dragX.clamp(0, maxDrag);
                      });
                    },
              onHorizontalDragEnd: widget.processing
                  ? null
                  : (_) {
                      if (_dragX >= maxDrag * 0.9) {
                        widget.onConfirm();
                      }
                      setState(() => _dragX = 0);
                    },
              child: Container(
                height: _buttonSize,
                width: _buttonSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.login,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------
// METER READING SCREEN
// -----------------------------

// ─── Meter Reading Screen ─────────────────────────────────────────────────────

class MeterReadingScreen extends StatefulWidget {
  final String type;
  const MeterReadingScreen({super.key, required this.type});

  @override
  State<MeterReadingScreen> createState() => _MeterReadingScreenState();
}

class _MeterReadingScreenState extends State<MeterReadingScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animCtrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  bool _hasValue = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _hasValue = _controller.text.isNotEmpty);
    });
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _fade = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.07),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest,
      body: Column(
        children: [
          _buildHeader(cs),
          Expanded(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                  child: _buildCard(cs),
                ),
              ),
            ),
          ),
          _buildBottomBar(cs),
        ],
      ),
    );
  }

  // ── Gradient header ──────────────────────────────────────────────────────────

  Widget _buildHeader(ColorScheme cs) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              right: -24,
              top: -16,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.07),
                ),
              ),
            ),
            Positioned(
              right: 48,
              top: 28,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.07),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 20),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.type,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Text(
                          "Meter Reading",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.speed_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Main card ────────────────────────────────────────────────────────────────

  Widget _buildCard(ColorScheme cs) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header strip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.05),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      Icon(Icons.speed_rounded, color: cs.onPrimary, size: 18),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current Reading",
                      style: TextStyle(
                        fontSize: 11,
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      "Enter odometer value",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Input + helper
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Large input
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color:
                          _hasValue ? cs.primary.withOpacity(0.5) : cs.outline,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                            letterSpacing: -0.5,
                          ),
                          decoration: InputDecoration(
                            hintText: "0",
                            hintStyle: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurfaceVariant.withOpacity(0.3),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                      // Unit badge
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: cs.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "km",
                          style: TextStyle(
                            color: cs.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Helper text
                Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 13,
                      color: cs.onSurfaceVariant.withOpacity(0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Enter the current vehicle odometer reading",
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom bar ───────────────────────────────────────────────────────────────

  Widget _buildBottomBar(ColorScheme cs) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outline)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed:
              _hasValue ? () => Navigator.pop(context, _controller.text) : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: cs.primary,
            disabledBackgroundColor: cs.surfaceContainerHighest,
            disabledForegroundColor: cs.onSurfaceVariant,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Next",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: cs.onPrimary,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, color: cs.onPrimary, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------
// PHOTO CAPTURE SCREEN (returns path String)
// -----------------------------

class PhotoCaptureScreen extends StatefulWidget {
  final String type;
  const PhotoCaptureScreen({super.key, required this.type});

  @override
  _PhotoCaptureScreenState createState() => _PhotoCaptureScreenState();
}

class _PhotoCaptureScreenState extends State<PhotoCaptureScreen> {
  final ImagePicker picker = ImagePicker();
  File? photo;
  bool isCapturing = true;

  @override
  void initState() {
    super.initState();
    // Launch camera after small delay
    Future.delayed(const Duration(milliseconds: 300), capturePhoto);
  }

  Future<void> capturePhoto() async {
    setState(() => isCapturing = true);

    try {
      final picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 1280,
      );

      if (!mounted) return;

      if (picked != null) {
        photo = File(picked.path);
        // Return path to previous screen
        Navigator.pop(context, picked.path);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to capture photo: $e")),
      );
    } finally {
      setState(() => isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Capture Photo (${widget.type})",
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: photo != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(photo!, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Colors.blueAccent),
                  SizedBox(height: 16),
                  Text(
                    "Opening Camera...",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ],
              ),
      ),
      floatingActionButton: photo == null
          ? FloatingActionButton(
              onPressed: capturePhoto,
              backgroundColor: Colors.blueAccent,
              child:
                  const Icon(Icons.camera_alt, color: Colors.white, size: 32),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// -----------------------------
// LOCATION SCREEN (returns Position)
// -----------------------------
class LocationScreen extends StatefulWidget {
  final String type;
  final Position? initialPosition; // optional pre-fetched position

  const LocationScreen({super.key, required this.type, this.initialPosition});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Position? pos;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    // Use initial position if provided
    if (widget.initialPosition != null) {
      pos = widget.initialPosition;
      loading = false;
      _fetchFreshLocation(); // still update in background
    } else {
      _fetchLocation();
    }
  }

  Future<void> _fetchLocation() async {
    try {
      // 1️⃣ Check location service
      if (!await Geolocator.isLocationServiceEnabled()) {
        await Geolocator.openLocationSettings();
        return;
      }

      // 2️⃣ Check permissions
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied")),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "Location permission permanently denied.\nEnable it from settings.")),
        );
        await Geolocator.openAppSettings();
        return;
      }

      // 3️⃣ Try last known position first (fast)
      pos = await Geolocator.getLastKnownPosition();

      // 4️⃣ Immediately show last known position if available
      if (pos != null) {
        setState(() => loading = false);
      }

      // 5️⃣ Fetch fresh high-accuracy position
      await _fetchFreshLocation();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to get location: $e")));
    }
  }

  Future<void> _fetchFreshLocation() async {
    try {
      final freshPos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      pos = freshPos;
      if (mounted) setState(() => loading = false);
    } catch (e) {
      if (mounted) setState(() => loading = false);
    }
  }

  GoogleMapController? _mapController;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("${widget.type} - Location",
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              // Map
              if (pos != null)
                GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(pos!.latitude, pos!.longitude),
                    zoom: 16,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId("me"),
                      position: LatLng(pos!.latitude, pos!.longitude),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    ),
                  },
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  onMapCreated: (controller) => _mapController = controller,
                ),
              // Loading overlay
              if (loading)
                const Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent),
                ),
              // Coordinates card (bottom of map)
              if (pos != null)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cs.outline),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: cs.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.location_on_rounded,
                            color: cs.primary,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Current Location",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${pos!.latitude.toStringAsFixed(5)}, ${pos!.longitude.toStringAsFixed(5)}",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Accuracy badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "±${pos!.accuracy.toStringAsFixed(0)}m",
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            MediaQuery.of(context).padding.bottom + 16,
          ),
          decoration: BoxDecoration(
            color: cs.surface,
            border: Border(top: BorderSide(color: cs.outline)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: pos != null ? () => Navigator.pop(context, pos) : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: cs.primary,
                disabledBackgroundColor: cs.surfaceContainerHighest,
                disabledForegroundColor: cs.onSurfaceVariant,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Confirm Location",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: cs.onPrimary,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.check_rounded, color: cs.onPrimary, size: 18),
                ],
              ),
            ),
          ),
        ));
  }
}

// -----------------------------
// PROCESSING SCREEN (modal)
// -----------------------------
class ProcessingScreen extends StatelessWidget {
  final String type;

  const ProcessingScreen({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.55),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 24,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 42,
                width: 42,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                "Processing $type",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Please wait…",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              child: Icon(icon, size: 28, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 13)),
          ],
        ));
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class CurrentLocationMapCard extends StatefulWidget {
  const CurrentLocationMapCard({super.key});

  @override
  State<CurrentLocationMapCard> createState() => _CurrentLocationMapCardState();
}

class _CurrentLocationMapCardState extends State<CurrentLocationMapCard> {
  GoogleMapController? _mapController;
  StreamSubscription<Position>? _sub;

  LatLng? _position;
  DateTime? _fetchedAt;

  bool _loading = true;
  String? _error;

  // ✅ Throttle UI updates (prevents excessive setState)
  DateTime _lastUiUpdate = DateTime.fromMillisecondsSinceEpoch(0);
  static const _uiUpdateGap = Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    _initAndTrack();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initAndTrack() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception("Location services are disabled");

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied");
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permission permanently denied");
      }

      // NOTE: Show last known position quickly for slow networks/GPS.
      Position? lastKnown;
      try {
        lastKnown = await Geolocator.getLastKnownPosition();
      } catch (_) {}

      if (lastKnown != null && mounted) {
        setState(() {
          _position = LatLng(lastKnown!.latitude, lastKnown!.longitude);
          _fetchedAt = DateTime.now();
          _loading = false;
          _error = null;
        });
      }

      // NOTE: Get a fresh fix; keep last known if this times out.
      Position? first;
      try {


        const settings = LocationSettings(
          accuracy: LocationAccuracy.high,
        );

        await Geolocator.getCurrentPosition(
          locationSettings: settings,
        );
      } catch (_) {
        if (lastKnown == null) {
          throw Exception("Unable to get location");
        }
      }

      if (first != null && mounted) {
        setState(() {
          _position = LatLng(first!.latitude, first.longitude);
          _fetchedAt = DateTime.now();
          _loading = false;
          _error = null;
        });
      }

      // ✅ Start listening, but not too frequently
      await _sub?.cancel();

      const settings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // ✅ updates only after 10 meters movement
      );

      _sub = Geolocator.getPositionStream(locationSettings: settings).listen(
        (pos) {
          final now = DateTime.now();
          // ✅ throttle UI rebuilds
          if (now.difference(_lastUiUpdate) < _uiUpdateGap) return;
          _lastUiUpdate = now;

          if (!mounted) return;
          setState(() {
            _position = LatLng(pos.latitude, pos.longitude);
            _fetchedAt = now;
          });
        },
        onError: (e) {
          if (!mounted) return;
          setState(() {
            _error = e.toString();
          });
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
        _position = null;
        _fetchedAt = null;
      });
    }
  }

  String _formatTime(DateTime dt) => DateFormat('dd MMM, hh:mm a').format(dt);

  Future<void> _recenter() async {
    if (_position == null || _mapController == null) return;
    await _mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(_position!, 16),
    );
  }

  void _openFullMap(BuildContext context) {
    if (_position == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullMapView(
          lat: _position!.latitude,
          lng: _position!.longitude,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const Icon(Icons.my_location, color: Colors.blueAccent),
                const SizedBox(width: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: _position == null ? null : () => _openFullMap(context),
                  child: Text(
                    "Current Location",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                if (_fetchedAt != null)
                  Text(
                    _formatTime(_fetchedAt!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black45,
                    ),
                  ),
                const SizedBox(width: 6),
                IconButton(
                  tooltip: "Recenter",
                  onPressed: _recenter,
                  icon: const Icon(Icons.center_focus_strong, size: 20),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 180,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : (_position == null)
                      ? _LocationUnavailable(
                          message: _error ??
                              "Unable to fetch current location right now.",
                          onRetry: _initAndTrack,
                        )
                      : GoogleMap(
                          onMapCreated: (c) => _mapController = c,
                          initialCameraPosition: CameraPosition(
                            target: _position!,
                            zoom: 16,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId("current"),
                              position: _position!,
                            ),
                          },
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          compassEnabled: false,
                          mapToolbarEnabled: false,
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationUnavailable extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _LocationUnavailable({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.all(14),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off, size: 30, color: Colors.black45),
            const SizedBox(height: 10),
            Text(
              message.replaceFirst("Exception: ", ""),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleMapWidget extends StatelessWidget {
  final LatLng position;

  const GoogleMapWidget({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: position,
        zoom: 16,
      ),
      markers: {
        Marker(
          markerId: const MarkerId("current"),
          position: position,
        ),
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
    );
  }
}

class FullMapView extends StatelessWidget {
  final double lat;
  final double lng;

  const FullMapView({super.key, required this.lat, required this.lng});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pos = LatLng(lat, lng);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Current Location"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: pos,
          zoom: 17,
        ),

        // ✅ UX / polish
        mapType: MapType.hybrid,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        compassEnabled: true,
        mapToolbarEnabled: true,

        // ✅ marker for current point
        markers: {
          Marker(
            markerId: const MarkerId("current"),
            position: pos,
            infoWindow: const InfoWindow(title: "Current Location"),
          ),
        },
      ),

      // Optional bottom action (open in map apps, share, etc. later)
      // bottomNavigationBar: SafeArea(
      //   child: Padding(
      //     padding: const EdgeInsets.all(12),
      //     child: FilledButton.icon(
      //       onPressed: () {},
      //       icon: const Icon(Icons.share),
      //       label: const Text("Share Location"),
      //     ),
      //   ),
      // ),
    );
  }
}

class DistributorHomePage extends StatelessWidget {
  const DistributorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (vm) => vm.initialize(context),
      builder: (context, model, child) {
        final dashboard = model.dashboard;

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6FA),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => model.onRefresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 18),
                    _DistributorBannerCard(
                      name: dashboard.empName ?? "Distributor",
                      company: dashboard.company ?? "",
                      email: dashboard.email ?? "",
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      "Quick Actions",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.05,
                      children: [
                        _DistributorActionCard(
                          icon: Iconsax.shopping_cart,
                          label: "Assigned Orders",
                          subtitle: "Orders assigned to you",
                          color: const Color(0xFF2563EB),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.listDistributorOrderScreen,
                            );
                          },
                        ),
                        _DistributorActionCard(
                          icon: Iconsax.shopping_cart,
                          label: "My Orders",
                          subtitle: "Orders created by you",
                          color: const Color(0xFF7C3AED),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.listSelfOrderScreen,
                            );
                          },
                        ),
                        _DistributorActionCard(
                          icon: Iconsax.box,
                          label: "Delivery Note",
                          subtitle: "Manage deliveries",
                          color: const Color(0xFFF59E0B),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.listDeliveryNoteScreen,
                            );
                          },
                        ),
                        _DistributorActionCard(
                          icon: Iconsax.graph,
                          label: "Actual Stock",
                          subtitle: "View available stock",
                          color: const Color(0xFF10B981),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ItemStockScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Management Shortcuts",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _ShortcutTile(
                            icon: Iconsax.shopping_cart,
                            title: "Assigned Orders",
                            subtitle: "Orders assigned to you",
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.listDistributorOrderScreen,
                              );
                            },
                          ),
                          const Divider(height: 20),
                          _ShortcutTile(
                            icon: Iconsax.box,
                            title: "My Orders",
                            subtitle: "Orders created by you",
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.listSelfOrderScreen,
                              );
                            },
                          ),
                          const Divider(height: 20),
                          _ShortcutTile(
                            icon: Iconsax.box,
                            title: "Delivery Notes",
                            subtitle: "View and manage delivery workflow",
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.listDeliveryNoteScreen,
                              );
                            },
                          ),
                          const Divider(height: 20),
                          _ShortcutTile(
                            icon: Iconsax.graph,
                            title: "Stock Position",
                            subtitle: "Check available item stock",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ItemStockScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 40,
          child: Image.asset(
            'assets/images/Logo D CMYK.png',
            width: 120,
            fit: BoxFit.contain,
          ),
        ),
        const Spacer(),
        InkResponse(
          radius: 24,
          onTap: () =>
              Navigator.pushNamed(context, Routes.changePasswordScreen),
          child: CircleAvatar(
            radius: 19,
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.password_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                title: const Text('Logout'),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      logout(context);
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            );
          },
          child: const Icon(Icons.logout),
        ),
      ],
    );
  }
}

class _DistributorBannerCard extends StatelessWidget {
  final String name;
  final String company;
  final String email;

  const _DistributorBannerCard({
    required this.name,
    required this.company,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.22),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.shop,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  company,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.92),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.84),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DistributorActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _DistributorActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: color.withOpacity(0.12),
                  child: Icon(
                    icon,
                    color: color,
                    size: 25,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ShortcutTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFEEF2FF),
              child: Icon(icon, color: const Color(0xFF2563EB), size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}

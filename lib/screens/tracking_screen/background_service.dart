import 'dart:async';
import 'dart:convert';

import 'package:android_id/android_id.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'company_auth.dart';

Timer? queueTimer;
StreamSubscription<Position>? positionStream;
Timer? streamRestartTimer;
bool streamStarted = false;

/// =======================================================
/// INITIALIZE SERVICE (SAFE RESTART)
/// =======================================================
Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  final prefs = await SharedPreferences.getInstance();
  bool isCheckedIn = prefs.getBool("is_checked_in") ?? false;

  if (!isCheckedIn) {
    print("❌ Not checked-in → service will NOT start");
    return;
  }

  bool isRunning = await service.isRunning();
  if (isRunning) {
    print("Service already running → restart safe");

    await Future.delayed(const Duration(seconds: 1));
    return;
  }

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      foregroundServiceTypes: [
        AndroidForegroundType.location,
      ],
      foregroundServiceNotificationId: 999,
      initialNotificationTitle: "Android_Sanpra",
      initialNotificationContent: ".",
    ),
    iosConfiguration: IosConfiguration(),
  );

  await service.startService();

  print("SERVICE STARTED CLEAN");
}

/// =======================================================
/// MAIN BACKGROUND START
/// =======================================================
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {

  final prefs = await SharedPreferences.getInstance();
  bool isCheckedIn = prefs.getBool("is_checked_in") ?? false;

  if (!isCheckedIn) {
    print("❌ Service started but user not checked-in → stopping");
    service.stopSelf();
    return;
  }

  try {
    if (service is AndroidServiceInstance) {
      service.setAsForegroundService();
      service.setForegroundNotificationInfo(
        title: "Android_sanpra",
        content: ".",
      );
    }

    service.on("stopService").listen((event) {
      positionStream?.cancel();
      positionStream = null;

      queueTimer?.cancel();
      queueTimer = null;

      streamRestartTimer?.cancel();
      streamRestartTimer = null;
      streamStarted = false;

      service.stopSelf();
    });

    service.on("setAsForeground").listen((event) {
      if (service is AndroidServiceInstance) {
        service.setAsForegroundService();
      }
    });

    final Battery battery = Battery();
    const androidIdPlugin = AndroidId();

    String deviceId = await androidIdPlugin.getId() ?? "Unknown";

    /// START QUEUE
    startQueueProcessor();

    /// INITIAL LOCATION
    Position initialPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    await handleLocationUpdate(
      service: service,
      batteryPlugin: battery,
      deviceId: deviceId,
      position: initialPosition,
    );

    /// START LIVE LOCATION STREAM
    startLocationStream(
      service,
      battery,
      deviceId,
    );

    // ⭐ SOFT RESTART every 30 seconds
    streamRestartTimer?.cancel();

    streamRestartTimer = Timer.periodic(
      const Duration(minutes: 2),
      (timer) {
        positionStream?.cancel();
        streamStarted = false;

        startLocationStream(
          service,
          battery,
          deviceId,
        );
      },
    );
  } catch (e) {
    print("SERVICE CRASH: $e");
  }
}

/// =======================================================
/// LOCATION STREAM
/// =======================================================
void startLocationStream(
  ServiceInstance service,
  Battery battery,
  String deviceId,
) {
  if (streamStarted) {
    print("Stream already running → skip");
    return;
  }

  streamStarted = true;

  // stop old stream safely
  positionStream?.cancel();

  print("Starting NEW location stream");

  positionStream = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 20, // update only when moved 5m
    ),
  ).listen((Position position) async {
    await handleLocationUpdate(
      service: service,
      batteryPlugin: battery,
      deviceId: deviceId,
      position: position,
    );
  });
}

/// =======================================================
/// HANDLE LOCATION UPDATE
/// =======================================================
Future<void> handleLocationUpdate({
  required ServiceInstance service,
  required Battery batteryPlugin,
  required String deviceId,
  required Position position,
}) async {
  final prefs = await SharedPreferences.getInstance();

  int batteryLevel = await batteryPlugin.batteryLevel;

  DateTime now = DateTime.now().toUtc();

  String timestamp =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} "
      "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

  service.invoke("update", {
    "latitude": position.latitude,
    "longitude": position.longitude,
    "battery": batteryLevel,
    "timestamp": timestamp,
    "device_id": deviceId,
  });

  await prefs.setDouble("my_lat", position.latitude);
  await prefs.setDouble("my_lng", position.longitude);
  await prefs.setInt("my_battery", batteryLevel);
  await prefs.setString("my_timestamp", timestamp);
  await prefs.setString("my_device_id", deviceId);

  String liveUser = prefs.getString("user") ?? "";

  if (liveUser.isEmpty) {
    print("EMAIL MISSING → skipping API only");
    return;
  }

  await addToQueue({
    "user": liveUser,
    "android_id": deviceId,
    "battery": batteryLevel,
    "latitude": position.latitude,
    "longitude": position.longitude,
    "timestamp": timestamp,
  });
}

/// =======================================================
/// QUEUE SYSTEM
/// =======================================================
Future<void> addToQueue(Map<String, dynamic> data) async {
  final prefs = await SharedPreferences.getInstance();

  List<String> queue = prefs.getStringList("location_queue") ?? [];

  if (queue.length > 100) queue.removeAt(0);

  queue.add(jsonEncode(data));

  await prefs.setStringList("location_queue", queue);
}

/// =======================================================
/// PROCESS QUEUE
/// =======================================================
void startQueueProcessor() {
  if (queueTimer != null) return;

  queueTimer = Timer.periodic(
    const Duration(seconds: 10),
    (timer) async => await processQueue(),
  );
}

Future<void> processQueue() async {
  final prefs = await SharedPreferences.getInstance();

  List<String> queue = prefs.getStringList("location_queue") ?? [];

  if (queue.isEmpty) return;

  List<String> remaining = [];

  for (String item in queue) {
    Map<String, dynamic> data = jsonDecode(item);

    bool success = await sendToFrappe(data);

    if (!success) remaining.add(item);
  }

  await prefs.setStringList("location_queue", remaining);
}

/// =======================================================
/// SEND TO FRAPPE
/// =======================================================
Future<bool> sendToFrappe(
  Map<String, dynamic> body,
) async {
  final url = Uri.parse(
    "https://pce.erpkey.in/api/method/mobile.mobile.doctype.get_employee_location.get_employee_location.get_parameters",
  );

  try {
    final headers = await CompanyAuth.getHeaders();
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    print("STATUS: ${response.statusCode}");
    return response.statusCode == 200;
  } catch (e) {
    print("Frappe Send Error: $e");
    return false;
  }
}

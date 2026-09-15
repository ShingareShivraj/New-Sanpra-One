import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocation/model/add_visit_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../../../services/add_visit_services.dart';
import 'package:provider/provider.dart';
import '../../../app_state.dart';
class AddVisitViewModel extends BaseViewModel {
  // ================= STATE =================
  int currentStep = 0;
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AddVisitModel visitData = AddVisitModel();
  List<PartyDetails> allParties = [];
  List<String> filteredParties = [];

  String? visitType; // Customer or Lead
  String? selectedParty;
  String? activeVisitId;

  bool isEdit = false;
  bool isVisitInCompleted = false;
  bool isVisitOutCompleted = false;

  File? outImage;
  final ImagePicker _picker = ImagePicker();
  LatLng? currentLatLng;
  DateTime currentDateTime = DateTime.now();

  // ✅ Upload UX
// ✅ Upload UX
  bool uploading = false;
  double uploadProgress = 0.0;

// ✅ Employee Visit Photo Setting
  bool visitPhotoRequired = false;


  //================== GEO LOCATION TAGS - ADDED BY SHIV==============

  Future<File> addLocationLabel(
      File imageFile,
      double lat,
      double lng,
      ) async {

    final bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) return imageFile;

    final time = DateTime.now();

    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    Placemark place = placemarks.first;

    String village = place.subLocality ?? "";
    String taluka = place.locality ?? "";
    String state = place.administrativeArea ?? "";

    String address = "$village, $taluka, $state";
    String label =
        "$address\n"
        "${time.day}-${time.month}-${time.year} ${time.hour}:${time.minute}";

    img.drawString(
      image,
      label,
      x: 20,
      y: image.height - 80,
      font: img.arial24,
      color: img.ColorRgb8(255, 0, 0),
    );

    final dir = await getTemporaryDirectory();
    final newPath =
        "${dir.path}/visit_${DateTime.now().millisecondsSinceEpoch}.jpg";

    final newFile = File(newPath);
    await newFile.writeAsBytes(img.encodeJpg(image));

    return newFile;
  }


  // ================= INITIALIZATION =================
  Future<void> initialise(BuildContext context, String visitId) async {
    setBusy(true);
    try {
      allParties = await AddVisitServices().fetchCustomer();

      visitPhotoRequired =
      await AddVisitServices().getVisitPhotoSetting();

      if (visitId.isNotEmpty) {

        isEdit = true;

        visitData =
            await AddVisitServices().getVisit(visitId)
                ?? AddVisitModel();

        activeVisitId = visitData.name;

        isVisitInCompleted = true;

        descriptionController.text =
            visitData.description ?? '';

        visitType = visitData.visitTo;
        selectedParty = visitData.visitor;

        _filterParties();
      }
    } finally {
      setBusy(false);
    }
  }

  // ================= VISIT TYPE & PARTY =================
  void setVisitType(String? type) {
    if (visitType == type) return;
    visitType = type;
    selectedParty = null;
    visitData.visitTo = type;
    _filterParties();
    notifyListeners();
  }

  void _filterParties() {
    filteredParties = visitType == null
        ? []
        : allParties
            .where((p) => p.partyType == visitType)
            .map((p) => p.partyName ?? '')
            .toList();
  }

  void setParty(String? partyName) {
    if (partyName == null) return;

    final selected = allParties.firstWhere(
      (p) => p.partyName == partyName && p.partyType == visitType,
      orElse: () => PartyDetails(partyName: partyName, partyType: visitType),
    );

    selectedParty = selected.partyName;
    visitData
      ..visitorsName = selected.partyName
      ..visitor = selected.party
      ..visitTo = selected.partyType;

    notifyListeners();
  }

  void setDescription(String val) => visitData.description = val;

  // ================= TIME =================
  String formatTime() {
    final hour = currentDateTime.hour > 12
        ? currentDateTime.hour - 12
        : currentDateTime.hour == 0
            ? 12
            : currentDateTime.hour;

    final minute = currentDateTime.minute.toString().padLeft(2, '0');
    final amPm = currentDateTime.hour >= 12 ? 'PM' : 'AM';
    final day = currentDateTime.day.toString().padLeft(2, '0');
    final month = _monthName(currentDateTime.month);

    return "$day-$month $hour:$minute $amPm";
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }

  void updateCurrentTime() {
    currentDateTime = DateTime.now();
    notifyListeners();
  }

  Future<void> saveVisitStep(bool isVisitIn, BuildContext context) async {

    if (!isVisitIn) {
      final ok = await _ensureLocationReadyDirect();
      if (!ok) return;

      final positionFuture = _getBestPositionFast();
      final pos = await positionFuture;

      if (pos == null) {
        Fluttertoast.showToast(msg: "Unable to get location. Try again.");
        return;
      }

      // 🔥 GET GLOBAL VALUE
      File? imageFile;

      if (visitPhotoRequired) {
        final photo = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 60,
          maxWidth: 1280,
          maxHeight: 720,
        );

        if (photo == null) {
          Fluttertoast.showToast(
            msg: "Photo is required",
          );
          return;
        }

        imageFile = await addLocationLabel(
          File(photo.path),
          pos.latitude,
          pos.longitude,
        );
      } else {
        imageFile = null;
      }

      // 🔥 UPLOAD / SAVE VISIT
      setBusy(true);
      uploading = true;
      uploadProgress = 0.0;
      notifyListeners();

      try {
        await _saveVisitOutUpload(
          pos.latitude,
          pos.longitude,
          imageFile, // can be null
          context,
        );
      } on TimeoutException {
        Fluttertoast.showToast(msg: "Upload timed out. Please try again.");
      } finally {
        uploading = false;
        setBusy(false);
        notifyListeners();
      }

      return;
    }

    // ✅ VISIT IN (unchanged)
    setBusy(true);
    try {
      final ok = await _ensureLocationReadyDirect();
      if (!ok) return;

      Position? pos = await Geolocator.getLastKnownPosition();
      pos ??= await _getCurrentPositionFast();

      if (pos == null) {
        Fluttertoast.showToast(msg: "Unable to get location. Try again.");
        return;
      }

      await _saveVisitInFast(pos.latitude, pos.longitude);
    } finally {
      setBusy(false);
    }
  }

  /// ✅ Direct settings flow + permission
  Future<bool> _ensureLocationReadyDirect() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      Fluttertoast.showToast(msg: "Turn ON location and try again.");
      return false;
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    if (perm == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
        msg: "Location permission blocked. Enable it from App Settings.",
      );
      return false;
    }

    return perm == LocationPermission.always ||
        perm == LocationPermission.whileInUse;
  }

  Future<Position?> _getBestPositionFast() async {
    Position? pos = await Geolocator.getLastKnownPosition();
    pos ??= await _getCurrentPositionFast();
    return pos;
  }

  /// ✅ Fresh position but short timeouts
  Future<Position?> _getCurrentPositionFast() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 4),
      );
    } catch (_) {
      try {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 3),
        );
      } catch (_) {
        return null;
      }
    }
  }

  Future<void> _saveVisitInFast(double lat, double lng) async {
    visitData
      ..visitInTime = DateTime.now().toString()
      ..visitInLatitude = lat.toString()
      ..visitInLongitude = lng.toString()
      ..visitInAddress = null; // skipped

    final res =
    await AddVisitServices().addVisit(
      visitData,
      null,
    );

    if (res["success"] == true) {

      activeVisitId = res["visitId"];

      isVisitInCompleted = true;

      currentStep = 1;

      Fluttertoast.showToast(
        msg: "Visit In Started. ✓",
      );

      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> _saveVisitOutUpload(
    double lat,
    double lng,
    File? imageFile,
    BuildContext context,
  ) async {
    outImage = imageFile;

    visitData
      ..visitOutTime = DateTime.now().toString()
      ..visitOutLatitude = lat.toString()
      ..visitOutLongitude = lng.toString()
      ..description = descriptionController.text
      ..visitOutAddress = null; // skipped

    isVisitOutCompleted = true;
    notifyListeners();

    visitData.name = activeVisitId;

    final res =
    await AddVisitServices().addVisit(
      visitData,
      outImage,
      onProgress: (sent, total) {
        if (total <= 0) return;

        uploadProgress = sent / total;

        notifyListeners();
      },
    );

    if (res["success"] == true) {

      activeVisitId = null;

      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }
}

// ================= PARTY DETAILS =================
class PartyDetails {
  final String? partyType;
  final String? party;
  final String? partyName;

  const PartyDetails({this.partyType, this.party, this.partyName});

  factory PartyDetails.fromJson(Map<String, dynamic> json) => PartyDetails(
        partyType: json['party_type'],
        party: json['party'],
        partyName: json['party_name'],
      );

  Map<String, dynamic> toJson() => {
        'party_type': partyType,
        'party': party,
        'party_name': partyName,
      };
}

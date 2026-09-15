import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:image/image.dart' as img;
import '../../../model/add_lead_model.dart';
import '../../../model/lead_details_model.dart';
import '../../../services/add_lead_services.dart';
import 'package:provider/provider.dart';
import '../../../app_state.dart';

class AddLeadViewModel extends BaseViewModel {
  // ───────────────────────────────────────── Controllers ─────────────────────────────────────────
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final addressController = TextEditingController();
  final pincodeController = TextEditingController();
  final gstinController = TextEditingController();
  final emailController = TextEditingController();
  final companyNameController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final whatsappController = TextEditingController();
  final noteController = TextEditingController();

  // ───────────────────────────────────────── Data ─────────────────────────────────────────
  AddLeadModel leadData = AddLeadModel();
  LeadDetails leadDetails = LeadDetails();
  List<Notes> notes = [];

  final formKey = GlobalKey<FormState>();
  bool isEdit = false;

  File? selectedImage;
  bool leadPhotoRequired = false;

  // ───────────────────────────────────────── Dropdowns ─────────────────────────────────────────
  List<String> industryTypes = [];
  List<String> territories = [];
  List<String> customers = [];
  List<String> leadSources = [];
  List<String> projects = [];
  List<String> types = ["Lead", "Project"];

  final List<String> states = const [
    "01-Jammu and Kashmir",
    "02-Himachal Pradesh",
    "03-Punjab",
    "04-Chandigarh",
    "05-Uttarakhand",
    "06-Haryana",
    "07-Delhi",
    "08-Rajasthan",
    "09-Uttar Pradesh",
    "10-Bihar",
    "11-Sikkim",
    "12-Arunachal Pradesh",
    "13-Nagaland",
    "14-Manipur",
    "15-Mizoram",
    "16-Tripura",
    "17-Meghalaya",
    "18-Assam",
    "19-West Bengal",
    "20-Jharkhand",
    "21-Odisha",
    "22-Chhattisgarh",
    "23-Madhya Pradesh",
    "24-Gujarat",
    "26-Dadra and Nagar Haveli and Daman and Diu",
    "27-Maharashtra",
    "29-Karnataka",
    "30-Goa",
    "31-Lakshadweep Islands",
    "32-Kerala",
    "33-Tamil Nadu",
    "34-Puducherry",
    "35-Andaman and Nicobar Islands",
    "36-Telangana",
    "37-Andhra Pradesh",
    "38-Ladakh",
    "96-Other Countries",
    "97-Other Territory"
  ];

  // ───────────────────────────────────────── Location warm cache (CURRENT) ─────────────────────────────────────────
  Position? _latestPosition;
  DateTime? _latestPositionAt;
  Timer? _locationWarmTimer;
  bool _warmInFlight = false;

  /// Call from Screen: onModelReady => model.startLocationWarmup();
  Future<void> startLocationWarmup() async {
    // warm immediately
    _warmOnce();

    _locationWarmTimer?.cancel();
    _locationWarmTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (_warmInFlight) return;
      _warmInFlight = true;
      _warmOnce().whenComplete(() => _warmInFlight = false);
    });
  }

  /// Call from Screen dispose => model.stopLocationWarmup();
  void stopLocationWarmup() {
    _locationWarmTimer?.cancel();
    _locationWarmTimer = null;
  }

  Future<void> _warmOnce() async {
    try {
      // If permissions/service are handled in your app already, you can remove checks.
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return;

      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return;
      }

      // ✅ “Current” but faster than high
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 4),
      );

      _latestPosition = pos;
      _latestPositionAt = DateTime.now();
    } catch (_) {
      // ignore warm failures
    }
  }
  Future<File> addLocationLabel(File imageFile, double lat, double lng) async {

    final bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) return imageFile;

    final time = DateTime.now();

    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    Placemark place = placemarks.first;

    List<String> parts = [];

    if ((place.subLocality ?? "").isNotEmpty) parts.add(place.subLocality!);
    if ((place.locality ?? "").isNotEmpty) parts.add(place.locality!);
    if ((place.administrativeArea ?? "").isNotEmpty) parts.add(place.administrativeArea!);

    String address = parts.join(", ");

    String label =
        "$address\n${time.day}-${time.month}-${time.year} ${time.hour}:${time.minute}";

    img.fillRect(
      image,
      x1: 0,
      y1: image.height - 120,
      x2: image.width,
      y2: image.height,
      color: img.ColorRgb8(0, 0, 0),
    );

    img.drawString(
      image,
      label,
      x: 20,
      y: image.height - 90,
      font: img.arial24,
      color: img.ColorRgb8(255, 255, 255),
    );

    final dir = await getTemporaryDirectory();
    final newPath =
        "${dir.path}/lead_${DateTime.now().millisecondsSinceEpoch}.jpg";

    final newFile = File(newPath);
    await newFile.writeAsBytes(img.encodeJpg(image));

    return newFile;
  }

  // ───────────────────────────────────────── Init ─────────────────────────────────────────
  Future<void> initialise(BuildContext context, String leadId) async {
    setBusy(true);
    try {
      leadPhotoRequired =
      await AddLeadServices().getLeadPhotoSetting();

      leadDetails = await AddLeadServices().leadDetails() ?? LeadDetails();

      industryTypes = List<String>.from(leadDetails.industryType ?? []);
      territories = List<String>.from(leadDetails.territories ?? []);
      customers = List<String>.from(leadDetails.customer ?? []);
      leadSources = List<String>.from(leadDetails.leadSource ?? []);
      projects = List<String>.from(leadDetails.projects ?? []);

      if (leadId.isNotEmpty) {
        isEdit = true;
        leadData = await AddLeadServices().getLead(leadId) ?? AddLeadModel();
        _populateControllers();
      } else {
        // ✅ start warming only for new lead (where you need current location)
        startLocationWarmup();
      }
    } catch (e) {
      Logger().e("Init error", error: e);
      Fluttertoast.showToast(msg: "Failed to load lead");
    } finally {
      setBusy(false);
    }
  }

  void _populateControllers() {
    firstnameController.text = leadData.firstName ?? "";
    lastnameController.text = leadData.description ?? "";
    mobileNumberController.text = leadData.mobileNo ?? "";
    emailController.text = leadData.emailId ?? "";
    whatsappController.text = leadData.whatsappNo ?? "";
    companyNameController.text = leadData.companyName ?? "";
    cityController.text = leadData.city ?? "";
    addressController.text = leadData.address ?? "";
    pincodeController.text = leadData.pincode?.toString() ?? "";
    gstinController.text = leadData.gstIn ?? "";
    stateController.text = leadData.state ?? "";
  }

  void _syncControllersToModel() {
    leadData
      ..firstName = firstnameController.text.trim()
      ..description = lastnameController.text.trim()
      ..mobileNo = mobileNumberController.text.trim()
      ..emailId = emailController.text.trim()
      ..whatsappNo = whatsappController.text.trim()
      ..companyName = companyNameController.text.trim()
      ..city = cityController.text.trim()
      ..address = addressController.text.trim()
      ..pincode = int.tryParse(pincodeController.text.trim())
      ..gstIn = gstinController.text.trim()
      ..state = stateController.text.trim();
  }

  // ───────────────────────────────────────── Image ─────────────────────────────────────────
  // ───────────────────────────────────────── Image ─────────────────────────────────────────
  Future<void> pickPhoto({bool fromCamera = true}) async {
    final picked = await ImagePicker().pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 60,
      maxWidth: 1280,
      maxHeight: 1280,
    );

    if (picked != null) {

      File original = File(picked.path);

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      File labeledImage = await addLocationLabel(
        original,
        pos.latitude,
        pos.longitude,
      );

      selectedImage = labeledImage;

      notifyListeners();
    }
  }

  // ───────────────────────────────────────── Save (OPTIMIZED for CURRENT location) ─────────────────────────────────────────
  Future<void> onSavePressed(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    // final trackingEnabled =
    //     Provider.of<AppState>(context, listen: false).trackingEnabled;

    try {
      _syncControllersToModel();
      leadData.notes = notes;

      if (!isEdit) {
        final pos = await _getCurrentLocationRequired();

        leadData
          ..latitude = pos.latitude.toString()
          ..longitude = pos.longitude.toString();

        // ✅ CAMERA LOGIC
        // -------------------------
// LEAD PHOTO
// Only required when enabled for this employee
// -------------------------
        if (leadPhotoRequired && selectedImage == null) {
          final picked = await ImagePicker().pickImage(
            source: ImageSource.camera,
            imageQuality: 60,
            maxWidth: 1280,
            maxHeight: 1280,
          );

          if (picked == null) {
            Fluttertoast.showToast(
              msg: "Photo is required",
            );
            return;
          }

          final original = File(picked.path);

          selectedImage = await addLocationLabel(
            original,
            pos.latitude,
            pos.longitude,
          );
        }
      }

      // ✅ LOADER AFTER CAMERA
      setBusy(true);

      final service = AddLeadServices();

      final success = isEdit
          ? await service
          .updateLead(leadData)
          .timeout(const Duration(seconds: 25))
          : await service
          .addLead(leadData, imageFile: selectedImage)
          .timeout(const Duration(seconds: 25));

      if (success && context.mounted) {
        Navigator.pop(context, true);
      }
    } on TimeoutException {
      Fluttertoast.showToast(msg: "Request timed out. Please try again.");
    } catch (e, s) {
      Logger().e("Save failed", error: e, stackTrace: s);
      Fluttertoast.showToast(msg: "Save failed");
    } finally {
      setBusy(false);
    }
  }

  /// ✅ Returns CURRENT location fast:
  /// - If warm cache is fresh (<= 20s), use immediately
  /// - else fetch current with bounded timeout (medium -> high fallback)
  Future<Position> _getCurrentLocationRequired() async {
    // If you already handle permission elsewhere, you can remove checks.
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      Fluttertoast.showToast(msg: "Turn ON location services");
      await Geolocator.openLocationSettings();
      throw Exception("Location service disabled");
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Location permission required");
      throw Exception("Location permission denied");
    }

    // 1) Use fresh warmed location (instant)
    if (_latestPosition != null && _latestPositionAt != null) {
      final age = DateTime.now().difference(_latestPositionAt!);
      if (age <= const Duration(seconds: 20)) {
        return _latestPosition!;
      }
    }

    // 2) Try medium (fast)
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 5),
      );
      _latestPosition = pos;
      _latestPositionAt = DateTime.now();
      return pos;
    } catch (_) {
      // 3) Fallback high (still bounded)
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 7),
      );
      _latestPosition = pos;
      _latestPositionAt = DateTime.now();
      return pos;
    }
  }

  // ───────────────────────────────────────── Setters ─────────────────────────────────────────
  void setFirstName(String v) => leadData.firstName = v;
  void setLastName(String v) => leadData.description = v;
  void setMobile(String v) => leadData.mobileNo = v;
  void setEmail(String v) => leadData.emailId = v;
  void setCompany(String v) => leadData.companyName = v;
  void setCity(String v) => leadData.city = v;
  void setWhatsapp(String v) => leadData.whatsappNo = v;
  void setAddress(String v) => leadData.address = v;
  void setGstin(String v) => leadData.gstIn = v;
  void setPincode(String v) => leadData.pincode = int.tryParse(v);

  void setIndustry(String? v) => leadData.industry = v;
  void setTerritory(String? v) => leadData.territory = v;
  void setState(String? v) => leadData.state = v;
  void setSource(String? v) => leadData.source = v;
  void setCustomer(String? v) => leadData.customer = v;
  void setProject(String? v) => leadData.customProject = v;
  void setLeadType(String? v) => leadData.marketSegment = v;

  void setNote(String note) {
    noteController.text = note;
    notes = [
      Notes(note: '<div class="ql-editor read-mode"><p>$note</p></div>')
    ];
    notifyListeners();
  }

  // ───────────────────────────────────────── Validators ─────────────────────────────────────────
  String? _required(String? v, String field) =>
      (v == null || v.trim().isEmpty) ? "Please enter $field" : null;

  String? validateFirstName(String? v) => _required(v, "Party name");
  String? validateLastName(String? v) => _required(v, "Description");
  String? validateMobile(String? v) => _required(v, "Mobile number");
  String? validateEmail(String? v) => _required(v, "Email");
  String? validateCompany(String? v) => _required(v, "Company");
  String? validateState(String? v) => _required(v, "State");
  String? validateCity(String? v) => _required(v, "City");
  String? validatePincode(String? v) => _required(v, "Pincode");
  String? validateAddress(String? v) => _required(v, "Address");

  // ───────────────────────────────────────── Dispose ─────────────────────────────────────────
  @override
  void dispose() {
    stopLocationWarmup();

    firstnameController.dispose();
    lastnameController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    cityController.dispose();
    stateController.dispose();
    companyNameController.dispose();
    whatsappController.dispose();
    noteController.dispose();
    addressController.dispose();
    gstinController.dispose();
    pincodeController.dispose();
    super.dispose();
  }
}
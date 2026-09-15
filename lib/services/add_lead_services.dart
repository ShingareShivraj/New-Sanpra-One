import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocation/model/lead_details_model.dart';
import 'package:logger/logger.dart';

import '../constants.dart';
import '../model/add_lead_model.dart';

class AddLeadServices {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    responseType: ResponseType.json,
  ));

  final Logger _log = Logger();

  Future<String> _getBaseUrl() async => await geturl();
  Future<String> _getToken() async => await getTocken();

  /// Common error handler
  void _handleError(DioException e, {String? message}) {
    String errorMsg = "An error occurred";
    try {
      if (e.response?.data is Map && e.response?.data["exception"] != null) {
        errorMsg =
            e.response!.data["exception"].toString().split(":").last.trim();
      } else if (e.message != null) {
        errorMsg = e.message!;
      }
    } catch (_) {}

    _log.e("❌ Dio Error: $errorMsg | ${e.response}");
    Fluttertoast.showToast(
      msg: message ?? "Error: $errorMsg",
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
    );
  }

  /// ✅ Add Lead
  Future<bool> addLead(AddLeadModel lead, {File? imageFile}) async {
    try {
      final url =
          '${await _getBaseUrl()}/api/method/mobile.mobile_env.lead.create_lead';
      final token = await _getToken();

      // -------------------------
      // CREATE FORM DATA
      // -------------------------
      final formData = FormData.fromMap({
        ...lead.toJson(), // all normal fields
        if (imageFile != null)
          "image": await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
      });

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': token,
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      _handleError(e, message: "Failed to add Lead");
    } catch (e, st) {
      _log.e("Unexpected error adding lead: $e", stackTrace: st);
    }
    return false;
  }

  /// ✅ Update Lead
  /// ✅ Update Lead
  Future<bool> updateLead(
      AddLeadModel leadDetails, {
        File? imageFile,
      }) async {
    try {
      final url =
          '${await _getBaseUrl()}/api/method/mobile.mobile_env.lead.create_lead';
      final token = await _getToken();

      _log.i("➡️ Updating Lead: ${leadDetails.name}");

      final formData = FormData.fromMap({
        ...leadDetails.toJson(),
        if (imageFile != null)
          "image": await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
      });

      final response = await _dio.put(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': token,
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        _log.i("✅ Lead updated successfully");
        Fluttertoast.showToast(msg: "Lead Updated Successfully");
        return true;
      }

      Fluttertoast.showToast(msg: "Unable to update Lead!");
    } on DioException catch (e) {
      _handleError(e, message: "Failed to update Lead");
    } catch (e, st) {
      _log.e("Unexpected error updating lead: $e", stackTrace: st);
    }

    return false;
  }

  /// ✅ Fetch Industry Types
  Future<List<String>> fetchIndustryTypes() async {
    return _fetchDropdownData("Industry Type", "industry type");
  }

  /// ✅ Fetch Territories
  Future<List<String>> fetchTerritories() async {
    return _fetchDropdownData("Territory", "territory");
  }

  /// 🔄 Common helper for dropdown data
  Future<List<String>> _fetchDropdownData(
      String doctype, String toastLabel) async {
    try {
      final url =
          '${await _getBaseUrl()}/api/resource/$doctype?limit_page_length=99';
      final token = await _getToken();
      _log.i("➡️ Fetching $doctype list");

      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200) {
        final List data = response.data["data"] ?? [];
        _log.i("✅ Fetched ${data.length} $toastLabel(s)");
        return data.map((item) => item["name"].toString()).toList();
      }
      Fluttertoast.showToast(msg: "Unable to fetch $toastLabel list");
    } on DioException catch (e) {
      _handleError(e, message: "Failed to fetch $toastLabel list");
    } catch (e, st) {
      _log.e("Unexpected error fetching $toastLabel: $e", stackTrace: st);
    }
    return [];
  }

  /// ✅ Get Lead by ID
  Future<AddLeadModel?> getLead(String id) async {
    try {
      final url =
          '${await _getBaseUrl()}/api/method/mobile.mobile_env.lead.get_lead_details?lead=$id';
      final token = await _getToken();
      _log.i("➡️ Fetching Lead: $id");

      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data["data"] != null) {
        final lead = AddLeadModel.fromJson(response.data["data"]);
        _log.i("✅ Lead fetched: ${lead.toJson()}");
        return lead;
      }
    } on DioException catch (e) {
      _handleError(e, message: "Failed to fetch lead details");
    } catch (e, st) {
      _log.e("Unexpected error fetching lead: $e", stackTrace: st);
    }
    return null;
  }

  /// ✅ Fetch Lead Dropdown Data
  Future<LeadDetails?> leadDetails() async {
    try {
      final url =
          '${await _getBaseUrl()}/api/method/mobile.mobile_env.lead.lead_details';
      final token = await _getToken();
      _log.i("➡️ Fetching Lead dropdown details");

      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200 && response.data["data"] != null) {
        final leadDetails = LeadDetails.fromJson(response.data["data"]);
        _log.i("✅ Lead details fetched successfully");
        return leadDetails;
      }
    } on DioException catch (e) {
      _handleError(e, message: "Failed to fetch lead dropdown details");
    } catch (e, st) {
      _log.e("Unexpected error fetching lead details: $e", stackTrace: st);
    }
    return null;
  }


  /// Get Lead Photo Setting for current employee
  Future<bool> getLeadPhotoSetting() async {
    final baseUrl = await _getBaseUrl();

    try {
      final response = await _dio.get(
        '$baseUrl/api/method/mobile.mobile_env.lead.get_lead_photo_setting',
        options: Options(
          headers: {
            'Authorization': await _getToken(),
          },
        ),
      );

      if (response.statusCode == 200 &&
          response.data["data"] != null) {
        return response.data["data"]["custom_lead_photo"] == true;
      }
    } on DioException catch (e) {
      _log.e(e.response?.data ?? e);
    } catch (e) {
      _log.e(e);
    }

    return false;
  }
}
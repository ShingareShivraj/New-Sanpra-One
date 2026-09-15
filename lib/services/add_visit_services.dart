import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../model/add_visit_model.dart';
import '../screens/visit_screens/add_visit/add_visit_viewmodel.dart';

import '../../app_state.dart';

class AddVisitServices {
  AddVisitServices() {
    // Configure Dio once
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      // responseType: ResponseType.json, // optional
    );
  }

  final Dio _dio = Dio();

  Future<String> _getBaseUrl() async => await geturl();
  Future<String> _getToken() async => await getTocken();

  // =================== ADD VISIT ===================
  Future<Map<String, dynamic>> addVisit(
    AddVisitModel visit,
    File? image, {
    void Function(int sent, int total)? onProgress,
  }) async {
    final baseUrl = await _getBaseUrl();

    try {
      final formMap = <String, dynamic>{...visit.toJson()};

      if (image != null) {
        formMap["image"] = await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(formMap);

      final sw = Stopwatch()..start();

      final response = await _dio.post(
        '$baseUrl/api/method/mobile.mobile_env.visit.create_visit',
        data: formData,
        options: Options(
          headers: {
            'Authorization': await _getToken(),
            'Content-Type': 'multipart/form-data',
          },
        ),
        onSendProgress: (sent, total) {
          if (total > 0) onProgress?.call(sent, total);
        },
      );

      Logger().i("addVisit took ${sw.elapsedMilliseconds} ms");

      // ✅ Frappe can return 200 with error info in body
      final data = response.data;
      print("ADD VISIT RESPONSE");
      print(data);
      if (response.statusCode == 200) {
        if (data is Map<String, dynamic> && data["exc"] != null) {
          Fluttertoast.showToast(
            msg: (data["message"] ?? "Server error").toString(),
            gravity: ToastGravity.BOTTOM,
            textColor: const Color(0xFFFFFFFF),
            backgroundColor: const Color(0xFFBA1A1A),
          );
          return {
            "success": false,
          };
        }

        final responseData =
            data["data"] ?? {};

        return {
          "success": true,
          "visitId": responseData["name"],
          "status": responseData["status"],
        };
      }

      Fluttertoast.showToast(
        msg: "Failed: ${response.statusCode}",
        gravity: ToastGravity.BOTTOM,
        textColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFFBA1A1A),
      );
      return {
        "success": false,
      };
    } on TimeoutException {
      Fluttertoast.showToast(
        msg: "Request timed out. Please try again.",
        gravity: ToastGravity.BOTTOM,
        textColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFFBA1A1A),
      );
      return {
        "success": false,
      };
    } on DioException catch (e) {
      final msg = _extractFrappeError(e) ?? e.message ?? "Something went wrong";

      Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.BOTTOM,
        textColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFFBA1A1A),
      );

      Logger().e(e.response?.data ?? e);
      return {
        "success": false,
      };
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Something went wrong",
        gravity: ToastGravity.BOTTOM,
        textColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFFBA1A1A),
      );
      Logger().e(e);
      return {
        "success": false,
      };
    }
  }

  String? _extractFrappeError(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      return data["message"]?.toString() ??
          data["exception"]?.toString() ??
          data["exc"]?.toString();
    }
    return null;
  }

  // =================== GET VISIT ===================
  Future<AddVisitModel?> getVisit(String id) async {
    final baseUrl = await _getBaseUrl();

    try {
      final response = await _dio.get(
        '$baseUrl/api/method/mobile.mobile_env.visit.get_visit',
        queryParameters: {'visit_id': id},
        options: Options(
          headers: {'Authorization': await _getToken()},
        ),
      );

      if (response.statusCode == 200 && response.data["data"] != null) {
        return AddVisitModel.fromJson(response.data["data"]);
      }
    } on DioException catch (e) {
      Fluttertoast.showToast(
        msg: _extractFrappeError(e) ?? "Failed to get visit",
        gravity: ToastGravity.BOTTOM,
        textColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFFBA1A1A),
      );
      Logger().e(e.response?.data ?? e);
    }

    return null;
  }


  Future<AddVisitModel?> getActiveVisit() async {
    final baseUrl = await _getBaseUrl();

    try {
      final response = await _dio.get(
        '$baseUrl/api/method/mobile.mobile_env.visit.get_active_visit',
        options: Options(
          headers: {
            'Authorization': await _getToken(),
          },
        ),
      );

      if (response.statusCode == 200 &&
          response.data["data"] != null) {
        return AddVisitModel.fromJson(
          response.data["data"],
        );
      }
    } catch (e) {
      Logger().e(e);
    }

    return null;
  }

  // =================== GET VISIT PHOTO SETTING ===================
  Future<bool> getVisitPhotoSetting() async {
    final baseUrl = await _getBaseUrl();

    try {
      final response = await _dio.get(
        '$baseUrl/api/method/mobile.mobile_env.visit.get_visit_photo_setting',
        options: Options(
          headers: {
            'Authorization': await _getToken(),
          },
        ),
      );

      if (response.statusCode == 200 &&
          response.data["data"] != null) {
        return response.data["data"]["custom_visit_photo"] == true;
      }
    } on DioException catch (e) {
      Logger().e(e.response?.data ?? e);
    } catch (e) {
      Logger().e(e);
    }

    return false;
  }

  // =================== FETCH CUSTOMER ===================
  Future<List<PartyDetails>> fetchCustomer() async {
    final baseUrl = await _getBaseUrl();

    try {
      final response = await _dio.get(
        '$baseUrl/api/method/mobile.mobile_env.visit.get_customers_and_leads',
        options: Options(
          headers: {'Authorization': await _getToken()},
        ),
      );

      if (response.statusCode == 200 && response.data["message"] != null) {
        final List<dynamic> dataList = response.data["message"];
        return dataList.map((e) => PartyDetails.fromJson(e)).toList();
      }
    } on DioException catch (e) {
      Fluttertoast.showToast(msg: "Unable to fetch Customers");
      Logger().e(e.response?.data ?? e);
    }

    return [];
  }

  // =================== FETCH VISIT TYPES ===================
  Future<List<String>> fetchVisitType() async {
    final baseUrl = await _getBaseUrl();

    try {
      final response = await _dio.get(
        '$baseUrl/api/resource/Visit Type',
        options: Options(
          headers: {'Authorization': await _getToken()},
        ),
      );

      if (response.statusCode == 200 && response.data["data"] != null) {
        final List<dynamic> dataList = response.data["data"];
        return dataList.map<String>((e) => e["name"].toString()).toList();
      }
    } on DioException catch (e) {
      Fluttertoast.showToast(msg: "Unable to fetch Visit Types");
      Logger().e(e.response?.data ?? e);
    } catch (e) {
      Fluttertoast.showToast(msg: "Unable to fetch Visit Types");
      Logger().e(e);
    }

    return [];
  }
}

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocation/model/add_visit_model.dart';
import 'package:logger/logger.dart';

import '../constants.dart';

class ListVisitServices {
  ListVisitServices({Dio? dio, Logger? logger})
      : _dio = dio ?? Dio(),
        _logger = logger ?? Logger();

  final Dio _dio;
  final Logger _logger;

  static const String _endpoint =
      '/api/method/mobile.mobile_env.visit.get_visit_list';

  /// ✅ NEW: Fetch visit list using From Date & To Date (yyyy-MM-dd)
  Future<List<AddVisitModel>> fetchVisitByDateRange(
    String fromDate,
    String toDate,
  ) async {
    try {
      final baseUrl = await geturl();
      final token = await getTocken();

      final response = await _dio.get(
        "$baseUrl$_endpoint",
        queryParameters: {
          'from_date': fromDate,
          'to_date': toDate,
        },
        options: Options(
          headers: {"Authorization": token},
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          responseType: ResponseType.json,
        ),
      );
      print(response.data);

      if (response.statusCode != 200) {
        Fluttertoast.showToast(msg: "Unable to fetch visits");
        _logger.w("fetchVisitByDateRange failed: ${response.statusCode}");
        return const [];
      }

      final body = response.data;

      // Expected: { "data": [ ... ] }
      final list = (body is Map<String, dynamic>) ? body['data'] : null;
      if (list is! List) return const [];

      final visits = list
          .whereType<Map<String, dynamic>>()
          .map((e) => AddVisitModel.fromJson(e))
          .toList();

      _logger.i("Visits fetched: ${visits.length} ($fromDate -> $toDate)");
      return visits;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final msg =
          (e.response?.data is Map && e.response?.data["message"] != null)
              ? e.response?.data["message"].toString()
              : (e.message ?? "Network error");

      _logger.e(
        "Fetch Visit Error ($statusCode)",
        error: e.response?.data ?? msg,
      );

      if (statusCode == 401) {
        Fluttertoast.showToast(msg: "Session expired. Please login again.");
      } else if (statusCode == 500) {
        Fluttertoast.showToast(msg: "Server error. Try again later.");
      } else {
        Fluttertoast.showToast(msg: msg.toString());
      }

      return const [];
    } catch (e, st) {
      _logger.e("Unexpected Error", error: e, stackTrace: st);
      Fluttertoast.showToast(msg: "Something went wrong");
      return const [];
    }
  }

// (Optional) Keep your old method if some screens still use month/year
// Future<List<AddVisitModel>> fetchVisit(int month, int year) async { ... }
}

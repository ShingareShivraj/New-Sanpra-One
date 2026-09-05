import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../constants.dart';
import '../../../model/add_order_model.dart';
import 'sales_order_uom_model.dart';

class SalesOrderUomService {
  final Dio _dio = Dio();

  Future<Masters?> fetchMasters() async {
    baseurl = await geturl();

    try {
      final response = await _dio.get(
        '$baseurl/api/method/mobile.mobile_env.order.masters',
        options: Options(
          headers: {'Authorization': await getTocken()},
        ),
      );

      return Masters.fromJson(response.data["data"]);
    } catch (e) {
      print("UOM masters error: $e");
      return null;
    }
  }

  Future<List<UomItem>> fetchUomItems() async {
    baseurl = await geturl();

    try {
      final response = await _dio.get(
        '$baseurl/api/method/mobile.mobile_env.order.get_uom_item_list',
        options: Options(
          headers: {'Authorization': await getTocken()},
        ),
      );

      print("UOM ITEM RESPONSE: ${response.data}");

      final List<dynamic> data = response.data["data"] ?? [];

      return data
          .map(
            (e) => UomItem.fromJson(
          Map<String, dynamic>.from(e),
        ),
      )
          .toList();
    } on DioException catch (e) {
      print(
        "UOM item error: "
            "${e.response?.statusCode} ${e.response?.data}",
      );
      return [];
    } catch (e) {
      print("UOM item error: $e");
      return [];
    }
  }

  Future<String> createOrder({
    required String customer,
    required String deliveryDate,
    required String terms,
    required List<UomOrderItem> items,
  }) async {
    baseurl = await geturl();

    final payload = {
      "customer": customer,
      "delivery_date": deliveryDate,
      "items": items.map((orderItem) {
        return {
          "item_code": orderItem.item.itemCode,
          "item_name": orderItem.item.itemName,
          "qty": orderItem.quantity,
          "uom": orderItem.selectedUom?.uom ??
              orderItem.item.stockUom,
          "stock_uom": orderItem.item.stockUom,
          "conversion_factor":
          orderItem.selectedUom?.conversionFactor ?? 1,
        };
      }).toList(),
    };

    print("========== UOM SALES ORDER PAYLOAD ==========");
    print(jsonEncode(payload));
    print("==============================================");

    try {
      final response = await _dio.post(
        '$baseurl/api/method/mobile.mobile_env.order.create_uom_order',
        data: jsonEncode(payload),
        options: Options(
          headers: {
            'Authorization': await getTocken(),
            'Content-Type': 'application/json',
          },
        ),
      );

      print("========== UOM ORDER RESPONSE ==========");
      print(response.data);
      print("=========================================");

      Fluttertoast.showToast(
        msg: response.data['message']?.toString() ??
            "Order created successfully",
      );

      return response.data["data"]?["name"]?.toString() ?? "";
    } on DioException catch (e) {
      print("========== CREATE UOM ORDER ERROR ==========");
      print("STATUS: ${e.response?.statusCode}");
      print("DATA: ${e.response?.data}");
      print("HEADERS: ${e.response?.headers}");
      print("============================================");

      Fluttertoast.showToast(
        msg: e.response?.data?['message']?.toString() ??
            "Failed to create order",
      );
      return "";
    } catch (e) {
      print("Create UOM order error: $e");
      Fluttertoast.showToast(msg: "Failed to create order");
      return "";
    }
  }

  Future<Map<String, dynamic>?> fetchOrder(
      String orderName,
      ) async {
    baseurl = await geturl();

    try {
      final response = await _dio.get(
        '$baseurl/api/method/mobile.mobile_env.order.get_uom_order',
        queryParameters: {"order_name": orderName},
        options: Options(
          headers: {'Authorization': await getTocken()},
        ),
      );

      print("========== FETCH UOM ORDER ==========");
      print(response.data);
      print("=====================================");

      final data = response.data["data"];

      if (data == null) return null;

      return Map<String, dynamic>.from(data);
    } on DioException catch (e) {
      print("========== FETCH UOM ORDER ERROR ==========");
      print("STATUS: ${e.response?.statusCode}");
      print("DATA: ${e.response?.data}");
      print("===========================================");

      Fluttertoast.showToast(
        msg: e.response?.data?["message"]?.toString() ??
            "Failed to load order",
      );
      return null;
    } catch (e) {
      print("Fetch UOM order error: $e");
      Fluttertoast.showToast(msg: "Failed to load order");
      return null;
    }
  }

  Future<bool> updateOrder({
    required String orderId,
    required String customer,
    required String deliveryDate,

    required String terms,
    required List<UomOrderItem> items,
  }) async {
    baseurl = await geturl();

    final payload = {
      "name": orderId,
      "customer": customer,
      "delivery_date": deliveryDate,
      "terms": terms,
      "items": items.map((orderItem) {
        return {
          "item_code": orderItem.item.itemCode,
          "item_name": orderItem.item.itemName,
          "qty": orderItem.quantity,
          "uom": orderItem.selectedUom?.uom ??
              orderItem.item.stockUom,
          "stock_uom": orderItem.item.stockUom,
          "conversion_factor":
          orderItem.selectedUom?.conversionFactor ?? 1,
        };
      }).toList(),
    };

    print("========== UPDATE UOM SALES ORDER ==========");
    print(jsonEncode(payload));
    print("============================================");

    try {
      final response = await _dio.put(
        '$baseurl/api/method/mobile.mobile_env.order.update_uom_order',
        data: jsonEncode(payload),
        options: Options(
          headers: {
            'Authorization': await getTocken(),
            'Content-Type': 'application/json',
          },
        ),
      );

      print("========== UPDATE UOM RESPONSE ==========");
      print(response.data);
      print("=========================================");

      Fluttertoast.showToast(
        msg: response.data["message"]?.toString() ??
            "Order updated successfully",
      );

      return true;
    } on DioException catch (e) {
      print("========== UPDATE UOM ORDER ERROR ==========");
      print("STATUS: ${e.response?.statusCode}");
      print("DATA: ${e.response?.data}");
      print("HEADERS: ${e.response?.headers}");
      print("============================================");

      Fluttertoast.showToast(
        msg: e.response?.data?["message"]?.toString() ??
            "Failed to update order",
      );
      return false;
    } catch (e) {
      print("Update UOM order error: $e");
      Fluttertoast.showToast(msg: "Failed to update order");
      return false;
    }
  }
}

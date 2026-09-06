import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/product.dart';

class ProductService {
  Future<List<Product>> getProducts(String token) async {
    final response = await http.get(
      Uri.parse(ApiConfig.products),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Cannot load products');
    }

    final data = jsonDecode(response.body);

    // backend คืน Array ตรงๆ ไม่ห่อด้วย { products: [...] } (ดู backendapi.md ข้อ 2)
    final List list = data is List ? data : (data['products'] as List);

    return list
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Product> getProductById(String token, int id) async {
    final response = await http.get(
      Uri.parse(ApiConfig.productById(id)),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Cannot load product');
    }

    final data = jsonDecode(response.body);

    // ⚠️ backend คืน Array เสมอแม้ query ด้วย id เดียว (พฤติกรรมของ mysql2)
    // ไม่ใช่ Object เดี่ยวตามที่ plan.md ข้อ 24 สื่อไว้ — ดู backendapi.md ข้อ 2/6
    final Map<String, dynamic> productJson = data is List
        ? data.first as Map<String, dynamic>
        : data as Map<String, dynamic>;

    return Product.fromJson(productJson);
  }
}

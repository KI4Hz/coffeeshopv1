import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService productService;

  List<Product> products = [];
  Product? selectedProduct;

  bool isLoading = false;
  String? errorMessage;

  ProductProvider({required this.productService});

  Future<void> fetchProducts(String token) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      products = await productService.getProducts(token);
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshProducts(String token) => fetchProducts(token);

  Future<void> fetchProductById(String token, int id) async {
    isLoading = true;
    errorMessage = null;
    selectedProduct = null;
    notifyListeners();

    try {
      selectedProduct = await productService.getProductById(token, id);
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

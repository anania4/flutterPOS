import 'package:flutter/foundation.dart';

class PosProduct {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String emoji;

  const PosProduct({
    required this.id, required this.name, required this.description,
    required this.price, required this.category, required this.emoji,
  });
}

class CartItem {
  final PosProduct product;
  int quantity;
  String? note;

  CartItem({required this.product, this.quantity = 1, this.note});

  double get total => product.price * quantity;
}

class PosProvider extends ChangeNotifier {
  String _selectedCategory = 'Coffee';
  String _orderType = 'DINE-IN';
  String _searchQuery = '';
  final List<CartItem> _cart = [];
  final String orderNumber = '#421';
  final String tableInfo = 'Table 08 • Server: Marcus';

  String get selectedCategory => _selectedCategory;
  String get orderType => _orderType;
  String get searchQuery => _searchQuery;
  List<CartItem> get cart => List.unmodifiable(_cart);

  static const categories = ['Coffee', 'Pastries', 'Breakfast', 'Cold Brew', 'Smoothies', 'Snacks'];

  static const allProducts = [
    PosProduct(id:'1', name:'Flat White', description:'Double shot, creamy microfoam', price:4.50, category:'Coffee', emoji:'☕'),
    PosProduct(id:'2', name:'Butter Croissant', description:'Freshly baked, flaky', price:3.75, category:'Pastries', emoji:'🥐'),
    PosProduct(id:'3', name:'Signature Cold Brew', description:'18-hour steep', price:5.20, category:'Cold Brew', emoji:'🧊'),
    PosProduct(id:'4', name:'Caffe Latte', description:'Creamy, rich espresso', price:4.25, category:'Coffee', emoji:'☕'),
    PosProduct(id:'5', name:'Long Black', description:'Pure espresso', price:3.50, category:'Coffee', emoji:'☕'),
    PosProduct(id:'6', name:'Pain au Chocolat', description:'Dark chocolate filling', price:4.10, category:'Pastries', emoji:'🍫'),
    PosProduct(id:'7', name:'Matcha Latte', description:'Premium ceremonial grade', price:5.50, category:'Coffee', emoji:'🍵'),
    PosProduct(id:'8', name:'Avocado Toast', description:'Sourdough, poached egg', price:12.00, category:'Breakfast', emoji:'🥑'),
    PosProduct(id:'9', name:'Oat Milk Latte', description:'Barista oat blend', price:5.00, category:'Coffee', emoji:'☕'),
    PosProduct(id:'10', name:'Blueberry Muffin', description:'Fresh baked daily', price:3.80, category:'Pastries', emoji:'🫐'),
    PosProduct(id:'11', name:'Nitro Cold Brew', description:'Nitrogen infused', price:5.80, category:'Cold Brew', emoji:'🧊'),
    PosProduct(id:'12', name:'Eggs Benedict', description:'Hollandaise, smoked salmon', price:14.50, category:'Breakfast', emoji:'🍳'),
  ];

  List<PosProduct> get filteredProducts {
    return allProducts.where((p) {
      final matchCat = p.category == _selectedCategory;
      final matchSearch = _searchQuery.isEmpty || p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
  }

  void selectCategory(String cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  void setOrderType(String type) {
    _orderType = type;
    notifyListeners();
  }

  void setSearch(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void addToCart(PosProduct product) {
    final idx = _cart.indexWhere((c) => c.product.id == product.id);
    if (idx >= 0) {
      _cart[idx].quantity++;
    } else {
      _cart.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.removeWhere((c) => c.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int qty) {
    final idx = _cart.indexWhere((c) => c.product.id == productId);
    if (idx >= 0) {
      if (qty <= 0) {
        _cart.removeAt(idx);
      } else {
        _cart[idx].quantity = qty;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  double get subtotal => _cart.fold(0, (sum, i) => sum + i.total);
  double get serviceCharge => subtotal * 0.10;
  double get tax => subtotal * 0.05;
  double get total => subtotal + serviceCharge + tax;
}

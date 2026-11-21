import 'package:flutter/material.dart';

const Map<String, IconData> categoryIcons = {
  'restaurant': Icons.restaurant,
  'local_cafe': Icons.local_cafe,
  'shopping_cart': Icons.shopping_cart,
  'shopping_bag': Icons.shopping_bag,
  'directions_car': Icons.directions_car,
  'directions_bus': Icons.directions_bus,
  'local_gas_station': Icons.local_gas_station,
  'home': Icons.home,
  'bolt': Icons.bolt,
  'wifi': Icons.wifi,
  'phone_android': Icons.phone_android,
  'school': Icons.school,
  'favorite': Icons.favorite,
  'medical_services': Icons.medical_services,
  'sports_esports': Icons.sports_esports,
  'movie': Icons.movie,
  'flight': Icons.flight,
  'pets': Icons.pets,
  'work': Icons.work,
  'savings': Icons.savings,
  'payments': Icons.payments,
  'card_giftcard': Icons.card_giftcard,
  'trending_up': Icons.trending_up,
  'category': Icons.category,
};

IconData? iconFromKey(String? key) => key == null ? null : categoryIcons[key];

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final String category;
  final List<String> colors;
  final List<String> sizes;
  final List<String> images;
  final double rating; // ⭐ متوسط التقييم
  final int reviewsCount; // ⭐ عدد الريفيوهات
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    this.id = '',
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.category,
    required this.colors,
    required this.sizes,
    required this.images,
    this.rating = 0.0,
    this.reviewsCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'discountPrice': discountPrice,
      'category': category,
      'colors': colors,
      'sizes': sizes,
      'images': images,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ProductModel.fromDoc(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      price: (map['price'] ?? 0).toDouble(),
      discountPrice:
          map['discountPrice'] != null
              ? (map['discountPrice'] as num).toDouble()
              : null,
      category: map['category']?.toString() ?? '',
      colors:
          (map['colors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      sizes:
          (map['sizes'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      images:
          (map['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      rating: (map['rating'] ?? 0).toDouble(),
      reviewsCount: (map['reviewsCount'] ?? 0) as int,
      createdAt:
          DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(map['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? discountPrice,
    String? category,
    List<String>? colors,
    List<String>? sizes,
    List<String>? images,
    double? rating,
    int? reviewsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      category: category ?? this.category,
      colors: colors ?? this.colors,
      sizes: sizes ?? this.sizes,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMapWithId() {
    final data = toMap();
    data['id'] = id;
    return data;
  }

  String toJson() => jsonEncode(toMapWithId());
  factory ProductModel.fromJson(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      discountPrice:
          map['discountPrice'] != null
              ? (map['discountPrice'] as num).toDouble()
              : null,
      category: map['category'] ?? '',
      colors: List<String>.from(map['colors'] ?? []),
      sizes: List<String>.from(map['sizes'] ?? []),
      images: List<String>.from(map['images'] ?? []),
      rating:
          map['rating'] != null
              ? double.tryParse(map['rating'].toString()) ?? 0.0
              : 0.0,
      reviewsCount:
          (map['reviewsCount'] is int)
              ? map['reviewsCount']
              : int.tryParse(map['reviewsCount']?.toString() ?? '0') ?? 0,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
  
}
extension ProductModelJson on ProductModel {
  Map<String, dynamic> toJsonMap() {
    return jsonDecode(toJson());
  }
}

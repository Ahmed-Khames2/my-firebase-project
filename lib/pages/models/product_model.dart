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
  final String rating; // دلوقتي فاضي
  final List<String> reviews; // دلوقتي فاضي
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.category,
    required this.colors,
    required this.sizes,
    required this.images,
    required this.rating,
    required this.reviews,
    required this.createdAt,
    required this.updatedAt,
  });

  // 🔄 تحويل الموديل إلى Map عشان يتخزن في Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discountPrice': discountPrice,
      'category': category,
      'colors': colors,
      'sizes': sizes,
      'images': images,
      'rating': rating,
      'reviews': reviews,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // 🔄 تحويل الـ Map (من Firestore) إلى موديل
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      discountPrice: map['discountPrice'] != null
          ? (map['discountPrice']).toDouble()
          : null,
      category: map['category'] ?? '',
      colors: List<String>.from(map['colors'] ?? []),
      sizes: List<String>.from(map['sizes'] ?? []),
      images: List<String>.from(map['images'] ?? []),
      rating: map['rating'] ?? '',
      reviews: List<String>.from(map['reviews'] ?? []),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

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
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      price: (map['price'] ?? 0).toDouble(),
      discountPrice:
          map['discountPrice'] != null
              ? (map['discountPrice'] as num).toDouble()
              : null,
      category: map['category']?.toString() ?? '',

      // ✅ هنا التحويل الآمن
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

      rating: map['rating']?.toString() ?? '',
      reviews:
          (map['reviews'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],

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
  String? rating,
  List<String>? reviews,
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
    reviews: reviews ?? this.reviews,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

}

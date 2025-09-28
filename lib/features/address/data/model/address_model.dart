class AddressModel {
  final String id;
  final String userId;
  final String fullName;
  final String phone;
  final String city;
  final String street;
  final String building;

  AddressModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.city,
    required this.street,
    required this.building,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'fullName': fullName,
      'phone': phone,
      'city': city,
      'street': street,
      'building': building,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'],
      userId: map['userId'],
      fullName: map['fullName'],
      phone: map['phone'],
      city: map['city'],
      street: map['street'],
      building: map['building'],
    );
  }
  
}

// await FirebaseFirestore.instance.collection('addresses').add({
//   "userId": currentUser.uid,
//   "label": "Home",
//   "street": "El Tahrir St",
//   "city": "Cairo",
//   "phone": "010...",
//   "lat": 30.0,
//   "lng": 31.2,
//   "createdAt": FieldValue.serverTimestamp(),
// });

import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String clinicId;
  final String userId;
  final String serviceId;
  final String serviceTitle;
  final String serviceDescription;
  final String serviceType;
  final String price;

  Service({
    required this.clinicId,
    required this.userId,
    required this.serviceId,
    required this.serviceTitle,
    required this.serviceDescription,
    required this.serviceType,
    required this.price,
  });

  factory Service.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<dynamic, dynamic>?;
    return Service(
      clinicId: data?['clinicId'] ?? '',
      userId: data?['userId'] ?? '',
      serviceId: snapshot.id,
      serviceTitle: data?['serviceTitle'] ?? '',
      serviceDescription: data?['serviceDescription'] ?? '',
      serviceType: data?['serviceType'] ?? '',
      price: data?['price'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clinicId': clinicId,
      'userId': userId,
      'serviceTitle': serviceTitle,
      'serviceDescription': serviceDescription,
      'serviceType': serviceType,
      'price': price,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'service.dart';

class Services {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get a stream of all services for a clinic
  Stream<List<Service>> getServices(String clinicId) {
    return _db
        .collection('Services').where("clinicId", isEqualTo: clinicId )
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs
        .map((DocumentSnapshot document) => Service.fromSnapshot(document))
        .toList());
  }

  // Add a new service to a clinic
  Future<void> addService(String clinicId, String serviceTitle,
      String serviceDescription, String serviceType, String price) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not logged in');
    }
    final userId = currentUser.uid;
    final Map<String, dynamic> data = Service(
      clinicId: clinicId,
      userId: userId,
      serviceId: '',
      serviceTitle: serviceTitle,
      serviceDescription: serviceDescription,
      serviceType: serviceType,
      price: price,
    ).toMap();
    await _db
        .collection('Services')
        .add(data)
        .then((value) =>
        _db.collection('Services').doc(value.id).update({'serviceId': value.id}));
  }

  // Update an existing service
  Future<void> updateService(
      String clinicId, String serviceId, String serviceTitle, String serviceDescription, String serviceType, String price) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('User not logged in');
    }
    final userId = currentUser.uid;
    final Map<String, dynamic> data = Service(
      clinicId: clinicId,
      userId: userId,
      serviceId: serviceId,
      serviceTitle: serviceTitle,
      serviceDescription: serviceDescription,
      serviceType: serviceType,
      price: price,
    ).toMap();
    await _db
        .collection('Services')
        .doc(serviceId)
        .update(data);
  }

  // Delete a service
  Future<void> deleteService(String clinicId, String serviceId) async {
    await _db
        .collection('Services')
        .doc(serviceId)
        .delete();
  }
}

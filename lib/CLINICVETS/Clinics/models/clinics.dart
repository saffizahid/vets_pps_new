import 'package:cloud_firestore/cloud_firestore.dart';

class Clinics {
  String? uid;
  String? clinicName;
  String? clinicAddress;
  String startTime;
  String endTime;
  String? vetids;
  GeoPoint pinlocation;
  List<String>? selectedDays;
  List<int>? unselectedDays;
  String? timeSlotDuration;
  bool CLINICAVALIBLE;

  Clinics({
    this.uid,
    this.clinicName,
    this.clinicAddress,
    required this.startTime,
    required this.endTime,
    this.vetids,
    required this.pinlocation,
    this.selectedDays,
    this.unselectedDays,
    this.timeSlotDuration,
    required this.CLINICAVALIBLE
  });
}

import 'package:cloud_firestore/cloud_firestore.dart';

class VHomeTimes {
  String? uid;
  String startTime;
  String endTime;
  String? vetids;
  GeoPoint pinlocation;
  List<String>? selectedDays;
  List<int>? unselectedDays;
  String? timeSlotDuration;

  VHomeTimes({
    this.uid,
    required this.startTime,
    required this.endTime,
    this.vetids,
    required this.pinlocation,
    this.selectedDays,
    this.unselectedDays,
    this.timeSlotDuration,
  });
}

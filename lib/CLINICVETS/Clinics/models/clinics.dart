class Clinics {
  String? uid;
  String? clinicName;
  String? clinicAddress;
  String? startTime;
  String? endTime;
  String? vetids;
  String? pinlocation;
  List<String>? selectedDays;
  List<int>? unselectedDays;
  String? timeSlotDuration;

  Clinics({
    this.uid,
    this.clinicName,
    this.clinicAddress,
    this.startTime,
    this.endTime,
    this.vetids,
    this.pinlocation,
    this.selectedDays,
    this.unselectedDays,
    this.timeSlotDuration,
  });
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser!;
String userid = user.uid;
final CollectionReference _Collection = _firestore.collection('Clinics');

class FirebaseCrud {
  static Future<Response> addClinics({
    required String name,
    required String clinicAddress,
    required String startTime,
    required String endTime,
    required String? vetid,
    required String? pinlocation,
    required List<String> selecteddays,
    required List<int> unselecteddays,
    required String timeslotduration,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "clinicName": name,
      "clinicAddress": clinicAddress,
      "startTime": startTime,
      "endTime": endTime,
      "vetids": vetid,
      "pinlocation": pinlocation,
      "selectedDays": selecteddays,
      "unselectedDays": unselecteddays,
      "timeSlotDuration": timeslotduration,
    };

    var result = await documentReferencer
        .set(data)
        .whenComplete(() {
      response.code = 200;
      response.message = "Successfully added to the database";
    })
        .catchError((e) {
      response.code = 500;
      response.message = e.toString();
    });

    return response;
  }

  static Future<Response> updateClinics({
    required String name,
    required String clinicAddress,
    required String startTime,
    required String endTime,
    required String docId,
    required String? pinlocation,
    required List<String> selecteddays,
    required List<int> unselecteddays,
    required String timeslotduration,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "clinicName": name,
      "clinicAddress": clinicAddress,
      "startTime": startTime,
      "endTime": endTime,
      "pinlocation": pinlocation,
      "selectedDays": selecteddays,
      "unselectedDays": unselecteddays,
      "timeSlotDuration": timeslotduration,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() {
      response.code = 200;
      response.message = "Successfully updated Clinics";
    })
        .catchError((e) {
      response.code = 500;
      response.message = e.toString();
    });

    return response;
  }

  static Stream<QuerySnapshot> readClinics() {
    Query<Object?> notesItemCollection =
    _Collection.where("vetids", isEqualTo: userid);
    return notesItemCollection.snapshots();
  }

  static Future<Response> deleteClinics({
    required String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() {
      response.code = 200;
      response.message = "Successfully Deleted Clinics";
    })
        .catchError((e) {
      response.code = 500;
      response.message = e.toString();
    });

    return response;
  }
}


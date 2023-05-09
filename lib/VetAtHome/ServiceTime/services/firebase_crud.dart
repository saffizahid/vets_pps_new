import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser!;
String userid = user.uid;
final CollectionReference _Collection = _firestore.collection('HomeVetTime');

class VAHFirebaseCrud {
  static Future<Response> addVHomeTimes({
    required String startTime,
    required String endTime,
    required String? vetid,
    required GeoPoint pinlocation,
    required List<String> selecteddays,
    required List<int> unselecteddays,
    required String timeslotduration,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(user.uid);

    Map<String, dynamic> data = <String, dynamic>{
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

  static Future<Response> updateVHomeTimes({
    required String startTime,
    required String endTime,
    required String docId,
    required GeoPoint pinlocation,
    required List<String> selecteddays,
    required List<int> unselecteddays,
    required String timeslotduration,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
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
      response.message = "Successfully updated VHomeTimes";
    })
        .catchError((e) {
      response.code = 500;
      response.message = e.toString();
    });

    return response;
  }

  static Stream<QuerySnapshot> readVHomeTimes() {
    Query<Object?> notesItemCollection =
    _Collection.where("vetids", isEqualTo: userid);
    return notesItemCollection.snapshots();
  }

  static Future<Response> deleteVHomeTimes({
    required String docId,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _Collection.doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() {
      response.code = 200;
      response.message = "Successfully Deleted VHomeTimes";
    })
        .catchError((e) {
      response.code = 500;
      response.message = e.toString();
    });

    return response;
  }
}


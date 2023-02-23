import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final user= FirebaseAuth.instance.currentUser!;
String userid=user.uid;
final CollectionReference _Collection = _firestore.collection('Clinics');
class FirebaseCrud {

  static Future<Response> addClinics({
    required String name,
    required String clinicAddress,
    required String startTime,
    required String endTime,
    required String? vetid,
    required String? pinlocation,
  }) async {

    Response response = Response();
    DocumentReference documentReferencer =
        _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "clinicName": name,
      "clinicAddress": clinicAddress,
      "startTime": startTime,
      "endTime": endTime,
      "vetids": vetid,
      "pinlocation": pinlocation,
      //"contact_no" : contactno
    };

    var result = await documentReferencer
        .set(data)
        .whenComplete(() {
          response.code = 200;
          response.message = "Sucessfully added to the database";
        })
        .catchError((e) {
            response.code = 500;
            response.message = e;
        });

        return response;
  }



  static Future<Response> updateClinics({
    required String name,
    required String clinicAddress,
    required String startTime,
    required String endTime,
    //required String contactno,
    required String docId,
    required String? pinlocation,

  }) async {
    Response response = Response();
    DocumentReference documentReferencer =
        _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "clinicName": name,
      "clinicAddress": clinicAddress,
      "startTime": startTime,
      "endTime": endTime,
      "pinlocation": pinlocation,

      // "contact_no" : contactno
      };

    await documentReferencer
        .update(data)
        .whenComplete(() {
           response.code = 200;
          response.message = "Sucessfully updated Clinics";
        })
        .catchError((e) {
            response.code = 500;
            response.message = e;
        });

        return response;
  }

  static Stream<QuerySnapshot> readClinics() {
    Query<Object?> notesItemCollection = _Collection.where("vetids", isEqualTo: userid);
    return notesItemCollection.snapshots();
  }
  static Future<Response> deleteClinics({
    required String docId,
  }) async {
     Response response = Response();
    DocumentReference documentReferencer =
        _Collection.doc(docId);

    await documentReferencer
        .delete()
        .whenComplete((){
          response.code = 200;
          response.message = "Sucessfully Deleted Clinics";
        })
        .catchError((e) {
           response.code = 500;
            response.message = e;
        });

   return response;
  }

}
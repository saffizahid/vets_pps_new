import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final user= FirebaseAuth.instance.currentUser!;
String userid=user.uid;
final CollectionReference _Collection = _firestore.collection('Services');
class FirebaseCrud {

  static Future<Response> addServices({
    required String name,
    required String servicetype,
    required String servicedescription,
    required String price,
    required String? vetid,
    required String? ClinicName,

  }) async {

    Response response = Response();
    DocumentReference documentReferencer =
        _Collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "servicetitle": name,
      "servicetype": servicetype,
      "servicedescription": servicedescription,
      "price": price,
      "vetids": vetid,
      "ClinicName": ClinicName,
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



  static Future<Response> updateServices({
    required String name,
    required String servicetype,
    required String servicedescription,
    required String price,
    //required String contactno,
    required String docId,
    required String? ClinicName,

  }) async {
    Response response = Response();
    DocumentReference documentReferencer =
        _Collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "servicetitle": name,
      "servicetype": servicetype,
      "servicedescription": servicedescription,
      "price": price,
      "ClinicName": ClinicName,

      // "contact_no" : contactno
      };

    await documentReferencer
        .update(data)
        .whenComplete(() {
           response.code = 200;
          response.message = "Sucessfully updated Services";
        })
        .catchError((e) {
            response.code = 500;
            response.message = e;
        });

        return response;
  }

  static Stream<QuerySnapshot> readServices() {
    CollectionReference notesItemCollection =
        _Collection;

    return notesItemCollection.snapshots();
  }

  static Future<Response> deleteServices({
    required String docId,
  }) async {
     Response response = Response();
    DocumentReference documentReferencer =
        _Collection.doc(docId);

    await documentReferencer
        .delete()
        .whenComplete((){
          response.code = 200;
          response.message = "Sucessfully Deleted Services";
        })
        .catchError((e) {
           response.code = 500;
            response.message = e;
        });

   return response;
  }

}
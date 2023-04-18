
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../CLINICVETS/home_screen_clinics.dart';
import '../models/services.dart';
import '../services/firebase_crud.dart';
import 'listpagesec.dart';

class EditPageSec extends StatefulWidget {
final Services? services;
 EditPageSec({this.services});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditPageSec();
  }
}

class _EditPageSec extends State<EditPageSec> {
  final _servicetitle = TextEditingController();
  final _services_servicedescription = TextEditingController();
  final _services_servicetype = TextEditingController();
  final _services_price = TextEditingController();
  final _services_contact = TextEditingController();
  final _docid = TextEditingController();
  final serviceClinic = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

@override
  void initState() {
    // TODO: implement initState
    _docid.value = TextEditingValue(text: widget.services!.uid.toString());
    _servicetitle.value = TextEditingValue(text: widget.services!.servicetitle.toString());
    _services_servicetype.value = TextEditingValue(text: widget.services!.servicetype.toString());
    _services_servicedescription.value = TextEditingValue(text: widget.services!.servicedescription.toString());
    _services_price.value = TextEditingValue(text: widget.services!.price.toString());
    serviceClinic.value = TextEditingValue(text: widget.services!.ClinicName.toString());

  //_services_contact.value = TextEditingValue(text: widget.services!.contactno.toString());

  }

  @override
  Widget build(BuildContext context) {


    final DocIDField = TextField(
        controller: _docid,
        readOnly: true,
        autofocus: false,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Title",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));



    final nameField = TextFormField(
        controller: _servicetitle,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));
    final servicetypeField = TextFormField(
        controller: _services_servicetype,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "servicetype",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));



    final servicedescriptionField = TextFormField(
        controller: _services_servicedescription,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "servicedescription",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final priceField = TextFormField(
        controller: _services_price,
        autofocus: false,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r"[0-9]"),
          )
        ],
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "price",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final contactField = TextFormField(
    //    controller: _services_contact,
        autofocus: false,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r"[0-9]"),
          )
        ],
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Contact Number",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));
    final serviceClinicField = TextFormField(
        controller: serviceClinic,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Select Your Clinic",
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final viewListbutton = TextButton(
        onPressed: () {
          /*Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => ListPageSec(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        */},
        child: const Text('View List of Services'));

    final SaveButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var response = await FirebaseCrud.updateServices(
                name: _servicetitle.text,
                servicetype: _services_servicetype.text,
                servicedescription: _services_servicedescription.text,
                price: _services_price.text,
                //contactno: _services_contact.text,
                docId: _docid.text,
                ClinicName: serviceClinic.text);
            if (response.code != 200) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(response.message.toString()),
                    );
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(response.message.toString()),
                    );
                  });
            }
          }
        },
        child: Text(
          "Update",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Edit",style: TextStyle(color: Color.fromRGBO(
            214, 217, 220, 1.0), fontSize: 15),),

        centerTitle: true,
        backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context)
                    {
                      return  HomePageClinics();
                    }
                )
            );
          },
          child: Icon(
            Icons.arrow_back_sharp,  // add custom icons also
          ),

        ),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                 /* DocIDField,
                  const SizedBox(height: 15.0),
                 */ nameField,
                  const SizedBox(height: 15.0),
                  /*contactField,
                  const SizedBox(height: 15.0),
                  */servicetypeField,
                  const SizedBox(height: 15.0),
                  servicedescriptionField,
                  const SizedBox(height: 15.0),
                  serviceClinicField,

                  const SizedBox(height: 15.0),
                  priceField,

                  viewListbutton,
                  const SizedBox(height: 5.0),
                  SaveButon,
                  const SizedBox(height: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

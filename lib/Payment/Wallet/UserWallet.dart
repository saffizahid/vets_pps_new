import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vets_pps_new/CLINICVETS/home_screen_clinics.dart';
import 'package:vets_pps_new/Payment/Wallet/wallet_colors.dart';

import '../../VETATHOME/home_screen_vetathome.dart';

class WalletScreen extends StatefulWidget {
  String ProfileType;
  WalletScreen({Key? key,required this.ProfileType}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final userss = FirebaseAuth.instance.currentUser!;
  int _walletValue=0;
  String _walletString="";

  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('vet_wallet')
        .doc(userss.uid)
        .get()
        .then((userDoc) {
      setState(() {
        _walletValue = userDoc.get('wallet');
        _walletString = _walletValue.toString();


      });
    });

  }

  void _showWithdrawalPopup(BuildContext context) {
    String bankName = "";
    String accountTitle = "";
    String ibanNumber = "";
    int amount = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Withdraw Funds",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,color: Color.fromRGBO(26, 59, 106, 1.0),

            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Bank Name",
                    hintStyle: TextStyle(color: Color.fromRGBO(26, 59, 106, 1.0)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onChanged: (value) => bankName = value,
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Account Title",
                    hintStyle: TextStyle(color: Color.fromRGBO(26, 59, 106, 1.0),),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onChanged: (value) => accountTitle = value,
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: "IBAN Number",
                    hintStyle: TextStyle(color: Color.fromRGBO(26, 59, 106, 1.0)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  onChanged: (value) => ibanNumber = value,
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Amount",
                    hintStyle: TextStyle(color: Color.fromRGBO(26, 59, 106, 1.0)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => amount = int.parse(value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Withdraw",
                 style: TextStyle(
        color: Color.fromRGBO(26, 59, 106, 1.0),
        fontSize: 16,
        ),
              ),
              onPressed: () async {
                // Perform validations
                if (bankName.isEmpty ||
                    accountTitle.isEmpty ||
                    ibanNumber.isEmpty ||
                    amount == null ||
                    amount < 1000) { // Minimum withdrawal limit of 1000
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please enter a valid withdrawal amount."),
                  ));
                  return;
                }
                if (amount < 0) { // Disallow negative withdrawal amount
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Withdrawal amount cannot be negative."),
                  ));
                  return;
                }

                int walletBalance =
                int.parse(_walletString);

                if (amount > walletBalance) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Withdrawal amount cannot be greater than your wallet balance."),
                  ));
                  return;
                }
                // Save withdrawal request to Firestore
                await FirebaseFirestore.instance
                    .collection("vet_funds_withdrawal_request")
                    .add({
                  "bankName": bankName,
                  "accountTitle": accountTitle,
                  "ibanNumber": ibanNumber,
                  "amount": amount,
                  "vetid": userss.uid,
                  "Date": DateTime.now(),
                  "Status": "WithdrawRequested",
                  "VetEmail": userss.email,

                });
                int newWalletBalance = walletBalance - amount;
                FirebaseFirestore.instance
                    .collection("vet_wallet")
                    .doc(userss.uid)
                    .update({
                  "wallet": newWalletBalance,
                });
                FirebaseFirestore.instance.collection("TransactionsWalletVet").doc().set({
                  "TransactionType": "WithdrawToBank",
                  "Status": "Withdraw",
                  "TransactionAmount": amount,
                  "TransactionDate": DateTime.now(),
                  "booking_id": userss.uid,
                  "vet_id": userss.uid,
                  "user_id": userss.uid,
                });
                setState(() {
                  _walletValue=newWalletBalance;
                  _walletString=newWalletBalance.toString();
                });
                // Show success message and close popup
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Withdrawal Request Submitted Successfully."),
                ));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),

      body: SafeArea(
          child: SingleChildScrollView(

            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 25, left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: grey.withOpacity(0.03),
                          spreadRadius: 10,
                          blurRadius: 3,
                          // changes position of shadow
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 25, right: 20, left: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [InkWell(
                              onTap: (){
                                if (widget.ProfileType == 'Clinic') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HomePageClinics()),
                                  );
                                } else if (widget.ProfileType == 'VETATHOME') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HomePageVetAtHome()),
                                  );
                                }
                              },

                              child: Icon(Icons.arrow_back)),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white,
                              ),
                              child: PopupMenuButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                                  PopupMenuItem(
                                    value: 'withdraw_funds',
                                    child: Text('Withdraw Funds'),
                                  ),
                                ],
                                onSelected: (value) {
                                  switch (value) {
                                    case 'withdraw_funds':
                                      _showWithdrawalPopup(context);

                                      break;
                                  }
                                },
                                icon: Icon(Icons.more_vert),
                              ),
                            )

                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: (size.width - 40) * 0.6,
                              child: Column(
                                children: [
                                  /*           Text(
                                    widget.userMap["firstname"],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: mainFontColor),
                                  ),
                       */           SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: black),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Balance:",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: black),
                                ),
                                SizedBox(
                                  height: 5,
                                ),

                                Text(
                                  "Rs. "+_walletString,
                                  style: TextStyle(
                                      fontSize: 33,
                                      fontWeight: FontWeight.w600,
                                      color: mainFontColor),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 0,
                      ),
                      Container(
                        height: size.height - 280, // Adjust the height as needed
                        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('TransactionsWalletVet')
                              .where('vet_id', isEqualTo: userss.uid)
                              .orderBy('TransactionDate', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final documents = snapshot.data!.docs;
                              return ListView.builder(
                                itemCount: documents.length,
                                itemBuilder: (context, index) {
                                  final transaction = documents[index].data();
                                  final transactionType = transaction['TransactionType'] as String?;
                                  final transactionAmount = transaction['TransactionAmount'] as num?;
                                  final transactionDate = transaction['TransactionDate'] as Timestamp;
                                  final date = DateTime.fromMillisecondsSinceEpoch(transactionDate.millisecondsSinceEpoch);
                                  final formattedDate = "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString()}";

                                  String PaymentType="";
                                  String IconType="";
                                  if (transactionType=="WithdrawToBank"){
                                    PaymentType= "Withdraw To Bank";
                                    IconType= "Sent";
                                  }
                                  else if (transactionType =="CompleteAppointment"){
                                    PaymentType= "Appointment Completed";
                                    IconType= "Receive";
                                  }
                                  Icon getIcon() {
                                    if (IconType == "Receive") {
                                      return Icon(Icons.arrow_downward_rounded);
                                    } else {
                                      return Icon(Icons.arrow_upward_rounded);
                                    }
                                  }
                                  return   Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            top: 10,
                                            left: 10,
                                            right: 10,
                                          ),
                                          decoration: BoxDecoration(
                                              color: white,
                                              borderRadius: BorderRadius.circular(25),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: grey.withOpacity(0.03),
                                                  spreadRadius: 10,
                                                  blurRadius: 3,
                                                  // changes position of shadow
                                                ),
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 10, right: 20, left: 20),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: arrowbgColor,
                                                    borderRadius: BorderRadius.circular(15),
                                                    // shape: BoxShape.circle
                                                  ),
                                                  child: Center(
                                                    child: getIcon(),),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    width: (size.width - 90) * 0.7,
                                                    child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            PaymentType,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: black,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            formattedDate,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: black.withOpacity(0.5),
                                                                fontWeight: FontWeight.w400),
                                                          ),
                                                        ]),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          "RS."+transactionAmount.toString(),
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold,
                                                              color: black),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );

                                },
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ),


                      SizedBox(
                        height: 5,
                      ),

                    ],
                  ),
                )

              ],
            ),
          )),
    );

  }
}

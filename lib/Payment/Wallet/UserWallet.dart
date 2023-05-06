import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vets_pps_new/CLINICVETS/home_screen_clinics.dart';
import 'package:vets_pps_new/Payment/Wallet/wallet_colors.dart';

class WalletScreen extends StatefulWidget {
  Map userMap;
  User user;

  WalletScreen({Key? key, required this.userMap, required this.user})
      : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final userss = FirebaseAuth.instance.currentUser!;

  void _showWithdrawalPopup(BuildContext context) {
    String bankName = "";
    String accountTitle = "";
    String ibanNumber = "";
    double amount = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Withdraw Funds",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Bank Name",
                    hintStyle: TextStyle(color: Colors.grey),
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
                    hintStyle: TextStyle(color: Colors.grey),
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
                    hintStyle: TextStyle(color: Colors.grey),
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
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => amount = double.parse(value),
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
                  fontWeight: FontWeight.bold,
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
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
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

                double walletBalance =
                double.parse(widget.userMap["wallet"].toString());

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
                double newWalletBalance = walletBalance - amount;
                FirebaseFirestore.instance
                    .collection("vet_wallet")
                    .doc(userss.uid)
                    .update({
                  "wallet": newWalletBalance,
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
    String walletValue = double.parse(widget.userMap["wallet"].toString()).toStringAsFixed(2);

    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 10),
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
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return HomePageClinics();
                              }));
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
                       */
                              SizedBox(
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
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Balance:",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w100,
                                  color: black),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Rs. " + walletValue,
                              style: TextStyle(
                                  fontSize: 30,
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
            SizedBox(
              height: 10,
            ),
            /*    Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Text("Overview",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: mainFontColor,
                                  )),
                              IconBadge(
                                icon: Icon(Icons.notifications_none),
                                itemCount: 1,
                                badgeColor: Colors.red,
                                itemColor: mainFontColor,
                                hideZero: true,
                                top: -1,
                                onTap: () {
                                  print('test');
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      // Text("Overview",
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 20,
                      //       color: mainFontColor,
                      //     )),
                      Text("Jan 16, 2023",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: mainFontColor,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 20,
                                left: 25,
                                right: 25,
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
                                          child: Icon(Icons.arrow_upward_rounded)),
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
                                                "Sent",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: black,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Sending Payment to Clients",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: black.withOpacity(0.5),
                                                    fontWeight: FontWeight.w400),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 10,
                                left: 25,
                                right: 25,
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
                                          child: Icon(Icons.arrow_downward_rounded)),
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
                                                "Receive",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: black,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Receiving Payment from company",
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
                                              "\$250",
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
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                )
            */
          ],
        ),
      )),
    );
  }
}

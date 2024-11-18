import 'dart:convert';
// import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:ride_card_app/classes/StripeAPIs/accept_terms.dart';
// import 'package:ride_card_app/classes/StripeAPIs/all_banks.dart';
import 'package:ride_card_app/classes/StripeAPIs/bank_details.dart';
import 'package:ride_card_app/classes/StripeAPIs/check_account_balance.dart';
import 'package:ride_card_app/classes/StripeAPIs/check_account_requirements.dart';
import 'package:ride_card_app/classes/StripeAPIs/create_customer.dart';
import 'package:ride_card_app/classes/StripeAPIs/document_status.dart';
import 'package:ride_card_app/classes/StripeAPIs/get_connected_bank_balance.dart';
// import 'package:ride_card_app/classes/StripeAPIs/link_bank_account.dart';
// import 'package:ride_card_app/classes/StripeAPIs/update_account_info.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
// import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/bank/add.dart';
import 'package:ride_card_app/classes/screens/bank/upload_documents.dart';
import 'package:ride_card_app/classes/service/get_profile/get_profile.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:ride_card_app/classes/service/token_generate/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllBanksScreen extends StatefulWidget {
  const AllBanksScreen({super.key});

  @override
  State<AllBanksScreen> createState() => _AllBanksScreenState();
}

class _AllBanksScreenState extends State<AllBanksScreen> {
  var screenLoader = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  GenerateTokenService apiServiceGT = GenerateTokenService();
  var arrBanks = [];
  //
  var storeStripeCustomerId = '';
  var storeBankAccountId = '';
  bool hideAddButton = true;
  bool isAccountVerified = false;
  var allDocumentsDataResponse = [];
  var isAnyDocumentMissing = true;
  //
  bool _hasFetchedRequirements = false;
  var storeDocumentId = '';
  bool _isVerified = false;
  bool isOneMinuteCross = false;
  @override
  void initState() {
    //fetchProfileData();
    // checkBalance();
    // getAllBanksAccounts();

    super.initState();
  }

  /*void getAllBanksAccounts() async {
    List<Map<String, dynamic>> documentsData = await getAllDocumentsData();

    // Print each document's data
    for (var documentData in documentsData) {
      // print("Document Data: $documentData");
      allDocumentsDataResponse.add(documentData);
    }
    logger.d(allDocumentsDataResponse);
    if (allDocumentsDataResponse[0]['active'] == false) {
      checkRequirements(allDocumentsDataResponse[0]['accountId'].toString());
    }

    setState(() {
      screenLoader = false;
    });
  }*/

  void checkAccountVerification() async {
    String accountId = allDocumentsDataResponse[0]['accountId'].toString();
    String apiKey = dotenv.env["STRIPE_SK_KEY"]!;

    try {
      String? statusMessage = await checkDocumentStatus(accountId, apiKey);
      if (kDebugMode) {
        print(statusMessage);
      }
      if (statusMessage == 'No verification requirements are currently due.') {
        // FirebaseFirestore.instance
        //     .collection('RIDE_WALLET/STRIPE_CONNECT_ACCOUNTS/BANK_ACCOUNTS')
        //     .doc(storeDocumentId)
        //     .update({
        //   'active': true,
        // });
      } else {
        // FirebaseFirestore.instance
        //     .collection('RIDE_WALLET/STRIPE_CONNECT_ACCOUNTS/BANK_ACCOUNTS')
        //     .doc(storeDocumentId)
        //     .update({
        //   'active': false,
        // });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error checking document status: $e");
      }
    }
  }

  // Function to pick an image
  /*Future<void> _pickImage(ImageSource source, bool isFront) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isFront) {
          _frontImage = File(pickedFile.path);
        } else {
          _backImage = File(pickedFile.path);
        }
      });

      // Close and reopen the bottom sheet to reflect the updated image
      Navigator.pop(context); // Close the current bottom sheet
      _showUploadBottomSheet(context); // Reopen the bottom sheet
    }
  }*/

  /*void _showImagePicker(BuildContext context, bool isFront) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery, isFront);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera, isFront);
                },
              ),
            ],
          ),
        );
      },
    );
  }*/

  /*Future<List<Map<String, dynamic>>> getAllDocumentsData() async {
    List<Map<String, dynamic>> allDocumentsData = [];
    await FirebaseFirestore.instance
        .collection('RIDE_WALLET/STRIPE_CONNECT_ACCOUNTS/BANK_ACCOUNTS')
        .where('userId', isEqualTo: loginUserId())
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // Loop through each document in the snapshot
        for (var document in snapshot.docs) {
          if (kDebugMode) {
            print("Document ID: ${document.id}");
          }

          // Retrieve all data inside the document
          Map<String, dynamic> data = document.data();

          // Add the document's data to the array
          allDocumentsData.add(data);
        }
      } else {
        if (kDebugMode) {
          print("No documents found for the user.");
        }
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to retrieve data: $error");
      }
    });

    // Return the list of all document data
    return allDocumentsData;
  }*/

  void checkBalance() async {
    String apiKey = dotenv.env["STRIPE_SK_KEY"]!;
    String connectedAccountId = "acct_1QJykvERnsh89gxe";

    final balanceData =
        await getConnectedAccountBalance(connectedAccountId, apiKey);

    if (balanceData != null) {
      if (kDebugMode) {
        print("Connected Account Balance:");
        print("Available:");
      }

      for (var balance in balanceData['available']) {
        if (kDebugMode) {
          print(balance);
          print(" - Amount: ${balance['amount']} ${balance['currency']}");
        }
      }
      if (kDebugMode) {
        print("Pending:");
      }
      for (var balance in balanceData['pending']) {
        if (kDebugMode) {
          print(" - Amount: ${balance['amount']} ${balance['currency']}");
        }
      }
    } else {
      if (kDebugMode) {
        print("Failed to retrieve the balance.");
      }
    }
  }

  Future<void> fetchProfileData() async {
    await sendRequestToProfileDynamic().then((v) async {
      logger.d(v);
      SharedPreferences prefs2 = await SharedPreferences.getInstance();
      prefs2.setString(
          'Key_save_login_profile_picture', v['data']['image'].toString());
      prefs2.setString('key_save_user_role', v['data']['role'].toString());

      if (STRIPE_STATUS == 'T') {
        logger.d('Mode: Test');
        if (v["stripe_customer_id_Test"].toString() == '') {
          createCustomerInStripe(
            '${v["data"]["fullName"]} ${v["data"]["lastName"]}',
            v["data"]["email"].toString(),
          );
        }
      } else {
        logger.d('Mode: Live');
        if (v["data"]["stripe_customer_id_Live"].toString() == '') {
          createCustomerInStripe(
            '${v["data"]["fullName"]} ${v["data"]["lastName"]}',
            v["data"]["email"].toString(),
          );
        } else {
          storeStripeCustomerId =
              v["data"]["stripe_customer_id_Live"].toString();
          fetchAndDisplayBankAccounts();
        }
      }
    });
  }

  // create customer in stripe
  void createCustomerInStripe(
    String name,
    String email,
  ) async {
    final customerId = await createStripeCustomerAPI(
      name: name,
      email: email,
    );

    if (customerId != null) {
      if (kDebugMode) {
        print('Customer created successfully with ID: $customerId');
      }
      storeStripeCustomerId = customerId.toString();
      editAfterCreateStripeCustomer(context, customerId);
    } else {
      if (kDebugMode) {
        print('Failed to create customer.');
      }
    }
  }

  void editAfterCreateStripeCustomer(
    context,
    customerId,
  ) async {
    debugPrint('API ==> EDIT PROFILE');
    // String parseDevice = await deviceIs();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(SHARED_PREFRENCE_LOCAL_KEY).toString();
    var userId = prefs.getString('Key_save_login_user_id').toString();
    var roleIs = '';
    roleIs = prefs.getString('key_save_user_role').toString();

    final parameters;
    if (STRIPE_STATUS == 'T') {
      parameters = {
        'action': 'editProfile',
        'userId': userId,
        'stripe_customer_id_Test': customerId,
      };
    } else {
      parameters = {
        'action': 'editProfile',
        'userId': userId,
        'stripe_customer_id_Live': customerId,
      };
    }

    if (kDebugMode) {
      print(parameters);
    }
    // return;

    try {
      final response = await _apiService.postRequest(parameters, token);
      if (kDebugMode) {
        print(response.body);
      }
      //
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String successStatus = jsonResponse['status'];
      String successMessage = jsonResponse['msg'];
      if (kDebugMode) {
        print('STATUS ==> $successStatus');
        print(successMessage);
      }

      if (response.statusCode == 200) {
        debugPrint('REGISTRATION: RESPONSE ==> SUCCESS');
        //
        if (successMessage == NOT_AUTHORIZED) {
          //
          apiServiceGT
              .generateToken(
            userId,
            loginUserEmail(),
            roleIs.toString(),
          )
              .then((v) {
            //
            if (kDebugMode) {
              print('TOKEN ==> $v');
            }
            // again click
            editAfterCreateStripeCustomer(context, customerId);
          });
        } else {
          //
          logger.d("Stripe customer created successfully");
          fetchAndDisplayBankAccounts();
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      // print(error);
    }
  }

  void fetchAndDisplayBankAccounts() async {
    /*final bankAccounts = await getCustomerBankAccountsAPI(
      storeStripeCustomerId,
    );

    if (bankAccounts != null) {
      // Display bank accounts in the UI
      for (var account in bankAccounts) {
        if (kDebugMode) {
          print(account);
          print('Bank Account ID: ${account['id']}');
          print('Bank Name: ${account['bank_name']}');
          print('Last 4 Digits: ${account['last4']}');
        }
        var custom = {
          'bankId': account['id'],
          'bankLast4Digits': account['last4'],
          'verified': account['status']
        };
        arrBanks.add(custom);
      }
      setState(() {
        screenLoader = false;
      });
    } else {
      // Show an error message if retrieval failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to retrieve bank accounts.'),
          backgroundColor: Colors.red,
        ),
      );
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: _UIKit(context),
    );
  }

  Container _UIKit(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.amber,
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: screenLoader == true
          ? customCircularProgressIndicator()
          : _UIKitStackBG(context),
    );
  }

  Widget _UIKitStackBG(BuildContext context) {
    return screenLoader == true
        ? const CircularProgressIndicator()
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('RIDE_WALLET/STRIPE_CONNECT_ACCOUNTS/BANK_ACCOUNTS')
                .where('userId', isEqualTo: loginUserId())
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text("Failed to retrieve data: ${snapshot.error}"),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Column(
                  children: [
                    const SizedBox(height: 60.0),
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 16.0,
                              ),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(
                                  20.0,
                                ),
                              ),
                              child: const Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 40.0,
                        ),
                        Expanded(
                          child: Container(
                            height: 40,
                            color: Colors.transparent,
                            child: Center(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: textFontORBITRON(
                                  //
                                  'Bank accounts',
                                  Colors.white,
                                  14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                pushToAddBankAccount(context);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: 16.0,
                                ),
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(
                                    20.0,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 240.0),
                    Center(
                      child: textFontPOOPINS(
                        'No bank account attached.',
                        Colors.white,
                        14.0,
                      ),
                    ),
                  ],
                );
              }

              // Retrieve all document data in a list
              List<Map<String, dynamic>> allDocumentsData =
                  snapshot.data!.docs.map((document) {
                return document.data() as Map<String, dynamic>;
              }).toList();

              // Call `checkRequirements` once, when data is first available
              if (!_hasFetchedRequirements && allDocumentsData.isNotEmpty) {
                _hasFetchedRequirements = true;
                String accountId = allDocumentsData[0]['accountId'];
                storeDocumentId = allDocumentsData[0]['id'];
                _isVerified = allDocumentsData[0]['active'];
                checkRequirements(accountId);
              }
              // check time stamp
              bool result = isTimestampOlderThanOneMinute(
                  allDocumentsData[0]['timeStamp']);
              if (kDebugMode) {
                print("Is timestamp older than 1 minute? $result");
              }
              if (result == false) {
                isOneMinuteCross = false;
              } else {
                isOneMinuteCross = true;
              }

              return ListView.builder(
                itemCount: allDocumentsData.length,
                itemBuilder: (context, index) {
                  final data = allDocumentsData[index];
                  return Column(
                    children: [
                      const SizedBox(height: 60.0),
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                _scaffoldKey.currentState?.openDrawer();
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: 16.0,
                                ),
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(
                                    20.0,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 40.0,
                          ),
                          Expanded(
                            child: Container(
                              height: 40,
                              color: Colors.transparent,
                              child: Center(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: textFontORBITRON(
                                    //
                                    'Bank accounts',
                                    Colors.white,
                                    14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          data.isNotEmpty
                              ? const SizedBox()
                              : Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      pushToAddBankAccount(context);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        left: 16.0,
                                      ),
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(
                                          20.0,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      //
                      isOneMinuteCross == false
                          ? Column(
                              children: [
                                const SizedBox(height: 140),
                                textFontOPENSANS(
                                    'In Process...', Colors.white, 14.0),
                              ],
                            )
                          : Card(
                              child: ListTile(
                                title: textFontPOOPINS(
                                  "AN: ${data['bankAccountNumber']}",
                                  Colors.black,
                                  14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                subtitle: textFontPOOPINS(
                                  "RN: ${data['bankRoutingNumber']}",
                                  Colors.black,
                                  12.0,
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (data['active'] == true) ...[
                                      IconButton(
                                        onPressed: () {
                                          customToast(
                                            'Verified.',
                                            Colors.green,
                                            ToastGravity.BOTTOM,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.verified,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ] else ...[
                                      IconButton(
                                        onPressed: () {
                                          checkRequirements(
                                              allDocumentsDataResponse[0]
                                                      ['accountId']
                                                  .toString());
                                        },
                                        icon: const Icon(Icons.info_outline),
                                      ),
                                    ]
                                  ],
                                ),
                                onTap: () {
                                  data['active'] == true
                                      ? customToast(
                                          'Verified.',
                                          Colors.green,
                                          ToastGravity.BOTTOM,
                                        )
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FullScreenDocumentUploadPage(
                                              strBankAccountId: snapshot.data!
                                                  .docs[index]['accountId']
                                                  .toString(),
                                            ),
                                          ),
                                        );
                                },
                              ),
                            ),
                    ],
                  );
                },
              );
            },
          );
  }

  /*Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  //
                  const SizedBox(height: 80.0),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 16.0,
                            ),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(
                                20.0,
                              ),
                            ),
                            child: const Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 40.0,
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          color: Colors.transparent,
                          child: Center(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: textFontORBITRON(
                                //
                                'Bank accounts',
                                Colors.white,
                                14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      allDocumentsDataResponse.isNotEmpty
                          ? const SizedBox()
                          : Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  pushToAddBankAccount(context);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    left: 16.0,
                                  ),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(
                                      20.0,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  for (int i = 0; i < allDocumentsDataResponse.length; i++) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ),
                      ),
                      child: ListTile(
                        title: textFontPOOPINS(
                          "AN: ${allDocumentsDataResponse[i]['bankAccountNumber']}",
                          Colors.black,
                          14.0,
                          fontWeight: FontWeight.w600,
                        ),
                        subtitle: textFontPOOPINS(
                          "RN: ${allDocumentsDataResponse[i]['bankRoutingNumber']}",
                          Colors.black,
                          12.0,
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (allDocumentsDataResponse[i]['active'] ==
                                true) ...[
                              IconButton(
                                onPressed: () {
                                  customToast(
                                    'Verified.',
                                    Colors.green,
                                    ToastGravity.BOTTOM,
                                  );
                                },
                                icon: const Icon(
                                  Icons.verified,
                                  color: Colors.green,
                                ),
                              ),
                            ] else ...[
                              IconButton(
                                onPressed: () {
                                  checkRequirements(allDocumentsDataResponse[0]
                                          ['accountId']
                                      .toString());
                                },
                                icon: const Icon(Icons.info_outline),
                              ),
                            ]
                          ],
                        ),
                        onTap: () {
                          // getBankAccountInfo(arrBanks[i]['bankId'].toString());
                          // fetchAndDisplayStripeBalance(context);
                          // acceptTerms('acct_1QJykvERnsh89gxe');
                          // transferMoney();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FullScreenDocumentUploadPage(
                                      strBankAccountId:
                                          allDocumentsDataResponse[0]
                                                  ['accountId']
                                              .toString(),
                                    )),
                          );
                        },
                      ),
                    )
                  ]
                ],
              ),
            ),*/
  /*void _showUploadBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          child: Column(
            children: [
              const Text(
                'Upload Front and Back of ID',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _showImagePicker(context, true), // For front image
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _frontImage != null
                      ? Image.file(_frontImage!, fit: BoxFit.cover)
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload, size: 40, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              'Tap to upload Front of ID',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _showImagePicker(context, false), // For back image
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _backImage != null
                      ? Image.file(_backImage!, fit: BoxFit.cover)
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload, size: 40, color: Colors.grey),
                            SizedBox(height: 10),
                            Text(
                              'Tap to upload Back of ID',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                ),
              ),
              const Spacer(), // Pushes the button to the bottom
              ElevatedButton(
                onPressed: () {
                  // Handle the upload action here
                  if (kDebugMode) {
                    print("Documents uploaded");
                  }
                  // _uploadDocumentsToStripe;
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size(double.infinity, 50), // Full-width button
                ),
                child: const Text("Upload Documents"),
              ),
            ],
          ),
        );
      },
    );
  }*/
  bool isTimestampOlderThanOneMinute(int timestamp) {
    // Get the current time in milliseconds
    int currentTime = DateTime.now().millisecondsSinceEpoch;

    // Convert the given timestamp to milliseconds (if it’s in seconds)
    if (timestamp.toString().length == 10) {
      timestamp *= 1000; // Convert seconds to milliseconds
    }

    // Check if the difference is greater than 1 minute (60,000 milliseconds)
    return (currentTime - timestamp) > 60000;
  }

  void fetchAndDisplayStripeBalance(BuildContext context) async {
    final balanceData = await getStripeBalanceAPI();

    if (balanceData != null) {
      final availableBalance = balanceData['available'][0]['amount'];
      final currency = balanceData['available'][0]['currency'];

      if (kDebugMode) {
        print(availableBalance);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Available Balance: ${(availableBalance / 100).toStringAsFixed(2)} $currency'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to retrieve Stripe balance.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void getBankAccountInfo(String bankAccountId) async {
    final bankAccountDetails = await getBankAccountDetailsAPI(
      storeStripeCustomerId,
      bankAccountId,
    );

    if (bankAccountDetails != null) {
      if (kDebugMode) {
        print(bankAccountDetails);
        print('Bank Name: ${bankAccountDetails['bank_name']}');
        print(
            'Account Holder Name: ${bankAccountDetails['account_holder_name']}');
        print('Routing Number: ${bankAccountDetails['routing_number']}');
        print(
            'Last 4 Digits of Account Number: ${bankAccountDetails['last4']}');
      }

      // You can display this information in your UI as needed
    } else {
      if (kDebugMode) {
        print('Failed to retrieve bank account details.');
      }
    }
  }

  void acceptTerms(String bankId) async {
    String apiKey = dotenv.env["STRIPE_SK_KEY"]!;
    String connectedAccountId = bankId;
    logger.d(connectedAccountId);
    int acceptanceDate = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    String acceptanceIp = "8.8.8.8";

    bool isAccepted = await acceptTermsOfService(
      connectedAccountId: connectedAccountId,
      apiKey: apiKey,
      acceptanceDate: acceptanceDate,
      acceptanceIp: acceptanceIp,
    );

    if (isAccepted) {
      if (kDebugMode) {
        print("Terms of Service accepted successfully.");
      }
      checkRequirements(connectedAccountId);
      // updateRequirements(connectedAccountId);
    } else {
      if (kDebugMode) {
        print("Failed to accept Terms of Service.");
      }
    }
  }

  void checkRequirements(String bankId) async {
    String apiKey = dotenv.env["STRIPE_SK_KEY"]!;
    String connectedAccountId = bankId;

    try {
      List<String> requirements = await getAccountRequirements(
        connectedAccountId,
        apiKey,
      );
      if (kDebugMode) {
        print("Account requirements: $requirements");
      }
      if (kDebugMode) {
        print(requirements.length);
      }
      if (requirements.isEmpty) {
        isAnyDocumentMissing = false;
        // checkAccountVerification();
        // transferMoney(connectedAccountId);
        FirebaseFirestore.instance
            .collection('RIDE_WALLET/STRIPE_CONNECT_ACCOUNTS/BANK_ACCOUNTS')
            .doc(storeDocumentId)
            .update({
          'active': true,
        });
      } else {
        FirebaseFirestore.instance
            .collection('RIDE_WALLET/STRIPE_CONNECT_ACCOUNTS/BANK_ACCOUNTS')
            .doc(storeDocumentId)
            .update({
          'active': false,
        });
      }
      // transferMoney

      // Based on the requirements, display input fields to the user for each required item.
      for (var requirement in requirements) {
        if (kDebugMode) {
          print("Please provide: $requirement");
        }
        if (requirement == 'individual.verification.document') {
          isAnyDocumentMissing = true;
          logger.d('Please upload documents');
          customToast(
            'Documents are missing. Please upload your document.',
            Colors.redAccent,
            ToastGravity.BOTTOM_RIGHT,
          );
          FirebaseFirestore.instance
              .collection('RIDE_WALLET/STRIPE_CONNECT_ACCOUNTS/BANK_ACCOUNTS')
              .doc(storeDocumentId)
              .update({
            'active': false,
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to get account requirements: $e");
      }
    }
  }

  /*void updateRequirements(String bankId) async {
    String apiKey = dotenv.env["STRIPE_SK_KEY"]!;
    String connectedAccountId = bankId;

    String businessUrl = "https://thebluebamboo.in";
    String statementDescriptor = "My Statement";

    bool isUpdated = await updateAccountInformation(
      connectedAccountId,
      apiKey,
      businessUrl: businessUrl,
      statementDescriptor: statementDescriptor,
    );

    if (isUpdated) {
      print("Account information updated successfully.");
      checkRequirements(bankId);
    } else {
      print("Failed to update account information.");
    }
  }*/

  void transferMoney(String bankId) async {
    String apiKey = dotenv.env["STRIPE_SK_KEY"]!;

    logger.d(loginUserEmail);
    logger.d(bankId);
    /*await manageConnectedAccount(
      userId: bankId,
      userEmail: loginUserEmail(),
      accountNumber: "000123456789",
      country: "US",
      currency: "usd",
      accountHolderName: loginUserName(),
      accountHolderType: "individual",
      transferAmount: 1000,
      routingNumber: "110000000",
    );*/

    // Step 1: Create a connected account for the user
    /*final connectedAccountId = await createConnectedAccount(
      loginUserEmail(),
      apiKey,
    );
    if (connectedAccountId == null) {
      print('Failed to create connected account.');
      return;
    }

    // Step 2: Link the user's bank account
    final bankAccountToken = await createBankAccountToken(
      accountNumber: '000123456789',
      country: 'US',
      currency: 'usd',
      accountHolderName: loginUserName(),
      accountHolderType: 'individual',
      routingNumber: '110000000',
      apiKey: apiKey,
    );

    if (bankAccountToken != null) {
      final isLinked = await linkBankAccountToConnectedAccount(
        // connectedAccountId,
        'acct_1QJyaWCadelSXGXM',
        bankAccountToken,
        apiKey,
      );

      if (!isLinked) {
        print('Failed to link bank account.');
        return;
      }
    } else {
      print('Failed to create bank account token.');
      return;
    }

    // Step 3: Transfer funds to the connected account
    final isTransferred = await transferFundsToConnectedAccount(
      connectedAccountId,
      1000, // Transfer amount in cents, e.g., 1000 for $10.00
      apiKey,
    );

    if (!isTransferred) {
      print('Failed to transfer funds.');
      return;
    }

    // Step 4: Initiate payout to the user's bank account
    final isPaidOut = await payoutToBankAccount(
      connectedAccountId,
      1000, // Payout amount in cents
      apiKey,
    );

    if (isPaidOut) {
      print('Payout successful!');
    } else {
      print('Failed to payout.');
    }*/
  }

  Future<void> pushToAddBankAccount(
    BuildContext context,
  ) async {
    //
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddBankScreen(),
      ),
    );

    if (!mounted) return;
    //
    if (result == 'refresh') {
      arrBanks.clear();
      fetchProfileData();
    }
  }
}

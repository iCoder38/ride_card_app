import 'dart:io';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_card_app/classes/common/alerts/alert.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/common/utils/utils.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:ride_card_app/classes/screens/bottom_bar/bottom_bar.dart';
import 'package:ride_card_app/classes/service/service/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.strProfileIs});

  final String strProfileIs;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contFirstName = TextEditingController();
  final TextEditingController _contLastName = TextEditingController();
  final TextEditingController _contEmail = TextEditingController();
  final TextEditingController _contPhone = TextEditingController();
  final TextEditingController _contPassword = TextEditingController();
  File? imageFile;
  //
  @override
  void initState() {
    debugPrint(widget.strProfileIs);
    // dummyCreate();
    super.initState();
  }

  /*dummyCreate() async {
    final SquareRepository squareRepository = SquareRepository();

    try {
      final customer = await squareRepository.addCustomer(
        birthday: "1992-06-06",
        emailAddress: "ios1@gmail.com",
        familyName: "Rajput",
        idempotencyKey: const Uuid().v4(),
        givenName: "Dishant",
      );
      if (kDebugMode) {
        print('Customer created: $customer');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Failed to create customer: $error');
      }
    }
    /*try {
      final customer = await squareRepository.addCustomer(
        givenName: "Amelia",
        familyName: "Earhart",
        emailAddress: "Amelia.Earhart@example.com",
        addressLine1: "500 Electric Ave",
        addressLine2: "Suite 600",
        locality: "New York",
        adminDistrict: "NY",
        postalCode: "10003",
        country: "US",
        phoneNumber: "+1-212-555-4240",
        referenceId: "YOUR_REFERENCE_ID",
        note: "a customer",
      );
      print('Customer created: $customer');
    } catch (error) {
      print('Failed to create customer: $error');
    }*/
  }*/

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _contFirstName.dispose();
    _contLastName.dispose();
    _contEmail.dispose();
    _contPhone.dispose();
    _contPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBarScreen(
        str_app_bar_title: TEXT_NAVIGATION_TITLE_REGISTRATION,
        str_status: '0',
        showNavColor: false,
      ),*/
      body: _UIKit(context),
    );
  }

  Widget _UIKit(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.amber,
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover, // Ensure the image covers the whole container
        ),
      ),
      child: _UIKitStackBG(context),
    );
  }

  SingleChildScrollView _UIKitStackBG(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            //
            const SizedBox(
              height: 80.0,
            ),
            widget.strProfileIs == '2'
                ? customNavigationBar(context, 'Register')
                : customNavigationBar(context, 'Register'),
            GestureDetector(
              onTap: () {
                openGalleryOrCamera(context);
              },
              child: Container(
                margin: const EdgeInsets.only(top: 40.0),
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    24.0,
                  ),
                ),
                child: imageFile == null
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            24.0,
                          ),
                          child: Image.file(
                            File(imageFile!.path),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            // height: 200,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            textFontPOOPINS(
              'Create your account',
              Colors.white,
              16.0,
              fontWeight: FontWeight.w600,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ),
                      ),
                      child: Center(
                        child: TextFormField(
                          controller: _contFirstName,
                          decoration: const InputDecoration(
                            hintText: 'First name',
                            border: InputBorder.none, // Remove the border
                            filled: false,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10.0),
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return TEXT_FIELD_EMPTY_TEXT;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ),
                      ),
                      child: Center(
                        child: TextFormField(
                          controller: _contLastName,
                          decoration: const InputDecoration(
                            hintText: 'Last name',
                            border: InputBorder.none, // Remove the border
                            filled: false,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10.0),
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return TEXT_FIELD_EMPTY_TEXT;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                child: Center(
                  child: TextFormField(
                    controller: _contEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: InputBorder.none, // Remove the border
                      filled: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return TEXT_FIELD_EMPTY_TEXT;
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
              ),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                child: Center(
                  child: TextFormField(
                    controller: _contPhone,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Phone',
                      border: InputBorder.none,
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 10.0,
                      ).copyWith(
                        // Adjust the top padding to center the hint text vertically
                        top: 14.0,
                      ),
                    ),
                    maxLength: 10,
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return TEXT_FIELD_EMPTY_TEXT;
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
              ),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                child: Center(
                  child: TextFormField(
                    controller: _contPassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      border: InputBorder.none, // Remove the border
                      filled: false,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return TEXT_FIELD_EMPTY_TEXT;
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
              ),
              child: GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    showLoadingUI(context, PLEASE_WAIT);
                    /**/

                    _sendRequestToRegister(context);
                  }
                },
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: appREDcolor,
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ),
                  ),
                  child: Center(
                    child: textFontPOOPINS(
                      //
                      TEXT_CREATE_AN_ACCOUNT,
                      Colors.white,
                      18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textFontPOOPINS(
                  //
                  TEXT_ALREADY_ACCOUNT,
                  Colors.white,
                  14.0,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                textFontPOOPINS(
                  //
                  TEXT_SIGN_IN,
                  Colors.orange,
                  14.0,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendRequestToRegister(context) async {
    debugPrint('API ==> CREATE AN ACCOUNT');
    String parseDevice = await deviceIs();
    final parameters = {
      'action': 'registration',
      'fullName': _contFirstName.text,
      'lastName': _contLastName.text,
      'email': _contEmail.text,
      'contactNumber': _contPhone.text,
      'password': _contPassword.text,
      'role': RESPONSE_ROLE,
      'device': parseDevice,
      //
    };
    if (kDebugMode) {
      print(parameters);
    }
    // return;
    try {
      final response = await _apiService.postRequest(parameters, '');
      if (kDebugMode) {
        print(response.body);
      }
      //
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String successStatus = jsonResponse['status'];
      String successMessage = jsonResponse['msg'];

      if (response.statusCode == 200) {
        // debugPrint('REGISTRATION: RESPONSE ==> SUCCESS');

        if (successStatus == 'Fails') {
          dismissKeyboard(context);
          Navigator.pop(context);
          customToast(successMessage, Colors.redAccent, ToastGravity.BOTTOM);
        } else {
          successfullyCreatedAccount(
            context,
            successStatus,
            successMessage,
            jsonResponse,
          );
        }
      } else {
        customToast(successStatus, Colors.redAccent, ToastGravity.TOP);
        debugPrint('REGISTRATION: RESPONSE ==> FAILURE');
      }
    } catch (error) {
      // print(error);
    }
  }

  Future<void> deleteAuthUser(status) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      // Get the current user
      User? user = auth.currentUser;

      // Delete the user
      await user?.delete().then((v) {
        //
        Navigator.pop(context);
        customToast(status, hexToColor(appREDcolorHexCode), ToastGravity.TOP);
      });

      // User deleted.
    } catch (e) {
      // An error occurred. Handle it accordingly.
      if (kDebugMode) {
        print("Error deleting user: $e");
      }
    }
  }

  successfullyCreatedAccount(context, status, message, data2) async {
    //
    Map<String, dynamic> data = data2['data'];
    String fullName = data['fullName'];
    String userId = data['userId'].toString();
    String role = data['role'].toString();
    if (kDebugMode) {
      print('OUTPUT ====> $fullName');
      print('OUTPUT ====> $userId');
      print('OUTPUT ====> $role');
    }
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    prefs2.setString(
        'Key_save_login_user_id', data2['data']['userId'].toString());
    prefs2.setString(
      'key_save_user_role',
      data2['data']['role'].toString(),
    );
    // DATA SAVED LOCALLY IN HIVE
    /*var box = await Hive.openBox<MyData>('myBox1');
    var saveUserId = MyData(userId, role);
    await box.add(saveUserId);
    await box.close();*/

    customToast(message, Colors.green, ToastGravity.BOTTOM);
    // Navigator.pop(context);
    // debugPrint('here');
    createAnAccountInFirebase();
    /*Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CompleteProfileScreen(
          getFirstName: _contFirstName.text,
          getLastName: _contLastName.text,
          getContactNumber: _contPhone.text,
          getEmail: _contEmail.text,
          userId: userId.toString(),
        ),
      ),
    );*/
  }

  createAnAccountInFirebase() async {
    //
    /*debugPrint('==================================================');
    debugPrint('============= FIREBASE ===========================');*/
    // showLoadingUI(context, PLEASE_WAIT);
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _contEmail.text.toString(),
            password: 'firebase_password_rca_!',
          )
          .then((value) => {
                //
                // debugPrint('REGISTERED IN FIREBASE'),
                updateUserName(context)
                //
              });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {
      } else {
        debugPrint('Error');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Navigator.pop(context);
    }
  }

  updateUserName(context) async {
    var mergeName = '${_contFirstName.text} ${_contFirstName.text}';
    //debugPrint(mergeName);
    await FirebaseAuth.instance.currentUser!
        .updateDisplayName(mergeName)
        .then((v) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BottomBar(selectedIndex: 0),
        ),
      );
    });
  }

  void openGalleryOrCamera(
    BuildContext context,
  ) async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      //
                      // ignore: deprecated_member_use
                      PickedFile? pickedFile = await ImagePicker().getImage(
                        source: ImageSource.camera,
                        maxWidth: 1800,
                        maxHeight: 1800,
                      );
                      if (pickedFile != null) {
                        setState(() {
                          // print('camera');
                          imageFile = File(pickedFile.path);
                        });
                        //
                      }
                      //
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            svgImage('camera', 16.0, 16.0),
                            const SizedBox(
                              width: 8.0,
                            ),
                            textFontPOOPINS(
                              'Camera',
                              Colors.black,
                              12.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      //
                      Navigator.pop(context);
                      PickedFile? pickedFile = await ImagePicker().getImage(
                        source: ImageSource.gallery,
                        maxWidth: 1800,
                        maxHeight: 1800,
                      );
                      if (pickedFile != null) {
                        setState(() {
                          // print('camera');
                          imageFile = File(pickedFile.path);
                        });
                      }
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            svgImage('video', 16.0, 16.0),
                            const SizedBox(
                              width: 8.0,
                            ),
                            textFontPOOPINS(
                              'Gallery',
                              Colors.black,
                              12.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Center(
                      child: textFontPOOPINS(
                        'Dismiss',
                        Colors.redAccent,
                        12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //
  /*void openGalleryOrCamera(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Camera option'),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              // ignore: deprecated_member_use
              PickedFile? pickedFile = await ImagePicker().getImage(
                source: ImageSource.camera,
                maxWidth: 1800,
                maxHeight: 1800,
              );
              if (pickedFile != null) {
                setState(() {
                  print('camera');
                  imageFile = File(pickedFile.path);
                });
                //
                // str_image_processing = '1';
                //
                // uploadImageToFirebase(context);
                //

                //
              }
            },
            child: textFontPOOPINS(
              'text',
              Colors.black,
              12.0,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              // ignore: deprecated_member_use
              PickedFile? pickedFile = await ImagePicker().getImage(
                source: ImageSource.gallery,
                maxWidth: 1800,
                maxHeight: 1800,
              );
              if (pickedFile != null) {
                setState(() {
                  if (kDebugMode) {
                    print('gallery');
                  }
                  imageFile = File(pickedFile.path);
                });
                // str_image_processing = '1';
                // uploadImageToFirebase(context);
              }
            },
            child: textFontPOOPINS(
              'Gallery',
              Colors.black,
              12.0,
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: textFontPOOPINS(
              'Dismiss',
              Colors.redAccent,
              12.0,
            ),
          ),
        ],
      ),
    );
  }*/
  //
}

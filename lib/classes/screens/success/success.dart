import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/methods/methods.dart';
import 'package:ride_card_app/classes/screens/bottom_bar/bottom_bar.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen(
      {super.key,
      required this.amount,
      this.receiverData,
      this.responseData,
      required this.showButton,
      required this.status});

  final receiverData;
  final String amount;
  final responseData;
  final bool showButton;
  final String status;

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
  //
  @override
  void initState() {
    //

    //
    if (kDebugMode) {
      print(widget.responseData);
    }
    super.initState();
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
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _UIKitSUCCESSAfterBG(context),
      ),
    );
  }

  Widget _UIKitSUCCESSAfterBG(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 80.0,
          ),
          // customNavigationBar(
          //   context,
          //   TEXT_NAVIGATION_TITLE_SUCCESS,
          // ),
          Row(
            children: [
              /* Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    // Navigator.pop(context, 'reload_screen');
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 16.0,
                    ),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: hexToColor(appORANGEcolorHexCode),
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),*/
              const SizedBox(
                width: 40.0,
              ),
              Container(
                height: 40,
                color: Colors.transparent,
                child: Center(
                  child: textFontORBITRON(
                    //
                    TEXT_NAVIGATION_TITLE_SUCCESS,
                    Colors.white,
                    16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 20.0,
            ),
            child: Container(
              // height: 100,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: hexToColor(appORANGEcolorHexCode),
                borderRadius: BorderRadius.circular(
                  16.0,
                ),
              ),
              child: ListTile(
                leading: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      40.0,
                    ),
                    child: Image.network(
                      // sd
                      widget.receiverData['profile_picture'],
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                title: textFontPOOPINS(
                  //
                  widget.receiverData['userName'],
                  Colors.white,
                  18.0,
                  fontWeight: FontWeight.w800,
                ),
                subtitle: textFontPOOPINS(
                  //
                  widget.receiverData['usercontactNumber'],
                  Colors.white,
                  12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 60.0,
          ),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(
                50.0,
              ),
            ),
            child: Image.asset('assets/images/payment.png'),
          ),
          const SizedBox(
            height: 60.0,
          ),
          if (widget.status == '1') ...[
            textFontPOOPINS(
              'Sent successfully to ${widget.receiverData['userName']}',
              Colors.white,
              16.0,
              fontWeight: FontWeight.w600,
            ),
          ] else if (widget.status == '2') ...[
            textFontPOOPINS(
              'Added successfully',
              Colors.white,
              16.0,
              fontWeight: FontWeight.w600,
            ),
          ] else if (widget.status == '3') ...[
            textFontPOOPINS(
              'Received successfully from ${widget.receiverData['userName']}',
              Colors.white,
              16.0,
              fontWeight: FontWeight.w600,
            ),
          ],

          const SizedBox(
            height: 20.0,
          ),
          textFontPOOPINS(
            '\$${widget.amount}',
            hexToColor(appORANGEcolorHexCode),
            36.0,
            fontWeight: FontWeight.w800,
          ),
          const SizedBox(
            height: 40.0,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Divider(
              thickness: 0.4,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textFontPOOPINS(
                'Transaction done on',
                Colors.white,
                14.0,
                fontWeight: FontWeight.w400,
              ),
              widget.showButton == false
                  ? textFontPOOPINS(
                      ' ${formatDate(widget.responseData['trn_date'].toString())}',
                      hexToColor(appORANGEcolorHexCode),
                      14.0,
                      fontWeight: FontWeight.w600,
                    )
                  : textFontPOOPINS(
                      //
                      ' $formattedDate',
                      hexToColor(appORANGEcolorHexCode),
                      14.0,
                      fontWeight: FontWeight.w600,
                    ),
            ],
          ),
          const SizedBox(
            height: 4.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textFontPOOPINS(
                'Your trasaction id is',
                Colors.white,
                12.0,
                fontWeight: FontWeight.w400,
              ),
              textFontPOOPINS(
                // sv
                ' 0000${widget.responseData['transactionId']}',
                hexToColor(appORANGEcolorHexCode),
                12.0,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomBar(selectedIndex: 0),
                  ),
                );
              },
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      //color: hexToColor(appORANGEcolorHexCode),
                      borderRadius: BorderRadius.circular(
                        16.0,
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 8.0,
                          ),
                          textFontPOOPINS(
                            'Home',
                            Colors.blue,
                            14.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          /*widget.showButton == false
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, 'reload_screen');
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: hexToColor(appREDcolorHexCode),
                            borderRadius: BorderRadius.circular(
                              16.0,
                            ),
                          ),
                          child: Center(
                            child: textFontPOOPINS(
                              'Make another payment',
                              Colors.white,
                              18.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),*/
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
            ),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: hexToColor(appORANGEcolorHexCode),
                      borderRadius: BorderRadius.circular(
                        16.0,
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.share_outlined,
                            size: 22.0,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          textFontPOOPINS(
                            'Share',
                            Colors.white,
                            18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

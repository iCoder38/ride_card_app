import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/screens/bottom_bar_screens/cards/cards.dart';
import 'package:ride_card_app/classes/screens/wallet/wallet.dart';

class BottomBar extends StatefulWidget {
  BottomBar({super.key, required this.selectedIndex});

  int selectedIndex;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  static const List<Widget> _widgetOptions = <Widget>[
    CardsScreen(),WalletScreen(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: textFontOPENSANS(
          'Home',
          Colors.black,
          14.0,
        ),
      ),*/
      body: Center(
        child: _widgetOptions.elementAt(widget.selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(234, 160, 70, 1),
              Color.fromRGBO(234, 150, 70, 1),
              Color.fromRGBO(234, 140, 70, 1),
              Color.fromRGBO(234, 130, 70, 1),
              Color.fromRGBO(234, 120, 70, 1),
              Color.fromRGBO(234, 110, 70, 1),
              Color.fromRGBO(234, 100, 70, 1),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: 'Cards',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: 'Wallet',
            ),
          ],
          currentIndex: widget.selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable

/*
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/screens/bottom_bar_screens/cards/cards.dart';
import 'package:ride_card_app/classes/screens/request_history/request_history.dart';
import 'package:ride_card_app/classes/screens/wallet/send_money/send_money.dart';
import 'package:ride_card_app/classes/screens/wallet/wallet.dart';

// ignore: must_be_immutable
class BottomBar extends StatefulWidget {
  BottomBar({super.key, required this.selectedIndex});

  int selectedIndex;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  static const List<Widget> _widgetOptions = <Widget>[
    CardsScreen(),
    SendMoneyScreen(
      menuBar: 'yes',
    ),
    WalletScreen(),
    RequestHistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Center(
            child: _widgetOptions.elementAt(widget.selectedIndex),
          ),
        ],
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
              icon: Icon(Icons.attach_money_rounded),
              label: 'Send',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
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
*/
import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/screens/bottom_bar_screens/cards/cards.dart';
import 'package:ride_card_app/classes/screens/request_history/request_history.dart';
import 'package:ride_card_app/classes/screens/requests_history/requests_history.dart';
import 'package:ride_card_app/classes/screens/wallet/send_money/send_money.dart';
import 'package:ride_card_app/classes/screens/wallet/wallet.dart';

class BottomBar extends StatefulWidget {
  BottomBar({super.key, required this.selectedIndex});

  int selectedIndex;

  @override
  // ignore: library_private_types_in_public_api
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  // int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    CardsScreen(),
    SendMoneyScreen(
      menuBar: 'yes',
    ),
    WalletScreen(),
    RequestHistoryScreen(
      menuBar: 'yes',
    ),
    RequestsHistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png', // Make sure the path is correct
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Center(
            child: _widgetOptions.elementAt(widget.selectedIndex),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.black.withOpacity(0.5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'Send/Request',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.request_page_outlined),
              label: 'Requests',
            ),
          ],
          currentIndex: widget.selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
        ),
      ),
    ); /*Scaffold(
      /*appBar: AppBar(
        title: Text('Bottom Navigation Bar Example'),
      ),*/
      body: Center(
        child: _widgetOptions.elementAt(widget.selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Send money',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Statement',
          ),
        ],
        currentIndex: widget.selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );*/
  }
}

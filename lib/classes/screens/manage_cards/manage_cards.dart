import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
import 'package:ride_card_app/classes/common/drawer/drawer.dart';
import 'package:ride_card_app/classes/common/widget/widget.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class ManageCardsScreen extends StatefulWidget {
  const ManageCardsScreen({super.key});

  @override
  State<ManageCardsScreen> createState() => _ManageCardsScreenState();
}

class _ManageCardsScreenState extends State<ManageCardsScreen> {
  bool isLightTheme = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool useFloatingAnimation = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: _UIKit(context),
    );
  }

  Container _UIKit(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _UIKitManageCardsAfterBG(context),
      ),
    );
  }

  Glassmorphism? _getGlassmorphismConfig() {
    if (!useGlassMorphism) {
      return null;
    }

    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.grey.withAlpha(50), Colors.grey.withAlpha(50)],
      stops: const <double>[0.3, 0],
    );

    return isLightTheme
        ? Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient)
        : Glassmorphism.defaultConfig();
  }

  Widget _UIKitManageCardsAfterBG(context) {
    return Column(
      children: [
        const SizedBox(height: 80),
        customNavigationBar(TEXT_NAVIGATION_TITLE_MANAGE_CARDS),
        const SizedBox(
          height: 40.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: ListTile(
            title: textFontPOOPINS(
              '424242424242424242424',
              Colors.white,
              16.0,
              fontWeight: FontWeight.w600,
            ),
            subtitle: textFontPOOPINS(
              'Dishant rajput ( axis )',
              Colors.white,
              14.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: ListTile(
            title: textFontPOOPINS(
              '424242424242424242424',
              Colors.black,
              16.0,
              fontWeight: FontWeight.w600,
            ),
            subtitle: textFontPOOPINS(
              'Dishant rajput ( icici )',
              Colors.black,
              14.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: ListTile(
            title: textFontPOOPINS(
              '424242424242424242424',
              Colors.black,
              16.0,
              fontWeight: FontWeight.w600,
            ),
            subtitle: textFontPOOPINS(
              'Dishant rajput ( hdfc )',
              Colors.black,
              14.0,
            ),
          ),
        ),
        /*CreditCardWidget(
          enableFloatingCard: useFloatingAnimation,
          glassmorphismConfig: _getGlassmorphismConfig(),
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cardHolderName: cardHolderName,
          cvvCode: cvvCode,
          bankName: 'Axis Bank',
          frontCardBorder:
              useGlassMorphism ? null : Border.all(color: Colors.grey),
          backCardBorder:
              useGlassMorphism ? null : Border.all(color: Colors.grey),
          showBackView: isCvvFocused,
          obscureCardNumber: true,
          obscureCardCvv: true,
          isHolderNameVisible: true,
          cardBgColor: Colors.black,
          // isLightTheme ? AppColors.cardBgLightColor : AppColors.cardBgColor,
          backgroundImage: useBackgroundImage ? 'assets/card_bg.png' : null,
          isSwipeGestureEnabled: true,
          onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
          customCardTypeIcons: <CustomCardTypeIcon>[
            CustomCardTypeIcon(
              cardType: CardType.mastercard,
              cardImage: Image.asset(
                'assets/mastercard.png',
                height: 48,
                width: 48,
              ),
            ),
          ],
        ),*/
      ],
    );
  }
}

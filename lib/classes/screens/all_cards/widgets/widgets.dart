import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

bool isLightTheme = false;
String cardNumber = '';
String expiryDate = '';
String cardHolderName = '';
String cvvCode = '';
bool isCvvFocused = false;
bool useGlassMorphism = false;
bool useBackgroundImage = false;
bool useFloatingAnimation = true;

Glassmorphism? _getGlassmorphismConfig() {
  if (!useGlassMorphism) {
    return null;
  }

  final LinearGradient gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Colors.grey.withAlpha(50),
      const Color.fromARGB(255, 236, 233, 233).withAlpha(50)
    ],
    stops: const <double>[0.3, 0],
  );

  return isLightTheme
      ? Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient)
      : Glassmorphism.defaultConfig();
}

Widget widgetDummyCardShow() {
  return CreditCardWidget(
    enableFloatingCard: true,

    glassmorphismConfig: _getGlassmorphismConfig(),
    cardNumber: cardNumber,
    expiryDate: expiryDate,
    cardHolderName: cardHolderName,
    cvvCode: cvvCode,
    bankName: 'ALL CARDS',
    frontCardBorder: useGlassMorphism ? null : Border.all(color: Colors.grey),
    backCardBorder: useGlassMorphism ? null : Border.all(color: Colors.grey),
    showBackView: isCvvFocused,
    // backgroundNetworkImage:
    // 'https://plus.unsplash.com/premium_photo-1709033511355-d2b8d7e86797?q=80&w=3749&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    obscureCardNumber: true,
    obscureCardCvv: true,
    isHolderNameVisible: true,
    cardBgColor: Colors.orangeAccent,
    // isLightTheme ? AppColors.cardBgLightColor : AppColors.cardBgColor,
    backgroundImage: useBackgroundImage ? 'assets/images/logo.png' : null,
    isSwipeGestureEnabled: true,
    onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
    customCardTypeIcons: <CustomCardTypeIcon>[
      CustomCardTypeIcon(
        cardType: CardType.mastercard,
        cardImage: Image.asset(
          'assets/images/logo.png',
          height: 48,
          width: 48,
        ),
      ),
    ],
  );
}

Widget widgetDummyCardShow2() {
  return CreditCardWidget(
    enableFloatingCard: true,

    glassmorphismConfig: _getGlassmorphismConfig(),
    cardNumber: cardNumber,
    expiryDate: expiryDate,
    cardHolderName: cardHolderName,
    cvvCode: cvvCode,
    bankName: 'ALL CARDS',
    frontCardBorder: useGlassMorphism ? null : Border.all(color: Colors.grey),
    backCardBorder: useGlassMorphism ? null : Border.all(color: Colors.grey),
    showBackView: isCvvFocused,
    // backgroundNetworkImage:
    // 'https://plus.unsplash.com/premium_photo-1709033511355-d2b8d7e86797?q=80&w=3749&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
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
  );
}

// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, override_on_non_overriding_member, annotate_overrides

import 'package:flutter/material.dart';
import 'package:ride_card_app/classes/common/app_theme/app_theme.dart';
// import 'package:my_new_orange/header/utils/Utils.dart';

class AppBarScreen extends StatefulWidget implements PreferredSizeWidget {
  @override
  final String str_status;
  final String str_app_bar_title;
  final Size preferredSize;
  final bool showNavColor;

  const AppBarScreen({
    super.key,
    required this.str_app_bar_title,
    required this.str_status,
    required this.showNavColor,
  }) : preferredSize = const Size.fromHeight(56.0);

  @override
  State<AppBarScreen> createState() => _AppBarScreenState();
}

class _AppBarScreenState extends State<AppBarScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.str_status == '0') {
      return AppBar(
        title: textFontPOOPINS(
          widget.str_app_bar_title,
          Colors.white,
          16.0,
        ),
        automaticallyImplyLeading: false,
        backgroundColor:
            widget.showNavColor == true ? Colors.transparent : appBGcolor,
      );
    } else {
      return AppBar(
        title: textFontPOOPINS(
          widget.str_app_bar_title,
          Colors.white,
          16.0,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: appBGcolor,
      );
    }
  }
}

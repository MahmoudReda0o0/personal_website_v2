import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:personal_website_v2/core/app/app_colors.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.color = AppColors.app1A1A1AText1});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(size: 20, Icons.arrow_back_ios, color: color),
    );
  }
}

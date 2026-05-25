import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_website_v2/core/custom_widgets/custom_button/custom_button.dart';
import 'package:personal_website_v2/core/custom_widgets/custom_text/custom_text.dart';
import 'package:personal_website_v2/core/custom_widgets/custom_text_field/custom_text_field.dart';

class WebsiteScreen extends StatelessWidget {
  const WebsiteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // CustomText(text: 'Mahmoud reda'),
            20.verticalSpace,
            CustomTextField(controller: TextEditingController()),
            8.verticalSpace,
            CustomButton(onTap: () {}, text: 'Submit'),
          ],
        ),
      ),
    );
  }
}

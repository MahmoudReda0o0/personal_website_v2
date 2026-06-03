import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_website_v2/core/custom_widgets/custom_button/custom_button.dart';
import 'package:personal_website_v2/core/custom_widgets/custom_text/custom_text.dart';
import 'package:personal_website_v2/core/custom_widgets/custom_text_field/custom_text_field.dart';
import 'package:personal_website_v2/feature/provider/app_provider.dart';
import 'package:provider/provider.dart';

class WebsiteScreen extends StatefulWidget {
  const WebsiteScreen({super.key});

  @override
  State<WebsiteScreen> createState() => _WebsiteScreenState();
}

class _WebsiteScreenState extends State<WebsiteScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppProvider>(context, listen: false).getInitData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<AppProvider>(
          builder: (context, data, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // CustomText(text: 'Mahmoud reda'),
                CustomText(text: data.personalInfo.name),
                CustomText(text: data.setting.myInfo.toString()),

                20.verticalSpace,
                CustomTextField(controller: TextEditingController()),
                8.verticalSpace,
                CustomButton(onTap: () {}, text: 'Submit'),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:personal_website_v2/core/custom_widgets/custom_text/custom_text.dart';

class WebsiteScreen extends StatelessWidget {
  const WebsiteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [CustomText(text: 'Mahmoud reda')]),
    );
  }
}

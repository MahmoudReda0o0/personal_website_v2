import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_website_v2/core/custom_widgets/custom_button/custom_button.dart';
import 'package:personal_website_v2/core/custom_widgets/custom_text/custom_text.dart';
import 'package:personal_website_v2/core/firebase/firebase_service.dart';
import 'package:personal_website_v2/core/provider/social_media_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCreate extends StatelessWidget {
  const QrCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Provider.of<AppProvider>(
                context,
                listen: false,
              ).fetchSocialData();
              Provider.of<AppProvider>(
                context,
                listen: false,
              ).fetchSettingData();
            },
            child: Container(
              margin: EdgeInsets.only(top: 50),
              height: 100,
              width: double.infinity,
              color: Colors.blue,
              child: CustomText(text: 'Fitch Social Data'),
            ),
          ),
          Consumer<AppProvider>(
            builder: (context, data, child) {
              if (data.socialData.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Row(
                  children: List.generate(data.socialData.length, (index) {
                    return Text(data.socialData[index].name);
                  }),
                );
              }
            },
          ),
          Consumer<AppProvider>(
            builder: (context, data, child) {
              return Row(
                children: [
                  Text(data.setting.showProjects.toString()),
                  Text(data.setting.showSocialMedial.toString()),
                ],
              );
            },
          ),
          Center(
            child: QrImageView(
              eyeStyle: QrEyeStyle(color: Colors.blue),
              data: 'https://www.youtube.com/watch?v=Er5DcIa4Hiw',
              version: QrVersions.auto,
              size: 300.0,
            ),
          ),
        ],
      ),
    );
  }
}

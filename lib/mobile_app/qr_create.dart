import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_website_v2/core/app/app_image.dart';
import 'package:personal_website_v2/core/custom_widgets/custom_button/custom_button.dart';
import 'package:personal_website_v2/core/custom_widgets/custom_image/custom_image.dart';
import 'package:personal_website_v2/core/custom_widgets/custom_text/custom_text.dart';
import 'package:personal_website_v2/core/firebase/firebase_service.dart';
import 'package:personal_website_v2/core/provider/social_media_provider.dart';
import 'package:personal_website_v2/web_app/website_screen.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCreate extends StatelessWidget {
  const QrCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: QrImageView(
              eyeStyle: QrEyeStyle(color: Colors.blue),
              data: 'https://www.youtube.com/watch?v=Er5DcIa4Hiw',
              version: QrVersions.auto,
              size: 300.0,
            ),
          ),
          20.verticalSpace,
          // CustomImage(image: AppImage.facebook),
          Consumer<AppProvider>(
            builder: (context, data, child) {
              if (data.setting.showSocialMedial == false) {
                return const SizedBox.shrink();
              } else if (data.socialData.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(data.socialData.length, (index) {
                    return GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse(data.socialData[index].link);
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            CustomImage(
                              image: AppImage.getSocialImage(
                                data.socialData[index].name,
                              ),
                              height: 50,
                              width: 50,
                            ),
                            CustomText(text: data.socialData[index].name),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              }
            },
          ),
          Consumer<AppProvider>(
            builder: (context, data, child) {
              return Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomText(text: 'social'),
                        Switch(
                          value: data.setting.showSocialMedial,
                          onChanged: (value) {
                            Provider.of<AppProvider>(
                              context,
                              listen: false,
                            ).changeSocialSetting(value);
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomText(text: 'project'),
                        Switch(
                          value: data.setting.showProjects,
                          onChanged: (value) {
                            Provider.of<AppProvider>(
                              context,
                              listen: false,
                            ).changeProjectSetting(value);
                          },
                        ),
                      ],
                    ),
                    CustomButton(
                      text: 'update setting',
                      textColor: Colors.white,
                      onTap: () {
                        Provider.of<AppProvider>(
                          context,
                          listen: false,
                        ).updateSettingData();
                      },
                    ),
                    CustomButton(
                      text: 'Open Website',
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebsiteScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

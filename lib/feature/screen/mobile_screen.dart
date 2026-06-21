import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_website_v2/core/app/app_colors.dart';
import 'package:personal_website_v2/core/custom_widgets/custom_button/custom_button.dart';
import 'package:personal_website_v2/core/custom_widgets/custom_text/custom_text.dart';
import 'package:personal_website_v2/feature/provider/app_provider.dart';
import 'package:personal_website_v2/feature/screen/website_screen.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCreate extends StatelessWidget {
  const QrCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AppProvider>(
          builder: (context, data, _) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  _buildProfileSection(context, data),
                  SizedBox(height: 32.h),
                  _buildQrCodeSection(context),
                  SizedBox(height: 32.h),
                  _buildSettingsSection(context, data),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, AppProvider data) {
    return Column(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor:
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
          child: Icon(
            Icons.person,
            size: 44,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 12.h),
        CustomText(
          text: data.personalInfo.name,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: data.personalInfo.job,
          color: AppColors.lightTextSecondary,
          fontSize: 14,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: 'Age: ${data.personalInfo.age}',
          color: AppColors.lightTextSecondary,
          fontSize: 13,
        ),
      ],
    );
  }

  Widget _buildQrCodeSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomText(
            text: 'My QR Code',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 20.h),
          QrImageView(
            eyeStyle: QrEyeStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            data: 'https://www.youtube.com/watch?v=Er5DcIa4Hiw',
            version: QrVersions.auto,
            size: 220.w,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, AppProvider data) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBorder.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Settings',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 16.h),
          _buildSettingToggle(
            context,
            label: 'Show Social Media',
            value: data.setting.socialMedial,
            onChanged: (val) {
              log('Social toggled: $val');
            },
          ),
          Divider(height: 1, color: AppColors.lightBorder.withValues(alpha: 0.5)),
          SizedBox(height: 8.h),
          _buildSettingToggle(
            context,
            label: 'Show Projects',
            value: data.setting.projects,
            onChanged: (val) {
              log('Projects toggled: $val');
            },
          ),
          Divider(height: 1, color: AppColors.lightBorder.withValues(alpha: 0.5)),
          SizedBox(height: 8.h),
          _buildSettingToggle(
            context,
            label: 'AI Chat',
            value: data.setting.aiChat,
            onChanged: (val) {
              log('AI Chat toggled: $val');
            },
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Update Settings',
                  isOutlined: true,
                  onTap: () {
                    try {
                      log('Settings update triggered');
                    } catch (e) {
                      log('update_setting_error: $e');
                    }
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomButton(
                  text: 'Open Website',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WebsiteScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingToggle(
    BuildContext context, {
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: label,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

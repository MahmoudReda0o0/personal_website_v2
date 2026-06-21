import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_website_v2/core/app/app_image.dart';
import 'package:personal_website_v2/core/custom_widgets/custom_image/custom_image.dart';
import 'package:personal_website_v2/feature/provider/ai_provider.dart';
import 'package:provider/provider.dart';

class MivoImageWidget extends StatelessWidget {
  const MivoImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MivoAiProvider>(
      builder: (context, ai, _) {
        return CustomImage(image: ai.mivoImage, height: 200.h, width: 200.w);
      },
    );
  }
}

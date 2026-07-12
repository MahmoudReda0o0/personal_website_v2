import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mivo/core/custom_widgets/custom_text/custom_text.dart';
import 'package:mivo/core/model/ai_questions.dart';

class ShowQuestionDialog extends StatelessWidget {
  const ShowQuestionDialog({super.key, required this.questions});
  final QuestionModel questions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 8.h),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadiusDirectional.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Text(
              ' ${questions.id}. ${questions.question}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.w),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadiusDirectional.vertical(
                bottom: Radius.circular(15),
              ),
            ),
            child: CustomText(
              text: questions.answer,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            // Text(questions.answer, style: const TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

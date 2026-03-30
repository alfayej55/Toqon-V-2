import 'package:car_care/all_export.dart';
import 'package:car_care/views/base/custom_button.dart';

import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({super.key});

  final TextEditingController feedbackCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Feedback', style: AppStyles.h2(color: Get.theme.textTheme.bodyLarge!.color)),
        centerTitle: true,
      ),

      body: SafeArea(top: false, 
        minimum: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Write your feedback...', style: AppStyles.h4()),

            SizedBox(height: 10),

            CustomTextField(
              controller: feedbackCtrl,
              hintText: 'Share your feedback',
              minLines: 5,
              maxLines: null,
            ),

            Spacer(),

            CustomButton(
              onTap: () {
                final message = feedbackCtrl.text.trim();
                if (message.isEmpty) {
                  Get.snackbar(
                    'Feedback',
                    'Please write your feedback before sending.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }
                Get.snackbar(
                  'Thank you',
                  'Feedback sent successfully.',
                  snackPosition: SnackPosition.BOTTOM,
                );
                feedbackCtrl.clear();
              },
              text: 'Send Feedback',
            ),
          ],
        ),
      ),
    );
  }
}

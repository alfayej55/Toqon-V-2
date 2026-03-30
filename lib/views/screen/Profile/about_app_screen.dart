import 'package:car_care/all_export.dart';
import 'package:car_care/views/Widget/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            NavigationHelper.backOrHome();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Get.theme.textTheme.bodyLarge!.color,
          ),
        ),
        backgroundColor: Colors.transparent,
        title: Text('About App', style: AppStyles.h5(color: Get.theme.textTheme.bodyLarge!.color)),
      ),

      body: SafeArea(top: false, 
        minimum: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// app Info Senction
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppIcons.torqonLogoIcon,
                    height: 95,
                    width: 95,
                  ),
                  SizedBox(height: 10),
                  Text(AppString.appNamed, style: AppStyles.h2()),
                  SizedBox(height: 10),
                  Text(
                    'Your comprehensive car maintenance companion',
                    textAlign: TextAlign.center,
                    style: AppStyles.h4(
                      color:
                          Get.theme.textTheme.bodyMedium!.color ??
                          AppColors.whiteColor.withValues(alpha: 0.9),
                    ),
                  ),

                  CustomCard(
                    child: Column(
                      children: [
                        versionInfo('App Version', '2.0.3'),
                        SizedBox(height: 8),
                        versionInfo('Build Date', 'June 2025'),
                        SizedBox(height: 8),
                        versionInfo('Build SHA', 'e0a1c9b'),
                        SizedBox(height: 8),
                        versionInfo('Platform', 'iOS 17.0+'),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              /// New Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("What's New", style: AppStyles.h2()),
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        newFeatureInfo(
                          'Enhanced CareGraph',
                          'Improved service logging with photo verification',
                        ),
                        SizedBox(height: 8),
                        newFeatureInfo(
                          "Savings Vault",
                          "New car savings feature with automatic deposits",
                        ),
                        SizedBox(height: 8),
                        newFeatureInfo(
                          'Profile Enhancements',
                          'Improved security settings and user badges',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              /// Legal and privacy>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
              Text("Legal & Privacy", style: AppStyles.h2()),

              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.privacyScreen);
                },
                child: CustomCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Privacy Policy', style: AppStyles.h5()),
                      Icon(Icons.arrow_forward_ios_outlined, size: 18),
                    ],
                  ),
                ),
              ),

              /// Term & Conditions>>>>>>>>>>>>>>
              SizedBox(height: 5),
              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.termAndConditionScreen);
                },
                child: CustomCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Terms & Conditions', style: AppStyles.h5()),
                      Icon(Icons.arrow_forward_ios_outlined, size: 18),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              /// Feed Back
              Text("Feedback", style: AppStyles.h2()),

              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.feedBackScreen);
                },
                child: CustomCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Send App Feedback', style: AppStyles.h5()),
                      Icon(Icons.arrow_forward_ios_outlined, size: 18),
                    ],
                  ),
                ),
              ),

              /// Term & Conditions>>>>>>>>>>>>>>
              SizedBox(height: 5),
              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.termAndConditionScreen);
                },
                child: CustomCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Request a New Feature', style: AppStyles.h5()),
                      Icon(Icons.arrow_forward_ios_outlined, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// VersionInfoCard

  versionInfo(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppStyles.h5()),
        Text(value, style: AppStyles.h6()),
      ],
    );
  }

  newFeatureInfo(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppStyles.h4()),
        Text(
          subtitle,
          style: AppStyles.h6(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

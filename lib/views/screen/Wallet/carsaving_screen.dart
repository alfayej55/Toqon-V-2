import 'package:car_care/utils/custom_textbutton.dart';
import 'package:flutter/material.dart';

import 'package:car_care/all_export.dart';
import 'package:flutter_svg/svg.dart';

class CarSavingScreen extends StatelessWidget {
  const CarSavingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: 'Car Savings', centerTitle: true),

      body: SafeArea(top: false, 
        minimum: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildRow(),
              SizedBox(height: 15),
              savingCard(context),
              SizedBox(height: 15),

              Text(
                'Active Saving Plans',
                style: AppStyles.h5(fontFamily: 'InterSemiBold'),
              ),

              ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  return activeSavingCard();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Car Saving Vault',
          style: AppStyles.h5(fontFamily: 'InterSemiBold'),
        ),
        InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.addSavingPlanScreen);
          },
          child: Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Get.theme.primaryColor,
              border: Border.all(
                color: AppColors.borderColor.withValues(alpha: 0.1),
                width: 1,
              ),
              boxShadow: [AppStyles.boxShadow],
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppIcons.addIcon,
                  colorFilter: ColorFilter.mode(
                    AppColors.whiteColor,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  "Add Plan",
                  style: AppStyles.h5(color: AppColors.whiteColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  savingCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Total Car Saving',
                  style: AppStyles.h5(color: AppColors.whiteColor),
                ),
              ),
              SvgPicture.asset(AppIcons.savingRasioIcon),
            ],
          ),
          Text(
            '\$23,343',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.h1(
              fontFamily: 'InterSemiBold',
              color: AppColors.whiteColor,
            ),
          ),
          SizedBox(height: 15),
          Text(
            'Next deposit: \$40.00 on Dec 30, 2024',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.h5(
              fontFamily: 'InterSemiBold',
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget activeSavingCard() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(Dimensions.radius),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Get.theme.cardColor,
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [AppStyles.boxShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            titleAlignment: ListTileTitleAlignment.center,
            leading: Container(
              height: 48,
              width: 61,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xFFF54924).withValues(alpha: 0.2),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppIcons.carIcon,
                  height: 25,
                  width: 15,
                ),
              ),
            ),
            title: Text('2020 Honda Civic', style: AppStyles.h5()),
            subtitle: Text(
              '\$20/week • Auto-save ON',
              style: AppStyles.h6(color: Get.textTheme.bodyMedium!.color),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '\$150',
                  style: AppStyles.h5(color: AppColors.primaryColor),
                ),
                Text(
                  'of \$459 goal',
                  style: AppStyles.h6(color: Get.textTheme.bodyMedium!.color),
                ),
              ],
            ),
          ),
          LinearProgressIndicator(
            value: 0.5,
            minHeight: 7,
            backgroundColor: AppColors.greyColor,
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          SizedBox(height: 5),
          Text(
            '50 % of goal reached',
            style: AppStyles.h6(color: Get.textTheme.bodyMedium!.color),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomTextButton(
                height: 25,
                width: 140,
                borderColor: BorderSide(color: AppColors.primaryColor),
                textStyle: AppStyles.h6(color: AppColors.primaryColor),
                onTap: () {
                  Get.toNamed(AppRoutes.serviceScreen);
                },
                text: 'Use Funds',
              ),
              CustomTextButton(
                height: 25,
                width: 140,
                onTap: () {
                  Get.toNamed(AppRoutes.addSavingPlanScreen);
                },
                text: 'Modify Plan',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

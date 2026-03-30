import 'package:car_care/extension/contaxt_extension.dart';
import 'package:car_care/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';

class GarageProfileWidget extends StatelessWidget {
  final ProfileModel profileModel;

  const GarageProfileWidget({super.key, required this.profileModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.screenHeight * 0.014),
      padding: EdgeInsets.all(Dimensions.radius),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.2),
          width: 1,
        ),
        color:Get.theme.cardColor,
        boxShadow: [
          AppStyles.boxShadow
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          CustomNetworkImage(
            imageUrl:profileModel.image,
            boxShape: BoxShape.circle,
            width:50,
            height: 50,
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Tag
                  Text(
                    profileModel.fullName,
                    style: AppStyles.h5(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontFamily: 'InterSemiBold',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height:Dimensions.marginBetweenInputTitleAndBox),

                  // Description
                  Text(
                    profileModel.email,
                    style: AppStyles.h6(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontFamily: 'Regular',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height:Dimensions.marginBetweenInputTitleAndBox),

                  // Rating + Reviews
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Color(0xFFFFC107),
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Text(
                       '4.2',
                        style: AppStyles.h6(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontFamily: 'InterSemiBold',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height:Dimensions.marginBetweenInputTitleAndBox),

                  // Distance + Duration
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        profileModel.address,
                        style: AppStyles.h6(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontFamily: 'Regular',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height:Dimensions.marginBetweenInputTitleAndBox),

                  // Price Range

                  // Text(
                  //   '\$120-150',
                  //   style: AppStyles.h5(
                  //     color: Color(0xFFE54924), // Orange like your design
                  //     fontFamily: 'InterBold',
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
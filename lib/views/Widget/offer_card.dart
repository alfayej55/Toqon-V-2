
import 'package:car_care/extension/contaxt_extension.dart';
import 'package:car_care/models/offer_model.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../base/custom_button.dart';

class OfferCard extends StatelessWidget {

 final OfferModel offerModel;
   const OfferCard({super.key,required this.offerModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom:15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Get.theme.cardColor,
        boxShadow: [AppStyles.boxShadow],
      ),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Sponsored & Discount Tag
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: CustomNetworkImage(
                    imageUrl:
                    (offerModel.service?.serviceImage != null && offerModel.service!.serviceImage.isNotEmpty)
                        ? offerModel.service!.serviceImage.first.url
                        : '',
                    width: double.infinity,
                    height: context.screenHeight * 0.18, // Responsive height
                    boxFit: BoxFit.cover,
                  ),
                ),

                // Sponsored Tag
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFD700).withValues(alpha: 0.9), // Yellow background
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Sponsored',
                      style: AppStyles.h6(
                        color: Colors.white,
                        fontFamily: 'InterBold',
                      ),
                    ),
                  ),
                ),

                // Discount Tag
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF2ECC71), // Green background
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${offerModel.offerPercent}% OFF',
                      style: AppStyles.h6(
                        color: Colors.white,
                        fontFamily: 'InterBold',
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content Section
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    '${offerModel.offerDescription}',
                    style: AppStyles.h5(
                      fontFamily: 'InterSemiBold',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 4),

                  // Subtitle
                  Text(
                    'Professional paint services at discounted rates',
                    style: AppStyles.h6(
                      color: Get.theme.textTheme.bodyMedium!.color ?? AppColors.whiteColor.withValues(alpha: 0.9),
                      fontFamily: 'Regular',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 10),

                  // Price Row
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '\$${offerModel.offerPrice}',
                        style: AppStyles.h4(
                          fontFamily: 'InterBold',
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '\$${offerModel.service!.servicePrice}',

                        style: AppStyles.h5(
                          color: Get.theme.textTheme.bodyMedium!.color ?? AppColors.whiteColor.withValues(alpha: 0.9),
                          decoration: TextDecoration.lineThrough,
                          fontFamily: 'Regular',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  // Rating + Distance + Duration
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                          SizedBox(width: 4),
                          Text(
                           '${offerModel.service!.averageRating}',
                            style: AppStyles.h6(
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                              fontFamily: 'InterSemiBold',
                            ),
                          ),
                          // SizedBox(width: 4),
                          // Text(
                          //   '(234)',
                          //   style: AppStyles.h6(
                          //     color: Theme.of(context).textTheme.bodyMedium!.color,
                          //     fontFamily: 'Regular',
                          //   ),
                          // ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              color: Theme.of(context).textTheme.bodyMedium!.color,
                              size: 16),
                          SizedBox(width: 4),
                          Text(
                            '${offerModel.distanceInKm}',
                            style: AppStyles.h6(
                              color: Theme.of(context).textTheme.bodyMedium!.color,
                              fontFamily: 'Regular',
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.access_time,
                              color: Colors.grey[600], size: 16),
                          SizedBox(width: 4),
                          Text(
                            '${offerModel.service!.serviceDuration}',
                            style: AppStyles.h6(
                              color: Theme.of(context).textTheme.bodyMedium!.color,
                              fontFamily: 'Regular',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  // // Tags / Chips
                  // Wrap(
                  //   spacing: 5,
                  //   runSpacing: 3,
                  //   children: [
                  //     Chip(
                  //       label: Text('Oil changeg', style: AppStyles.h6()),
                  //       backgroundColor:Get.theme.cardColor,
                  //       side: BorderSide(color: AppColors.borderColor,width: 1),
                  //
                  //     ),
                  //     Chip(
                  //       label: Text('Filter Replacement', style: AppStyles.h6()),
                  //       backgroundColor:Get.theme.cardColor,
                  //       side: BorderSide(color: AppColors.borderColor,width: 1),
                  //     ),
                  //     Chip(
                  //
                  //       label: Text('Inspection', style: AppStyles.h6()),
                  //       backgroundColor:Get.theme.cardColor,
                  //       side: BorderSide(color: AppColors.borderColor,width: 1),
                  //     ),
                  //   ],
                  // ),

                  // Wrap(
                  //   spacing: 5,
                  //   runSpacing: 3,
                  //   children: serviceTags.map((tag) {
                  //     return Chip(
                  //       label: Text(tag, style: AppStyles.h6()),
                  //       backgroundColor: Get.theme.cardColor,
                  //       side: BorderSide(color: AppColors.borderColor, width: 1),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(8),
                  //       ),
                  //       labelPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), // ছোট স্পেস
                  //     );
                  //   }).toList(),
                  // ),

                  // Book Now Button + Share Icon
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          borderRadius: BorderRadius.circular(6),
                          onTap: () {
                            Get.toNamed(AppRoutes.bookingServiceScreen, arguments: {'serviceId': offerModel.id ?? '', 'type': 'offer'});
                          },
                          height: 44,
                          text: 'Book Now',
                          textStyle: AppStyles.h5(color: AppColors.whiteColor), // Orange
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: EdgeInsets.all(8),
                        child: SvgPicture.asset(AppIcons.sentIcon,colorFilter: ColorFilter.mode(AppColors.greyColor, BlendMode.srcIn),)
                      ),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

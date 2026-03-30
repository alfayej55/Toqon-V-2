import 'package:car_care/controllers/chat_controller.dart';
import 'package:car_care/extension/contaxt_extension.dart';
import 'package:car_care/models/garage_offer_model.dart';

import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
class GaregeOfferCard extends StatelessWidget {
 final GarageOfferModel garageOfferModel;

   GaregeOfferCard({super.key,required this.garageOfferModel});

   final  ChatController _chatCtrl=Get.put(ChatController());

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
            imageUrl:garageOfferModel.offerSender!.image,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                         garageOfferModel.offerSender!.fullName,
                          style: AppStyles.h5(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            fontFamily: 'InterSemiBold',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    garageOfferModel.offerSender!.garageProfile!.isApproved? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              height: 15,
                              AppIcons.verifiedIcon,colorFilter:ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn),),
                            SizedBox(width: 5,),

                            Text(
                              'Verified',
                              style: AppStyles.h5(
                                color: Colors.white,
                                fontFamily: 'InterBold',
                              ),
                            ),
                          ],
                        ),
                      ):SizedBox(),
                    ],
                  ),

                  SizedBox(height:Dimensions.marginBetweenInputTitleAndBox),

                  // Description
                  Text(
                    'Disc',
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
                        '${garageOfferModel.offerSender!.garageProfile!.averageRating}',
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
                        garageOfferModel.offerSender!.address,
                        style: AppStyles.h6(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontFamily: 'Regular',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height:Dimensions.marginBetweenInputTitleAndBox),

                  ///Price Range

                  Text(
                    '\$${garageOfferModel.offerPrice}',
                    style: AppStyles.h5(
                      color: Color(0xFFE54924), // Orange like your design
                      fontFamily: 'InterBold',
                    ),
                  ),
                  /// Accept Button
                  SizedBox(height:Dimensions.marginBetweenInputTitleAndBox),
                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    InkWell(
                      onTap:(){
                        Get.toNamed(AppRoutes.bookingServiceScreen, arguments: {'serviceId': garageOfferModel.id, 'type': 'community_offer'});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderColor),
                          //color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Accept Offer',
                          style: AppStyles.h6(
                            color: Get.theme.textTheme.bodyMedium!.color,
                            fontFamily: 'InterBold',
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        _chatCtrl.createConversations(receiverId: garageOfferModel.offerSender!.id);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              height: 15,
                              AppIcons.chatIcon,colorFilter:ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn),),
                            SizedBox(width:5),
                            Text(
                              'Chat Now',
                              style: AppStyles.h5(
                                color: Colors.white,
                                fontFamily: 'InterBold',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

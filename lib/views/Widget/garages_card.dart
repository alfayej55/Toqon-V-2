import 'package:car_care/extension/contaxt_extension.dart';
import 'package:car_care/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';

class ServiceCardWidget extends StatelessWidget {
  final ServiceModel serviceModel;
  const ServiceCardWidget({super.key, required this.serviceModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.screenHeight * 0.014),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Get.theme.cardColor,
        // border: Border.all(
        //   color: AppColors.borderColor.withValues(alpha: 0.2),
        //   width: 1,
        // ),
        boxShadow: [AppStyles.boxShadow],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section
            CustomNetworkImage(
              imageUrl: serviceModel.serviceImage[0].url,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
              width: context.screenWidth * 0.35,
              boxFit: BoxFit.cover,
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Garage Name and Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            serviceModel.serviceName,
                            style: AppStyles.h5(
                              color: Get.theme.textTheme.bodyLarge!.color,
                              fontFamily: 'InterSemiBold',
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 4),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFDBFCE7).withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Open',
                            style: AppStyles.h5(
                              color: Color(0xFF54B180),
                              fontFamily: 'InterBold',
                            ),
                          ),
                        ),
                      ],
                    ),

                    //  SizedBox(height: 5),
                    SizedBox(height: context.screenHeight * 0.007),

                    // Rating
                    Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                        SizedBox(width: 4),
                        Text(
                          '${serviceModel.averageRating}',
                          style: AppStyles.h6(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                            fontFamily: 'InterSemiBold',
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: context.screenHeight * 0.007),

                    // Distance and Duration
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${serviceModel.distanceInKm} km',
                          style: AppStyles.h6(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                            fontFamily: 'Regular',
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(
                          Icons.access_time,
                          color: Colors.grey[600],
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${serviceModel.serviceDuration}m',
                          style: AppStyles.h6(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                            fontFamily: 'Regular',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.screenHeight * 0.007),
                    Text(
                      serviceModel.isFixedPrice
                          ? 'From \$${serviceModel.servicePrice}'
                          : '\$${serviceModel.servicePrice}',
                      style: AppStyles.h5(
                        color: Color(0xFF54B180),
                        fontFamily: 'InterBold',
                      ),
                    ),

                    SizedBox(height: 10),

                    InkWell(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.garageDetailsScreen,
                          arguments: {
                            'serviceId': serviceModel.id,
                            'garageID': serviceModel.serviceprovider!.id,
                            'serviceName': serviceModel.serviceName,
                          },
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        //width: 90,
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: AppColors.brandGradient,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'View Details',
                          style: AppStyles.h6(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // CustomGradientButton(
                    //   borderRadius: BorderRadius.circular(6),
                    //   onTap: (){
                    //     Get.toNamed(AppRoutes.garageDetailsScreen);
                    //   },
                    //   width: 90,
                    //   height: 35,
                    //   text: 'View Details',
                    //   textStyle: AppStyles.h5(color: AppColors.whiteColor),
                    // )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

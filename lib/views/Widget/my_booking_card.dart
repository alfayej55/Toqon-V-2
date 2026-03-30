import 'package:car_care/models/booking_model.dart';
import 'package:car_care/utils/time_formate.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'package:flutter_svg/svg.dart';

import 'custom_card.dart';

class MyBookingCard extends StatelessWidget {
  final BookingModel bookingModel;

  const MyBookingCard({super.key, required this.bookingModel});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        children: [
          /// Garage Info
          Row(
            children: [
              CustomNetworkImage(
                imageUrl: bookingModel.service!.serviceImage[0].url,
                borderRadius: BorderRadius.circular(14),
                width: 75,
                height: 85,
              ),
              SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.garageDetailsScreen,
                          arguments: {
                            'serviceId': '',
                            'garageID': bookingModel.garage!.id,
                            'serviceName': 'Garage Details',
                          },
                        );
                      },
                      child: Text(
                        bookingModel.garage!.fullName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.h5(),
                      ),
                    ),
                    SizedBox(height: 10),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          AppIcons.locationIcon,
                          colorFilter: ColorFilter.mode(
                            AppColors.primaryColor,
                            BlendMode.srcIn,
                          ),
                          height: 15,
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            bookingModel.garage!.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.h6(
                              color:
                                  Get.theme.textTheme.bodyMedium!.color ??
                                  AppColors.whiteColor.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFDBFCE7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        bookingModel.status,
                        style: AppStyles.h5(color: Color(0xFF54B180)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(height: 1, color: AppColors.borderColor),

          SizedBox(height: 10),
          Row(
            children: [
              Text('Service:', style: AppStyles.h5()),
              Text(bookingModel.service!.serviceName, style: AppStyles.h6()),
            ],
          ),

          SizedBox(height: 10),
          Row(
            children: [
              SvgPicture.asset(AppIcons.calenderIcon, height: 15),
              SizedBox(width: 5),
              Text(
                '${TimeFormatHelper.formatDate(bookingModel.scheduledDate)}, ${bookingModel.scheduledTime}',
                style: AppStyles.h6(),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text('Total:', style: AppStyles.h5()),
              Text(
                '\$${bookingModel.totalAmount}',
                style: AppStyles.h6(color: AppColors.primaryColor),
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(height: 1, color: AppColors.borderColor),
          bookingModel.status == 'pending'
              ? Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.myBookingDetailsScreen,
                            arguments: bookingModel.id,
                          );
                        },
                        child: Text('View Details', style: AppStyles.h5()),
                      ),
                      Container(
                        width: 1,
                        height: 20,
                        color: AppColors.borderColor,
                      ),
                      Text(
                        'Cancel Booking',
                        style: AppStyles.h5(color: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ],
              )
              : InkWell(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.myBookingDetailsScreen,
                    arguments: bookingModel.id,
                  );
                },
                child: Text('View Details', style: AppStyles.h5()),
              ),
        ],
      ),
    );
  }
}

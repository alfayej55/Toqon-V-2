import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';

class VehiclesServiceDetailsCard extends StatelessWidget {
  const VehiclesServiceDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Get.theme.cardColor,
            border: Border.all(
              color: AppColors.borderColor.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              AppStyles.boxShadow
            ]

        ),

        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Oil Change',
              style: AppStyles.h4(),
            ),
            Text(
              '2024-01-15 at 10:30 AM',
              style: AppStyles.h6(color:Theme.of(context).textTheme.bodyMedium!.color),
            ),
            Row(
              children: [
                Text(
                  'Garage :',
                  style: AppStyles.h5(color:Theme.of(context).textTheme.bodyLarge!.color),
                ),
                Text(
                  'Ouick Lube Express',
                  style: AppStyles.h6(color:Theme.of(context).textTheme.bodyMedium!.color),
                ),
              ],
            ),

            SizedBox(height: 15,),
            Row(
              children: [
                Text(
                  'Odometer : ',
                  style: AppStyles.h5(color:Theme.of(context).textTheme.bodyLarge!.color),
                ),
                Text(
                  '53873km',
                  style: AppStyles.h6(color:Theme.of(context).textTheme.bodyMedium!.color),
                ),
              ],
            ),

            Text(
              'Used synthetic oil.replaced filter',
              style: AppStyles.h6(color:Theme.of(context).textTheme.bodyMedium!.color),
            ),
          ],
        ),
        // child: Column(
        //   children: [
        //     Row(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Expanded(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text(
        //                 'My Honda',
        //                 style: AppStyles.h4(fontFamily: 'InterSemiBold'),
        //               ),
        //               Text(
        //                 '2020 Honda Civic',
        //                 style: AppStyles.h6(color:Theme.of(context).textTheme.bodyMedium!.color),
        //               ),
        //               Text(
        //                 'ABC- 1234',
        //                 style: AppStyles.h6(color:Theme.of(context).textTheme.bodyMedium!.color),
        //               ),
        //
        //               SizedBox(height: 15,),
        //               Text(
        //                 '2 services entries record',
        //                 style: AppStyles.h6(color:Theme.of(context).textTheme.bodyMedium!.color),
        //               ),
        //             ],
        //           ),
        //         ),
        //         // Container(
        //         //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        //         //   decoration: BoxDecoration(// Green for "Open Now"
        //         //       borderRadius: BorderRadius.circular(8),
        //         //       border: Border.all(color: AppColors.primaryColor)
        //         //   ),
        //         //   child: Row(
        //         //     children: [
        //         //       SvgPicture.asset(AppIcons.dawnloadIcon),
        //         //       SizedBox(width: 5,),
        //         //       Text(
        //         //         'Export PDF',
        //         //         style: AppStyles.h6(
        //         //           color: AppColors.primaryColor,
        //         //           fontFamily: 'InterBold',
        //         //         ),
        //         //       ),
        //         //     ],
        //         //   ),
        //         // ),
        //       ],
        //     ),
        //
        //   ],
        //
        // )


    );
  }
}

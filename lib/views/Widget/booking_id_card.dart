
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
class BookingIdCard extends StatelessWidget {
  final String? title;
  final String? value;

  const BookingIdCard({super.key,this.title,this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 15),
     // margin: EdgeInsets.only(bottom:  context.screenHeight * 0.014),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color:Get.theme.cardColor,
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          AppStyles.boxShadow
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title??'',
            style: AppStyles.h5(
              fontFamily: 'Regular',
            ),
          ),
          SizedBox(width: 5,),
          Flexible(
            flex: 3,
            child: Text(
              value??'',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.h5(
                fontFamily: 'Regular',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

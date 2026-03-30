import 'package:car_care/extension/contaxt_extension.dart';
import 'package:car_care/views/base/custom_gradiand_button.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Widget/booking_id_card.dart';


class BookingConfirmScreen extends StatelessWidget {
  const BookingConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title:'Service Booking',centerTitle: true,),
      body: SafeArea(top: false, 
          minimum: EdgeInsets.symmetric(horizontal: 24,vertical: 10),
          child: SingleChildScrollView(
            child: Column(
                    children: [
            SizedBox(
              width: context.screenWidth,
              child: DottedBorder(
                options: RectDottedBorderOptions(
                    dashPattern: [8, 5],
                    strokeWidth: 1.5,
                    padding: EdgeInsets.symmetric(horizontal: 8,vertical: 15),
                    color: AppColors.borderColor
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: AppColors.secendaryColor,
                        child: SvgPicture.asset(AppIcons.rightIcon),
            
                      ),
                      SizedBox(height: 5),
            
                      Text(
                          "Booking Confirmed!",
                          style:AppStyles.h3()
                      ),
                      Text(
                          "Your service appointment has been successfully scheduled",
                          textAlign: TextAlign.center,
                          style:AppStyles.h6()
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            
            BookingIdCard(title:'Booking ID',value:'CC-9Y20IUZVT' ,),
            SizedBox(height: 10,),
            BookingIdCard(title:'Service',value:'Oil Change' ,),
            SizedBox(height: 10,),
            BookingIdCard(title:'Provider',value:'Jays Smart Garage' ,),
            SizedBox(height: 10,),
            BookingIdCard(title:'Location',value:'Location' ,),
            SizedBox(height: 10,),
            BookingIdCard(title:'Date & Time',value:'Date & Time' ,),
            SizedBox(height: 10,),
            BookingIdCard(title:'Estimated Duration',value:'30 minutes' ,),
            SizedBox(height: 10,),

            SizedBox(
              width: context.screenWidth,
              child: DottedBorder(
                options: RectDottedBorderOptions(
                    dashPattern: [8, 5],
                    strokeWidth: 1.5,
                    padding: EdgeInsets.symmetric(horizontal: 8,vertical: 15),
                    color: AppColors.borderColor
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                          "Important Information",
                          style:AppStyles.h3()
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                        "• You'll receive a reminder 1 hour before your appointment",
                        textAlign: TextAlign.start,
                        style:AppStyles.h6()
                    ),
                    SizedBox(height: 5),
                    Text(
                        "• Please arrive 5 minutes early",
                        textAlign: TextAlign.start,
                        style:AppStyles.h6()
                    ),
                    SizedBox(height: 5),
                    Text(
                        " • Bring your vehicle registration and any relevant documents",
                        textAlign: TextAlign.start,
                        style:AppStyles.h6()
                    ),
                    SizedBox(height: 5),

                    CustomGradientButton(onTap: (){
                      Get.offAllNamed(AppRoutes.homeScreen);
                    }, text: 'Back Home')

            
            
                  ],
                ),
              ),
            ),
                    ],
                  ),
          )),
    );
  }
}

import 'package:car_care/views/screen/Service/best_price.dart';
import 'package:car_care/views/screen/Service/high_rated.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';

import 'nearest_service.dart';

class ServiceByGarageScreen extends StatefulWidget {
  const ServiceByGarageScreen({super.key});

  @override
  State<ServiceByGarageScreen> createState() => _ServiceByGarageScreenState();
}

class _ServiceByGarageScreenState extends State<ServiceByGarageScreen> {

    var currentIndex = 0;
    var categoryId = Get.arguments['categoryId'];
    var categoryName = Get.arguments['categoryName'];


  final List<String> statusList = [
    'Nearest',
    'High Rated',
    'Best Price'
  ];

  // @override
  // void initState() {
  //   _serviceCtrl.getService(categoryId);
  //   // TODO: implement initState
  //   super.initState();
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(0),
      /// App Bar Section
      appBar: GradientAppBar(title: categoryName ?? '',centerTitle: true,),
      body: SafeArea(top: false, 
          minimum: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: 10),
              /// Tab Bar Section

              Container(
                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),

                  border: Border.all(color: AppColors.borderColor)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var index = 0; index < statusList.length; index++)
                      InkWell(
                        onTap: (){
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: currentIndex == index
                                  ? AppColors.primaryColor
                                  :  Color(0xffA19BAA),
                          ),
                          child:Center(
                            child: Text(
                              statusList[index],
                              style:AppStyles.h5(color: AppColors.whiteColor)
                            ),
                          ) ,
                        ),
                      )

                  ],
                ),
              ),

              SizedBox(height:Dimensions.marginBetweenInputBox),

           /// Garage List Section

              Expanded(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  child: Builder(
                    builder: (context) {
                      switch (currentIndex) {
                        case 0:
                          return  NearestService(categoryId: categoryId,);
                        case 1:
                          return  HighRatedService(categoryId: categoryId,);
                        case 2:
                          return  BestPriceService(categoryId: categoryId,);
                        default:
                          return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),

            ],
          )),
    );
  }}

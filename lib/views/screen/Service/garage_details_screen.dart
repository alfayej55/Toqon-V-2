import 'package:car_care/all_export.dart';
import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../controllers/chat_controller.dart';
import '../../../controllers/service_controller.dart';
import '../../base/custom_button.dart';

class GarageDetailScreen extends StatefulWidget {
  const GarageDetailScreen({super.key});

  @override
  State<GarageDetailScreen> createState() => _GarageDetailScreenState();
}

class _GarageDetailScreenState extends State<GarageDetailScreen> {
  final  ServiceController _serviceCtrl=Get.put(ServiceController());
  final  ChatController _chatCtrl=Get.put(ChatController());
  late String garageID;
  late String serviceId;
  late String serviceName;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    serviceId = args['serviceId'] ?? '';
    garageID = args['garageID'] ?? '';
    serviceName = args['serviceName'] ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _serviceCtrl.profileInfoGet(garageID);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: serviceName,centerTitle: true,),
      body: SafeArea(top: false, 
        minimum: EdgeInsets.symmetric(horizontal: 24,vertical: 10),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 20),
          child: Obx(()=> _serviceCtrl.garageProfileLoading.value?Center(child: CustomPageLoading(),):
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👇 Header Section
              _buildGarageHeader(context),

              SizedBox(height: Dimensions.defultScreenSizeBoxSize),

              // // 👇 Garage Photos Section
              // _buildGaragePhotosSection(context),

              SizedBox(height: Dimensions.heightSize),

              // 👇 Operating Hours
              _buildOperatingHours(context),

              SizedBox(height: 20),

              // 👇 Services & Pricing
              _buildServicesPricing(context),
              SizedBox(height: 20),

              CustomButton(
                  onTap: (){
                    if(serviceId.isNotEmpty){
                      Get.toNamed(AppRoutes.bookingServiceScreen, arguments: {'serviceId': serviceId, 'type': 'manual'});
                    }else{
                      Get.snackbar('Attention', 'Please Select Service');
                    }

                  },
                  text: 'Book Service')

            ],
          ))

        ),
      ),
    );
  }

  // 📍 Header: Name, Rating, Distance, Status
  Widget _buildGarageHeader(BuildContext context , ) {

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
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _serviceCtrl.garegeprofileModel.value.fullName,
                      style: AppStyles.h4(fontFamily: 'InterSemiBold'),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                        SizedBox(width: 4),
                        Text(
                          '${_serviceCtrl.garegeprofileModel.value.averageRating}',
                          style: AppStyles.h6(color:Theme.of(context).textTheme.bodyMedium!.color),
                        ),

                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.grey[600], size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child:
                          Text(
                            '0.5 km away',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.h6( color: Theme.of(context).textTheme.bodyMedium!.color,),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.grey[600], size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _serviceCtrl.garegeprofileModel.value.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.h6( color: Theme.of(context).textTheme.bodyMedium!.color,),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.grey[600], size: 16),
                        SizedBox(width: 8),
                        Text(
                          _serviceCtrl.garegeprofileModel.value.phoneNumber,
                          style: AppStyles.h6( color: Theme.of(context).textTheme.bodyMedium!.color,),
                        ),
                      ],
                    ),


                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF54B180), // Green for "Open Now"
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Open Now',
                  style: AppStyles.h6(
                    color: Colors.white,
                    fontFamily: 'InterBold',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.defultScreenSizeBoxSize),
          Container(
            height: 35,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFFF6B6B)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {
                // Handle chat
                _chatCtrl.createConversations(receiverId: garageID);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppIcons.chatIcon,colorFilter: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),),
                  SizedBox(width: 8),
                  Text(
                    'Chat',
                    style: AppStyles.h5(color: Color(0xFFFF6B6B)),

                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  // ⏰ Operating Hours
  Widget _buildOperatingHours(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.2),
          width: 1,
        ),
        color: Get.theme.cardColor,
        boxShadow: [
          AppStyles.boxShadow
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time, color: AppColors.primaryColor, size: 18),
              SizedBox(width: 8),
              Text(
                'Operating Hours',
                style: AppStyles.h5(
                  fontFamily: 'InterSemiBold',
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ..._serviceCtrl.garegeprofileModel.value.openingHours.map((openingHour) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    openingHour.day,
                    style: AppStyles.h6(
                      color: !openingHour.isOpen
                          ? Colors.red
                          : Get.theme.textTheme.bodyLarge!.color,
                      fontFamily: 'InterSemiBold',
                    ),
                  ),
                  Text(
                    openingHour.isOpen
                        ? '${openingHour.openTime} - ${openingHour.closeTime}'
                        : 'Closed',
                    style: AppStyles.h6(
                      color: !openingHour.isOpen
                          ? Colors.red
                          : Get.theme.textTheme.bodyLarge!.color,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // 💰 Services & Pricing
  Widget _buildServicesPricing(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.2),
          width: 1,
        ),
        color: Get.theme.cardColor,
        boxShadow: [
          AppStyles.boxShadow
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Services & Pricing',
            style: AppStyles.h5(
              fontFamily: 'InterSemiBold',
            ),
          ),
          SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _serviceCtrl.garegeprofileModel.value.services.length,
            itemBuilder: (context, index) {
              var serviceInfo = _serviceCtrl.garegeprofileModel.value.services[index];
              return InkWell(
                onTap: (){

                  Get.toNamed(AppRoutes.bookingServiceScreen, arguments: {'serviceId': serviceInfo.id, 'type': 'manual'});

                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.greyColor.withValues(alpha: 0.09),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serviceInfo.serviceName,
                            style: AppStyles.h5(
                              fontFamily: 'InterSemiBold',
                            ),
                          ),
                          Text(
                            '${serviceInfo.serviceDuration} min',
                            style: AppStyles.h6(
                              color: Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '\$${serviceInfo.servicePrice}',
                        style: AppStyles.h6(
                          color: AppColors.primaryColor,
                          fontFamily: 'InterBold',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
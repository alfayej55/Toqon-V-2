import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../controllers/chat_controller.dart';
import '../../../controllers/service_controller.dart';
import '../../Widget/custom_card.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  final ServiceController controller = Get.find<ServiceController>();
  final  ChatController _chatCtrl=Get.put(ChatController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      final bookingId = Get.arguments as String?;
      if (bookingId != null) {
      await  controller.getBookingDetails(bookingId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: 'My Booking', centerTitle: true),
      body: Obx(() {
        if (controller.bookingDetailsLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final booking = controller.bookingDetails.value;

        return SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Garage Info
                _buildGarageHeader(context, booking),
                SizedBox(height: 20),

                /// Service Info
                Text("Services information", style: AppStyles.h2()),
                CustomCard(
                  child: Column(
                    children: [
                      serviceInfo('Service', booking.service?.serviceName ?? 'N/A'),
                      SizedBox(height: 8),
                      serviceInfo('Scheduled Date', _formatDate(booking.scheduledDate)),
                      SizedBox(height: 8),
                      serviceInfo('Scheduled Time', booking.scheduledTime),
                      SizedBox(height: 8),
                      serviceInfo('Customer Phone', booking.user?.phoneNumber ?? 'N/A'),
                      SizedBox(height: 8),
                      serviceInfo('Payment Status', booking.paymentStatus),
                      SizedBox(height: 8),
                      serviceInfo('Payment Method', booking.paymentMethod),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Price', style: AppStyles.h5()),
                          Flexible(
                            child: Text(
                              '\$${booking.totalAmount}',
                              style: AppStyles.h4(color: AppColors.primaryColor),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                /// Vehicle Info
                if (booking.vehicle != null) ...[
                  SizedBox(height: 20),
                  Text("Vehicle Information", style: AppStyles.h2()),
                  CustomCard(
                    child: Column(
                      children: [
                        serviceInfo('Vehicle Name', booking.vehicle?.vehicleName ?? 'N/A'),
                        SizedBox(height: 8),
                        serviceInfo('Manufacturer', booking.vehicle?.manufacturer ?? 'N/A'),
                        SizedBox(height: 8),
                        serviceInfo('Model', booking.vehicle?.model ?? 'N/A'),
                        SizedBox(height: 8),
                        serviceInfo('Registration', booking.vehicle?.registrationNumber ?? 'N/A'),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 5,),
                /// Service Details
                Text("Service Details", style: AppStyles.h2()),
                CustomCard(
                  child: Center(
                    child: Text(
                      booking.service?.serviceDetails ?? '',
                      style: AppStyles.h5(),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  Widget serviceInfo(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppStyles.h4(), textAlign: TextAlign.end),
        SizedBox(width: 10),
        Flexible(
          child: Text(
            value,
            style: AppStyles.h5(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  /// Garage Info
  Widget _buildGarageHeader(BuildContext context, dynamic booking) {
    final garage = booking.garage;

    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Get.theme.cardColor,
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [AppStyles.boxShadow],
      ),
      child: Column(
        children: [
          /// Garage Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      garage?.fullName ?? 'Garage',
                      style: AppStyles.h4(fontFamily: 'InterSemiBold'),
                    ),
                    SizedBox(height: 8),
                    _buildRowWithIcon(context, Icons.location_on_outlined, garage.address ?? 'N/A'),
                    SizedBox(height: 8),
                    _buildRowWithIcon(context, Icons.phone, garage.phoneNumber ?? 'N/A'),
                    SizedBox(height: 8),
                    _buildRowWithIcon(context, Icons.email_outlined, garage.email ?? 'N/A'),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(booking.status),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  booking.status.toString().capitalize ?? '',
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
                _chatCtrl.createConversations(receiverId: garage.id);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppIcons.chatIcon,
                    colorFilter: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
                  ),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'completed':
        return Color(0xFF54B180);
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Generic row builder method
  Widget _buildRowWithIcon(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).textTheme.bodyMedium!.color, size: 16),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.h6(color: Theme.of(context).textTheme.bodyMedium!.color),
          ),
        ),
      ],
    );
  }
}
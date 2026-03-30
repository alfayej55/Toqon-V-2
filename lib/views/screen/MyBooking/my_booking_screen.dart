// import 'package:flutter/material.dart';
// import 'package:car_care/all_export.dart';
//
// import '../../Widget/my_booking_card.dart';
// class MyBookingScreen extends StatelessWidget {
//   const MyBookingScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: GradientAppBar(title:'My Booking',centerTitle: true,),
//
//     body: SafeArea(
//       minimum: EdgeInsets.symmetric(horizontal: 20),
//       child: ListView(
//         children: [
//           ListView.builder(
//              itemCount: 5,
//               shrinkWrap: true,
//               primary: false,
//               itemBuilder: (context,index){
//
//             return MyBookingCard();
//
//           })
//         ],
//       ),
//     ),
//
//     );
//
//   }
// }

import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';

import 'AllRequest/accepted_screen.dart';
import 'AllRequest/active_screen.dart';
import 'AllRequest/compeleted_screen.dart';
import 'AllRequest/new_request_screen.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({super.key});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(0),

      appBar: AppBar(
        title: Text('My Booking', style: TextStyle(color: Get.theme.textTheme.bodyLarge!.color)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Get.theme.textTheme.bodyLarge!.color),
          onPressed: NavigationHelper.backOrHome,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Get.theme.primaryColor,
          isScrollable: false,
          labelColor: Get.theme.primaryColor,
          unselectedLabelColor: Get.theme.textTheme.bodyMedium!.color,
          labelStyle: AppStyles.h4(),
          padding: EdgeInsets.zero,
          tabs: const [

            Tab(text: 'Request'),
            Tab(text: 'Accept'),
            Tab(text: 'Active'),
            Tab(text: 'Completed'),

          ],
        ),
      ),

      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [

                  NewRequestScreen(),
                  AcceptedScreen(),
                  ActiveScreen(),
                  CompeletedScreen(),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

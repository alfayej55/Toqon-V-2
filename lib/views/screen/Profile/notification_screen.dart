import 'package:car_care/controllers/notification_controller.dart';
import 'package:car_care/utils/time_formate.dart';
import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController _notificationCtrl = Get.put(
    NotificationController(),
  );
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _notificationCtrl.getNotifications();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: 'Notifications'),
      body: Obx(
        () =>
            _notificationCtrl.notificationLoading.value
                ? Center(child: CustomPageLoading())
                : SafeArea(
                  minimum: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          itemCount: _notificationCtrl.notificationList.length,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            var notificationInfo =
                                _notificationCtrl.notificationList[index];

                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Get.theme.cardColor,
                                border: Border.all(
                                  color: AppColors.borderColor.withValues(
                                    alpha: 0.2,
                                  ),
                                  width: 1,
                                ),
                                boxShadow: [AppStyles.boxShadow],
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                titleAlignment: ListTileTitleAlignment.top,
                                leading: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: AppColors.primaryColor,
                                  child: SvgPicture.asset(AppIcons.rewordIcon),
                                ),
                                title: Text(
                                  notificationInfo.title,
                                  style: AppStyles.h4(),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    final removed =
                                        _notificationCtrl
                                            .notificationList[index];
                                    _notificationCtrl.notificationList.removeAt(
                                      index,
                                    );
                                    Get.snackbar(
                                      'Removed',
                                      'Notification deleted',
                                      snackPosition: SnackPosition.BOTTOM,
                                      mainButton: TextButton(
                                        onPressed: () {
                                          final restoreIndex = index.clamp(
                                            0,
                                            _notificationCtrl
                                                .notificationList
                                                .length,
                                          );
                                          _notificationCtrl.notificationList
                                              .insert(restoreIndex, removed);
                                          Get.closeCurrentSnackbar();
                                        },
                                        child: const Text('Undo'),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notificationInfo.content,
                                      style: AppStyles.h6(
                                        color:
                                            Get
                                                .theme
                                                .textTheme
                                                .bodyMedium!
                                                .color ??
                                            AppColors.whiteColor.withValues(
                                              alpha: 0.9,
                                            ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      TimeFormatHelper.timeAgo(
                                        notificationInfo.updatedAt,
                                      ),
                                      style: AppStyles.h6(
                                        color:
                                            Get
                                                .theme
                                                .textTheme
                                                .bodyMedium!
                                                .color ??
                                            AppColors.whiteColor.withValues(
                                              alpha: 0.9,
                                            ),
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
                  ),
                ),
      ),
    );
  }
}

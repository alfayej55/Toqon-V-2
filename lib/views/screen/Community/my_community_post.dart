import 'package:car_care/views/Widget/my_community_card.dart';
import 'package:car_care/views/base/custom_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';

import '../../../controllers/community_controller.dart';
import '../../base/custom_page_loading.dart';

class MyCommunityPost extends StatefulWidget {
  const MyCommunityPost({super.key});

  @override
  State<MyCommunityPost> createState() => _MyCommunityPostState();
}

class _MyCommunityPostState extends State<MyCommunityPost> {
  final TextEditingController searchCTrl = TextEditingController();
  final CommunityController _communityCtrl = Get.put(CommunityController());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _communityCtrl.myCommunityGet();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: 'My Community'),
      body: SafeArea(top: false, 
        minimum: EdgeInsets.only(left: 24, right: 24, top: 15),
        child: Column(
          children: [
            CustomTextField(
              controller: searchCTrl,
              hintText: 'Search',
              contenpaddingVertical: 12,
            ),
            Obx(() {
              if (_communityCtrl.myPostLoading.value) {
                return Center(child: CustomPageLoading());
              }
              if (_communityCtrl.myPostList.isEmpty) {
                return Expanded(
                  child: CustomEmptyState(
                    icon: AppIcons.mypostIcon,
                    title: 'No Posts Yet',
                    subtitle: 'Your community posts will appear here',
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: _communityCtrl.myPostList.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    var communityInfo = _communityCtrl.myPostList[index];
                    return MyCommunityCard(
                      index: index,
                      communityModel: communityInfo,
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

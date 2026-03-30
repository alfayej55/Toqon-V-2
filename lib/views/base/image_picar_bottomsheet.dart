import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ImagePicarBottomsheet extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;
  const ImagePicarBottomsheet({super.key,
    required this.onGalleryTap,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 7.2,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  onGalleryTap();
                },
                child: SizedBox(
                  child: Column(
                    children: [
                      Icon(
                        Icons.image,
                        size: 50,
                        color:Get.theme.primaryColor,
                      ),
                      Text('Gallery')
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  onCameraTap();
                },
                child: SizedBox(
                  child: Column(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 50,
                        color:Get.theme.primaryColor,
                      ),
                      Text('Camera')
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

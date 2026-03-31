import 'dart:ui';

import 'package:car_care/controllers/locations_controller.dart';
import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../service/api_constants.dart';

class LocationScreen extends StatefulWidget {
   const LocationScreen({super.key});
  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  GoogleMapController? _mapController;
  int _activeLegend = -1;
  int _legendPulse = 0;

  final LocationController _locationCtrl = Get.put(LocationController());

  static const String _darkMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#101725"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#95A4C4"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#101725"}]},
  {"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#25324A"}]},
  {"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#7F8EAE"}]},
  {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#142438"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#1A2538"}]},
  {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#0E1626"}]},
  {"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8E9FBE"}]},
  {"featureType":"transit","elementType":"geometry","stylers":[{"color":"#182339"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#0B1A2B"}]},
  {"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#6D829F"}]}
]
''';

  @override
  void initState() {
    super.initState();
    _locationCtrl. getCurrentLocation();
    _locationCtrl. getGarage();
    // Listen for location changes and animate camera
    ever(_locationCtrl.currentLocation, (LatLng location) {
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(location),
        );
      }
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Get.isDarkMode;
    return Scaffold(
      bottomNavigationBar: BottomMenu(1),
      //appBar: GradientAppBar(title:'Find Service',centerTitle: true,),

      body: Obx(()=>_locationCtrl.garageLoading.value?Center(child: CustomPageLoading(),): Stack(
        //alignment:Alignment.bottomLeft,
        children: [
          Obx(() => GoogleMap(
            key: ValueKey(ApiConstants.mapKey),
            style: isDark ? _darkMapStyle : null,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _locationCtrl.markerList.toSet(),
            initialCameraPosition: CameraPosition(
              target: _locationCtrl.currentLocation.value,
              zoom: 14.00,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              // Move camera to current location when map is created
              if (!_locationCtrl.locationLoading.value) {
                controller.animateCamera(
                  CameraUpdate.newLatLng(_locationCtrl.currentLocation.value),
                );
              }
            },
          )),
          Positioned(
            bottom: 25,
            left: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.42),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFFFFFF).withValues(alpha: 0.56),
                        const Color(0xFFFFFFFF).withValues(alpha: 0.44),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _legendItem(
                        index: 0,
                        dotColor: Colors.orange,
                        iconPath: AppIcons.torqonLogoIcon,
                        iconColor: Colors.orange,
                        label: 'Torqon Garage',
                      ),
                      const SizedBox(height: 8),
                      _legendItem(
                        index: 1,
                        dotColor: Colors.deepPurple,
                        iconPath: AppIcons.patnerIcon,
                        iconColor: Colors.deepPurple,
                        label: 'Partner Garage',
                      ),
                      const SizedBox(height: 8),
                      _legendItem(
                        index: 2,
                        dotColor: Colors.red,
                        iconPath: AppIcons.serviceIcon,
                        iconColor: Colors.red,
                        label: 'Service Point',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),)


    );
  }

  Widget _legendItem({
    required int index,
    required Color dotColor,
    required String iconPath,
    required Color iconColor,
    required String label,
  }) {
    final bool isActive = _activeLegend == index;
    return InkWell(
      onTap: () {
        setState(() {
          _activeLegend = isActive ? -1 : index;
          _legendPulse++;
        });
      },
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color:
              isActive
                  ? Colors.white.withValues(alpha: 0.42)
                  : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 5, backgroundColor: dotColor),
            const SizedBox(width: 6),
            TweenAnimationBuilder<double>(
              key: ValueKey('legend-icon-$index-${isActive ? _legendPulse : 0}'),
              tween: Tween<double>(begin: 0, end: isActive ? 1 : 0),
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return Transform.rotate(
                  angle: (1 - value) * 0.45,
                  child: Transform.scale(
                    scale: 1 + (0.16 * value),
                    child: SvgPicture.asset(
                      iconPath,
                      height: 18,
                      width: 18,
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    ),
                  ),
                );
              },
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              width: isActive ? 112 : 0,
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 220),
              opacity: isActive ? 1 : 0,
              child: isActive
                  ? Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.customSize(
                        size: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A2538),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

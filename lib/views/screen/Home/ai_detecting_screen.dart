import 'dart:io';

import 'package:car_care/all_export.dart';
import 'package:car_care/controllers/ai_controller.dart';
import 'package:car_care/extension/contaxt_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../base/image_picar_bottomsheet.dart';

class AiDetectingScreen extends StatefulWidget {
  const AiDetectingScreen({super.key});
  @override
  State<AiDetectingScreen> createState() => _AiDetectingScreenState();
}

class _AiTipChip extends StatelessWidget {
  final String label;
  const _AiTipChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color:
            Get.isDarkMode
                ? Colors.white.withValues(alpha: 0.06)
                : const Color(0xFFF8FAFC),
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.35),
        ),
      ),
      child: Text(
        label,
        style: AppStyles.customSize(
          size: 10,
          fontFamily: 'InterSemiBold',
          color: Get.theme.textTheme.bodyLarge?.color,
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}

class _AiDetectingScreenState extends State<AiDetectingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final AiDamageController aiDamageCtrl = Get.put(AiDamageController());
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    // Future.delayed(Duration(seconds: 5),()async{
    //   Get.offAllNamed(AppRoutes.homeScreen);
    // });
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _speech.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final padding = screenWidth * 0.04;
    final bool isDark = Get.isDarkMode;

    return Scaffold(
      appBar: GradientAppBar(title: 'CARA'),
      body: Stack(
        children: [
          Positioned(
            top: 70,
            right: -70,
            child: _bgGlow(const Color(0x2AF08E2F), 220),
          ),
          Positioned(
            top: 270,
            left: -80,
            child: _bgGlow(const Color(0x2691244E), 250),
          ),
          SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Obx(
              () => Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child:
                          aiDamageCtrl.aiDamageLoading.value
                              ? aiShimmerWidget(padding, context)
                              : aiResultWidget(padding, context),
                    ),
                  ),
                  if (aiDamageCtrl.imagesPath.value.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color:
                            isDark
                                ? Colors.white.withValues(alpha: 0.06)
                                : Colors.white,
                        border: Border.all(
                          color: AppColors.brandPrimary.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(aiDamageCtrl.imagesPath.value),
                              height: 92,
                              width: 132,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: -2,
                            top: -2,
                            child: InkWell(
                              onTap: () {
                                aiDamageCtrl.selectedImage = null;
                                aiDamageCtrl.imagesPath.value = '';
                              },
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFE44646),
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  _composerBar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bgGlow(Color color, double size) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
            stops: const [0.0, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _composerBar() {
    final bool isDark = Get.isDarkMode;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _circleAction(
                iconPath: AppIcons.fileIcon,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (builder) {
                      return ImagePicarBottomsheet(
                        onGalleryTap: () {
                          aiDamageCtrl.pickImages(ImageSource.gallery);
                        },
                        onCameraTap: () {
                          aiDamageCtrl.pickImages(ImageSource.camera);
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: aiDamageCtrl.aiDamageTextCtrl,
                  minLines: 1,
                  maxLines: 4,
                  style: AppStyles.h5(fontFamily: 'InterMedium'),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText:
                        _isListening
                            ? 'Listening... speak now'
                            : 'Describe your issue for instant trusted guidance...',
                    hintStyle: AppStyles.h5(color: AppColors.subTextColor),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _iconCircleAction(
                icon: _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                onTap: _toggleSpeechToText,
              ),
              const SizedBox(width: 8),
              _circleAction(
                iconPath: AppIcons.sentIcon,
                onTap: aiDamageCtrl.postAiDamage,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleAction({
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: AppColors.brandGradient),
        ),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            height: 18,
            width: 18,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  Widget _iconCircleAction({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(colors: AppColors.brandGradient),
          boxShadow:
              _isListening
                  ? [
                    BoxShadow(
                      color: AppColors.brandPrimary.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : null,
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }

  Future<void> _toggleSpeechToText() async {
    if (_isListening) {
      await _speech.stop();
      if (mounted) setState(() => _isListening = false);
      return;
    }

    final bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted) setState(() => _isListening = false);
        }
      },
      onError: (_) {
        if (mounted) setState(() => _isListening = false);
      },
    );

    if (!available) {
      Get.snackbar(
        'Voice Unavailable',
        'Microphone permission or speech service is unavailable.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => _isListening = true);
    await _speech.listen(
      onResult: (result) {
        final String spoken = result.recognizedWords.trim();
        if (spoken.isEmpty) return;
        aiDamageCtrl.aiDamageTextCtrl.text = spoken;
        aiDamageCtrl.aiDamageTextCtrl.selection = TextSelection.fromPosition(
          TextPosition(offset: aiDamageCtrl.aiDamageTextCtrl.text.length),
        );
      },
    );
  }

  aiResultWidget(double padding, BuildContext context) {
    /// Empty State
    if (aiDamageCtrl.conversationList.isEmpty) {
      final bool isDark = Get.isDarkMode;
      return Padding(
        padding: const EdgeInsets.fromLTRB(2, 48, 2, 20),
        child: Column(
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: AppColors.brandGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brandPrimary.withValues(alpha: 0.32),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipOval(
                child: Lottie.asset(
                  'assets/lottie/Robot-Bot 3D.json',
                  fit: BoxFit.cover,
                  repeat: true,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "MEET CARA",
              style: AppStyles.customSize(
                size: 13,
                fontFamily: 'RushDriverItalic',
                letterSpacing: 1.0,
                color: AppColors.brandPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Instant damage intelligence for your next move",
              style: AppStyles.h3(
                color: Get.theme.textTheme.bodyLarge?.color,
                fontFamily: 'InterSemiBold',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color:
                    isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.white,
                border: Border.all(
                  color: AppColors.borderColor.withValues(alpha: 0.35),
                ),
              ),
              child: Text(
                "Upload a photo or send a message. I will detect damage, estimate cost range, and recommend service types nearby.",
                style: AppStyles.h5(
                  color: AppColors.subTextColor,
                  fontFamily: 'InterMedium',
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: const [
                _AiTipChip(label: 'DAMAGE SCAN'),
                _AiTipChip(label: 'COST ESTIMATE'),
                _AiTipChip(label: 'NEARBY GARAGES'),
              ],
            ),
            const SizedBox(height: 16),
            Icon(
              Icons.keyboard_double_arrow_down_rounded,
              size: 28,
              color: AppColors.brandPrimary.withValues(alpha: 0.62),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: aiDamageCtrl.conversationList.length,
      itemBuilder: (context, index) {
        final conversation = aiDamageCtrl.conversationList[index];
        final answer = conversation.answer;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Question Image
            if (conversation.question.imageUrl != null)
              CustomNetworkImage(
                imageUrl: conversation.question.imageUrl!,
                borderRadius: BorderRadius.circular(12),
                width: context.screenWidth,
                height: context.screenHeight * .28,
              ),
            if (conversation.question.imageUrl != null)
              SizedBox(height: Dimensions.heightSize),

            /// Question Content
            if (conversation.question.content.isNotEmpty)
              Container(
                padding: EdgeInsets.all(padding),
                margin: EdgeInsets.only(bottom: Dimensions.heightSize),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  conversation.question.content,
                  style: AppStyles.h5(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ),

            /// Answer Section
            Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.borderColor.withValues(alpha: 0.35),
                ),
                borderRadius: BorderRadius.circular(16),
                color:
                    Get.isDarkMode
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    titleAlignment: ListTileTitleAlignment.top,
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryColor.withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        Icons.smart_toy,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    title: Text(
                      "Damage Detected",
                      style: AppStyles.h4(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                  ),
                  SizedBox(height: padding / 2),

                  /// Probable Vehicle
                  if (answer.probableVehicle.make != null) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.directions_car,
                          size: 18,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Vehicle: ${answer.probableVehicle.make ?? ''} ${answer.probableVehicle.model ?? ''} ${answer.probableVehicle.year ?? ''}"
                              .trim(),
                          style: AppStyles.h6(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: padding / 2),
                  ],

                  /// Damage
                  Text(
                    answer.damage,
                    style: AppStyles.h5(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontFamily: 'Regular',
                    ),
                  ),
                  SizedBox(height: padding / 2),

                  /// Severity with color
                  Row(
                    children: [
                      Text(
                        "Severity: ",
                        style: AppStyles.h6(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              answer.severity.toLowerCase() == 'severe'
                                  ? Colors.red.withValues(alpha: 0.2)
                                  : answer.severity.toLowerCase() == 'moderate'
                                  ? Colors.orange.withValues(alpha: 0.2)
                                  : Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          answer.severity.toUpperCase(),
                          style: AppStyles.h6(
                            color:
                                answer.severity.toLowerCase() == 'severe'
                                    ? Colors.red
                                    : answer.severity.toLowerCase() ==
                                        'moderate'
                                    ? Colors.orange
                                    : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: padding / 2),

                  /// Repair Urgency
                  if (answer.repairUrgency.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 18, color: Colors.orange),
                        SizedBox(width: 6),
                        Text(
                          "Urgency: ${answer.repairUrgency}",
                          style: AppStyles.h6(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: padding / 2),
                  ],

                  /// Affected Parts
                  if (answer.affectedParts.isNotEmpty) ...[
                    Text(
                      "Affected Parts:",
                      style: AppStyles.h6(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                    SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children:
                          answer.affectedParts
                              .map(
                                (part) => Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.primaryColor.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    part,
                                    style: AppStyles.h6(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    SizedBox(height: padding / 2),
                  ],

                  /// Suggested Service Types
                  if (answer.suggestedServiceTypes.isNotEmpty) ...[
                    Text(
                      "Suggested Services:",
                      style: AppStyles.h6(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                    SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children:
                          answer.suggestedServiceTypes
                              .map(
                                (service) => Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.blue.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Text(
                                    service,
                                    style: AppStyles.h6(color: Colors.blue),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    SizedBox(height: padding / 2),
                  ],

                  /// Additional Notes
                  if (answer.additionalNotes.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.amber.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: Colors.amber[700],
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              answer.additionalNotes,
                              style: AppStyles.h6(
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: Dimensions.heightSize),

            /// Estimated Cost Section
            Container(
              padding: EdgeInsets.all(Dimensions.paddingSize),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.brandPrimary.withValues(alpha: 0.22),
                    AppColors.brandWarm.withValues(alpha: 0.16),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: AppColors.brandPrimary.withValues(alpha: 0.25),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.attach_money, color: Colors.red, size: 27),
                      SizedBox(width: 8),
                      Text(
                        "Estimated Repair Cost",
                        style: AppStyles.h5(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: padding * 0.8),
                  Text(
                    "${answer.estimatedCost.currency} ${answer.estimatedCost.min} - ${answer.estimatedCost.max}",
                    style: AppStyles.h1(color: AppColors.primaryColor),
                  ),
                  SizedBox(height: padding * 0.5),
                  Text(
                    answer.solution,
                    style: AppStyles.h6(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => Get.toNamed(AppRoutes.serviceScreen),
              child: Container(
                width: context.screenWidth * 0.42,
                height: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: const LinearGradient(
                    colors: AppColors.brandGradient,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'VIEW NEARBY GARAGES',
                  style: AppStyles.customSize(
                    size: 10,
                    fontFamily: 'InterSemiBold',
                    letterSpacing: 0.6,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.heightSize),
          ],
        );
      },
    );
  }

  /// Shimmer Loading Widget
  Widget aiShimmerWidget(double padding, BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Answer Section Shimmer
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      width: 150,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: padding),
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: context.screenWidth * 0.7,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  width: context.screenWidth * 0.5,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.heightSize),

          /// Estimated Cost Shimmer
          Container(
            padding: EdgeInsets.all(Dimensions.paddingSize),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 27,
                      height: 27,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 150,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: padding * 0.8),
                Container(
                  width: 180,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: padding * 0.5),
                Container(
                  width: double.infinity,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  aiInitialWidget(
    double padding,
    BuildContext context,
    double iconSize,
    double fontSizeSmall,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderColor),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CustomNetworkImage(
                  imageUrl:
                      'https://media.istockphoto.com/id/172181182/photo/silver-car-with-a-large-dent-in-the-side-ruining-two-doors.jpg?s=612x612&w=0&k=20&c=UkwPIvW3rT49RiwQYc-Z8849Ee5QbFkPbolJ8kMtXog=',
                  boxShape: BoxShape.circle,
                  width: 44,
                  height: 44,
                ),
                title: Text(
                  "Hi! I'm CareChat, Your AI Auto Assistant. 👋",

                  style: AppStyles.h4(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              SizedBox(height: padding / 2),
              Text(
                "Upload a photo of your car issue, or describe what's happening, and I'll help diagnose the problem and find you the best service providers nearby!",
                style: AppStyles.h5(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  fontFamily: 'Regular',
                ),
                textAlign: TextAlign.start,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(height: padding),

        //       InkWell(
        //   onTap: (){
        //     showModalBottomSheet(
        //       context: context,
        //       builder: (builder) {
        //         return ImagePicarBottomsheet(
        //           onGalleryTap: () {
        //             //_profileCtrl.pickImageFromCamera(ImageSource.gallery);
        //           },
        //           onCameraTap: () {
        //             //_profileCtrl.pickImageFromCamera(ImageSource.camera);
        //           },
        //         );
        //       },
        //     );
        //
        //   },
        //   child: Container(
        //     width: context.screenWidth,
        //     child: DottedBorder(
        //       options: RectDottedBorderOptions(
        //         dashPattern: [10, 5],
        //         strokeWidth: 1.5,
        //         padding: EdgeInsets.all(8)
        //       ),
        //       child: Align(
        //         alignment: Alignment.center,
        //         child: Column(
        //           children: [
        //             Icon(Icons.camera_alt, size: iconSize),
        //             SizedBox(height: padding / 2),
        //             Text(
        //               "Upload Car Issue Photo",
        //               textAlign: TextAlign.center,
        //               style: AppStyles.h5(fontFamily: 'Regular'),
        //             ),
        //
        //             SizedBox(height: padding / 4),
        //             Text(
        //               "Tap to select image",
        //               textAlign: TextAlign.center,
        //               style: TextStyle(
        //                 fontSize: fontSizeSmall,
        //                 color: Colors.grey[600],
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}

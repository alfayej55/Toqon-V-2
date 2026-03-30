import 'package:car_care/controllers/service_controller.dart';
import 'package:car_care/models/catagori_model.dart';
import 'package:car_care/views/Widget/services_caragori_card.dart';
import 'package:car_care/views/base/custom_empty_state.dart';
import 'package:car_care/views/base/custom_page_loading.dart';
import 'package:flutter/material.dart';
import 'package:car_care/all_export.dart';

class ServiceCategoryScreen extends StatefulWidget {
  const ServiceCategoryScreen({super.key});

  @override
  State<ServiceCategoryScreen> createState() => _ServiceCategoryScreenState();
}

class _ServiceCategoryScreenState extends State<ServiceCategoryScreen> {
  final ServiceController _categoryCtrl = Get.put(ServiceController());
  final TextEditingController _searchCtrl = TextEditingController();
  final RxString _selectedFilter = 'ALL'.obs;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomMenu(0),
      appBar: GradientAppBar(title: AppString.serviceText, centerTitle: true),
      body: SafeArea(top: false, 
        minimum: const EdgeInsets.symmetric(horizontal: 12),
        child: Obx(() {
          if (_categoryCtrl.catagoryLoading.value) {
            return const Center(child: CustomPageLoading());
          }

          final List<CategoryModel> categories = _filteredCategories();

          return Column(
            children: [
              const SizedBox(height: 8),
              _servicesHero(),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _searchCtrl,
                hintText: 'Search services and categories',
                contenpaddingVertical: 12,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),
              _filterChips(),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${categories.length} CATEGORIES',
                  style: AppStyles.h6(
                    color: AppColors.subTextColor,
                    fontFamily: 'InterSemiBold',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child:
                    categories.isEmpty
                        ? CustomEmptyState(
                          icon: AppIcons.serviceIcon,
                          title: 'No Matching Categories',
                          subtitle:
                              'Try another keyword or filter to discover services.',
                        )
                        : ListView.builder(
                          itemCount: categories.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final categoryInfo = categories[index];
                            return InkWell(
                              onTap: () {
                                Get.toNamed(
                                  AppRoutes.serviceByGarageScreen,
                                  arguments: {
                                    'categoryId': categoryInfo.id,
                                    'categoryName': categoryInfo.categoryName,
                                  },
                                );
                              },
                              child: ServiceCategoryCardWidget(
                                categoryModel: categoryInfo,
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _servicesHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(colors: AppColors.brandGradient),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SMART SERVICE DISCOVERY',
                  style: AppStyles.h6(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontFamily: 'InterSemiBold',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Explore maintenance, emergency, detailing and more.',
                  style: AppStyles.h6(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChips() {
    final List<String> chips = [
      'ALL',
      'POPULAR',
      'EMERGENCY',
      ..._categoryCtrl.categoryList
          .map((c) => c.categoryType.trim().toUpperCase())
          .where((v) => v.isNotEmpty)
          .toSet(),
    ];

    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final String chip = chips[index];
          final bool isSelected = _selectedFilter.value == chip;
          return InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => _selectedFilter.value = chip,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient:
                    isSelected
                        ? const LinearGradient(colors: AppColors.brandGradient)
                        : null,
                color:
                    isSelected
                        ? null
                        : (Get.isDarkMode
                            ? AppColors.cardLightColor.withValues(alpha: 0.65)
                            : Colors.white.withValues(alpha: 0.95)),
                border: Border.all(
                  color:
                      isSelected
                          ? Colors.white.withValues(alpha: 0.28)
                          : AppColors.borderColor.withValues(alpha: 0.35),
                ),
              ),
              child: Text(
                chip,
                style: AppStyles.h6(
                  color: isSelected ? Colors.white : AppColors.subTextColor,
                  fontFamily: 'InterSemiBold',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<CategoryModel> _filteredCategories() {
    final String query = _searchCtrl.text.trim().toLowerCase();
    final String filter = _selectedFilter.value;

    List<CategoryModel> list = List<CategoryModel>.from(_categoryCtrl.categoryList);

    if (filter == 'POPULAR') {
      list = list.where((c) => c.isPopular).toList();
    } else if (filter == 'EMERGENCY') {
      list = list.where((c) => c.isEmergency).toList();
    } else if (filter != 'ALL') {
      list =
          list
              .where((c) => c.categoryType.trim().toUpperCase() == filter)
              .toList();
    }

    if (query.isNotEmpty) {
      list =
          list
              .where(
                (c) =>
                    c.categoryName.toLowerCase().contains(query) ||
                    c.categoryDescription.toLowerCase().contains(query) ||
                    c.categoryType.toLowerCase().contains(query),
              )
              .toList();
    }

    list.sort((a, b) {
      if (a.isPopular == b.isPopular) {
        return b.nearbyServiceCount.compareTo(a.nearbyServiceCount);
      }
      return a.isPopular ? -1 : 1;
    });

    return list;
  }
}

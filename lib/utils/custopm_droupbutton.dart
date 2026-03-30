
import 'package:car_care/all_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final String hint;
  final void Function(T?) onChanged;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.hint,
    required this.onChanged,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  T? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: AppStyles.h4(color: Get.theme.textTheme.bodyMedium!.color ?? AppColors.whiteColor.withValues(alpha: 0.9),),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(8),
        //   borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        // ),
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(8),
        //   borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(8),
        //   borderSide: BorderSide(color: Colors.blue, width: 2.0),
        // ),
        // errorBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(8),
        //   borderSide: BorderSide(color: Colors.red, width: 2.0),
        // ),
        // focusedErrorBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(8),
        //   borderSide: BorderSide(color: Colors.red, width: 2.0),
        // ),
        suffixIcon: SvgPicture.asset(AppIcons.arrowIcon,height:3),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
      initialValue: selectedValue,
      onChanged: (T? newValue) {
        setState(() {
          selectedValue = newValue;
        });
        widget.onChanged(newValue);
      },
      items: widget.items.map<DropdownMenuItem<T>>((T value) {
        return DropdownMenuItem<T>(

          value: value,
          child: Text(value.toString(), style: AppStyles.h5(color: Get.theme.textTheme.bodyMedium!.color ?? AppColors.whiteColor.withValues(alpha: 0.9),),),
        );
      }).toList(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:car_care/all_export.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscureCharacrter;
  final Color? filColor;
  final Color? borderColor;
  final TextStyle? textStyle;
  final int? maxLines;
  final int? minLines;
  final Widget? prefixIcon;
  final String? labelText;
  final String? hintText;
  final double? contenpaddingHorizontal;
  final double? contenpaddingVertical;
  final Widget? suffixIcons;
  final FormFieldValidator? validator;
  final VoidCallback? onTab;
  final ValueChanged<String>? onChanged;
  final bool isPassword;
  final bool? isEmail;
  final bool? readOnly;

  const CustomTextField({
    super.key,
    this.contenpaddingHorizontal,
    this.contenpaddingVertical,
    this.hintText,
    this.prefixIcon,
    this.textStyle,
    this.suffixIcons,
    this.validator,
    this.borderColor,
    this.isEmail,
    required this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.isObscureText = false,
    this.obscureCharacrter = '*',
    this.filColor,
    this.maxLines = 1,
    this.minLines,
    this.labelText,
    this.isPassword = false,
    this.readOnly = false,
    this.onTab,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      onTap: widget.onTab,
      onChanged: widget.onChanged,
      readOnly: widget.readOnly ?? false,
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      obscuringCharacter: widget.obscureCharacrter ?? '*',
      //validator: widget.validator,
      validator:
          widget.validator ??
          (value) {
            if (widget.isEmail == null) {
              if (value == null || value.isEmpty) {
                return "Please enter ${widget.hintText?.toLowerCase() ?? 'value'}";
              } else if (widget.isPassword) {
                bool data = AppConstants.passwordValidator.hasMatch(value);
                if (value.isEmpty) {
                  return "Please enter ${widget.hintText?.toLowerCase() ?? 'password'}";
                } else if (!data) {
                  return "Insecure password detected.";
                }
              }
            } else {
              if (value == null || value.isEmpty) {
                return "Please enter ${widget.hintText?.toLowerCase() ?? 'email'}";
              }
              bool data = AppConstants.emailValidator.hasMatch(value);
              if (!data) {
                return "Please check your email!";
              }
            }
            return null;
          },
      cursorColor: AppColors.primaryColor,
      obscureText: widget.isPassword ? obscureText : false,
      style: widget.textStyle?? TextStyle(color: Colors.white),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: widget.contenpaddingHorizontal ?? 20,
          vertical: widget.contenpaddingVertical ?? 18,
        ),
        filled: true,
        fillColor:
            widget.filColor ??
            (Get.isDarkMode
                ? const Color(0x8A1F2530)
                : Colors.white.withValues(alpha: 0.88)),
        prefixIcon: widget.prefixIcon,
        suffixIcon:
            widget.isPassword
                ? GestureDetector(
                  onTap: toggle,
                  child: _suffixIcon(
                    obscureText ? AppIcons.eyeOffIcon : AppIcons.eyeIcon,
                  ),
                )
                : widget.suffixIcons,
        prefixIconConstraints: BoxConstraints(minHeight: 24, minWidth: 24),
        suffixIconConstraints: BoxConstraints(minHeight: 24, minWidth: 24),
        errorStyle: const TextStyle(color: Colors.red),
        suffixIconColor: Colors.grey,
        prefixIconColor: Colors.grey,
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle:TextStyle(color: AppColors.hintColor, fontFamily: 'Poppins'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            width: 1,
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ),
        // errorBorder: _buildOutlineInputBorder(),
        // focusedBorder: _buildOutlineInputBorder(),
        // enabledBorder: _buildOutlineInputBorder(),
        // disabledBorder: _buildOutlineInputBorder(),
      ),
    );
  }

  _suffixIcon(String icon) {
    return Padding(
      padding: EdgeInsets.only(right: 15),
      child: SvgPicture.asset(
        icon,
        colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
      ),
    );
  }

  // _buildOutlineInputBorder() {
  //   return OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(16),
  //     borderSide: BorderSide(
  //       width: 1,
  //       color:widget.borderColor?? AppColors.fillColor,
  //     ),
  //   );
  // }
}

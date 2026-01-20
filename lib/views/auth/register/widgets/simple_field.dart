import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum FieldType {
  text,
  email,
  password,
  confirmPassword,
  phone,
  name,
}

class SimpleField extends StatelessWidget {
  final TextEditingController controller;
  final FieldType type;
  final String? label;
  final String? hint;
  final bool isPasswordVisible;
  final VoidCallback? onTogglePassword;
  final String? Function(String?)? validator;
  final TextEditingController? passwordController; // Dùng cho confirm password

  const SimpleField({
    super.key,
    required this.controller,
    required this.type,
    this.label,
    this.hint,
    this.isPasswordVisible = false,
    this.onTogglePassword,
    this.validator,
    this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: _obscureText,
      keyboardType: _keyboardType,
      textInputAction: _textInputAction,
      textCapitalization: _textCapitalization,
      inputFormatters: _inputFormatters,
      validator: validator ?? _defaultValidator,
      decoration: InputDecoration(
        labelText: label ?? _defaultLabel,
        hintText: hint ?? _defaultHint,
        prefixIcon: Icon(_prefixIcon),
        suffixIcon: _buildSuffixIcon(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // PRIVATE GETTERS - Tự động config theo type

  bool get _obscureText {
    if (type == FieldType.password || type == FieldType.confirmPassword) {
      return !isPasswordVisible;
    }
    return false;
  }

  TextInputType get _keyboardType {
    switch (type) {
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.phone:
        return TextInputType.phone;
      case FieldType.name:
        return TextInputType.name;
      default:
        return TextInputType.text;
    }
  }

  TextInputAction get _textInputAction {
    if (type == FieldType.confirmPassword) {
      return TextInputAction.done;
    }
    return TextInputAction.next;
  }

  TextCapitalization get _textCapitalization {
    if (type == FieldType.name) {
      return TextCapitalization.words;
    }
    return TextCapitalization.none;
  }

  List<TextInputFormatter>? get _inputFormatters {
    if (type == FieldType.phone) {
      return [FilteringTextInputFormatter.digitsOnly];
    }
    return null;
  }

  IconData get _prefixIcon {
    switch (type) {
      case FieldType.email:
        return Icons.email_outlined;
      case FieldType.password:
      case FieldType.confirmPassword:
        return Icons.lock_outline;
      case FieldType.phone:
        return Icons.phone_outlined;
      case FieldType.name:
        return Icons.person_outline;
      default:
        return Icons.text_fields;
    }
  }

  String get _defaultLabel {
    switch (type) {
      case FieldType.email:
        return 'Email';
      case FieldType.password:
        return 'Mật khẩu';
      case FieldType.confirmPassword:
        return 'Xác nhận mật khẩu';
      case FieldType.phone:
        return 'Số điện thoại';
      case FieldType.name:
        return 'Họ và tên';
      default:
        return 'Nhập thông tin';
    }
  }

  String get _defaultHint {
    switch (type) {
      case FieldType.email:
        return 'example@email.com';
      case FieldType.password:
        return '••••••••';
      case FieldType.confirmPassword:
        return '••••••••';
      case FieldType.phone:
        return '0901234567';
      case FieldType.name:
        return 'Nguyễn Văn A';
      default:
        return '';
    }
  }

  // SUFFIX ICON - Chỉ hiện cho password


  Widget? _buildSuffixIcon() {
    if (type == FieldType.password || type == FieldType.confirmPassword) {
      return IconButton(
        icon: Icon(
          isPasswordVisible ? Icons.visibility_off : Icons.visibility,
        ),
        onPressed: onTogglePassword,
      );
    }
    return null;
  }
  // DEFAULT VALIDATORS
  String? _defaultValidator(String? value) {
    switch (type) {
      case FieldType.email:
        return _validateEmail(value);
      case FieldType.password:
        return _validatePassword(value);
      case FieldType.confirmPassword:
        return _validateConfirmPassword(value);
      case FieldType.phone:
        return _validatePhone(value);
      case FieldType.name:
        return _validateName(value);
      default:
        return _validateRequired(value);
    }
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập thông tin';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu';
    }
    if (passwordController != null && value != passwordController!.text) {
      return 'Mật khẩu không khớp';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Phone optional
    }
    if (!RegExp(r'^[0-9]{10,11}$').hasMatch(value)) {
      return 'Số điện thoại không hợp lệ (10-11 số)';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập họ tên';
    }
    if (value.trim().length < 2) {
      return 'Họ tên phải có ít nhất 2 ký tự';
    }
    return null;
  }
}
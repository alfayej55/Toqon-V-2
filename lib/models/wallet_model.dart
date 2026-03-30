import 'package:car_care/models/profile_model.dart';

class WalletModel {
  final int balance;
  final String currency;
  final ProfileModel user;

  WalletModel({
    required this.balance,
    required this.currency,
    required this.user,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      balance: json['balance'] is int ? json['balance'] as int : 0,
      currency: json['currency'] is String ? json['currency'] as String : '',
      user: ProfileModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'currency': currency,
      'user': user.toJson(),
    };
  }

  WalletModel copyWith({
    int? balance,
    String? currency,
    ProfileModel? user,
  }) {
    return WalletModel(
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      user: user ?? this.user,
    );
  }
}

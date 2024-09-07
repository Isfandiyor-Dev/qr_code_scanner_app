import 'package:qr_code_scanner_app/data/models/generate_qr/gen_qr_model.dart';

class BusinessQRCode extends GenQrModel {
  final String companyName;
  final String industry;
  final String phone;
  final String email;
  final String website;
  final String address;
  final String city;
  final String country;

  BusinessQRCode({
    required this.companyName,
    required this.industry,
    required this.phone,
    required this.email,
    required this.website,
    required this.address,
    required this.city,
    required this.country,
  }) : super("business");

  @override
  Map<String, dynamic> toMap() {
    return {
      'companyName': companyName,
      'industry': industry,
      'phone': phone,
      'email': email,
      'website': website,
      'address': address,
      'city': city,
      'country': country,
    };
  }

  factory BusinessQRCode.fromMap(Map<String, dynamic> map) {
    return BusinessQRCode(
      companyName: map['companyName'] ?? '',
      industry: map['industry'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      website: map['website'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
    );
  }
}

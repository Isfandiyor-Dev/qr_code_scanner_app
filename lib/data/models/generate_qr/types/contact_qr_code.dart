import 'package:qr_code_scanner_app/data/models/generate_qr/gen_qr_model.dart';

class ContactQRCode extends GenQrModel {
  final String firstName;
  final String lastName;
  final String company;
  final String job;
  final String email;
  final String phone;
  final String website;
  final String address;
  final String city;
  final String country;

  ContactQRCode({
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.job,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
    required this.city,
    required this.country,
  }): super("contact");

  @override
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'company': company,
      'job': job,
      'email': email,
      'phone': phone,
      'website': website,
      'address': address,
      'city': city,
      'country': country,
    };
  }

  factory ContactQRCode.fromMap(Map<String, dynamic> map) {
    return ContactQRCode(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      company: map['company'] ?? '',
      job: map['job'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      website: map['website'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
    );
  }
}

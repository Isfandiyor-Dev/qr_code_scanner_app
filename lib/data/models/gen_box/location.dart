class Location {
  String city; // Shahar
  String country; // Mamlakat
  String postalCode; // Pochta indeksi
  String street; // Ko'cha
  String buildingNumber; // Bino raqami
  String apartmentNumber; // Kvartira raqami
  double latitude; // Kenglik
  double longitude; // Uzunlik
  String region; // Mintaqa
  String district; // Tuman
  String timezone; // Vaqt zonasi

  // Konstructor
  Location({
    required this.city,
    required this.country,
    this.postalCode = '',
    this.street = '',
    this.buildingNumber = '',
    this.apartmentNumber = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.region = '',
    this.district = '',
    this.timezone = '',
  });
}

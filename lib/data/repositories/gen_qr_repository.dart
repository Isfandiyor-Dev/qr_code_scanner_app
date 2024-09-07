import 'package:qr_code_scanner_app/data/models/gen_box/gen_box_model.dart';

class GenQrTypes {
  List<GenBox> genBoxes = [
    GenBox(
      name: "Text",
      iconPath: "assets/gen_icons/text.svg",
      fieldLabel: "Text",
      onPressed: (value) {},
    ),
    GenBox(
      name: "Website",
      iconPath: "assets/gen_icons/website.svg",
      fieldLabel: "Website URL",
      onPressed: (value) {},
    ),
    GenBox(
      name: "Wi-Fi",
      iconPath: "assets/gen_icons/wifi.svg",
    ),
    GenBox(
      name: "Event",
      iconPath: "assets/gen_icons/event.svg",
    ),
    GenBox(
      name: "Contact",
      iconPath: "assets/gen_icons/contact.svg",
    ),
    GenBox(
      name: "Business",
      iconPath: "assets/gen_icons/business.svg",
    ),
    GenBox(
      name: "Location",
      iconPath: "assets/gen_icons/location.svg",
    ),
    GenBox(
      name: "WhatsApp",
      iconPath: "assets/gen_icons/whatsapp.svg",
      fieldLabel: "WhatsApp Number",
      onPressed: (value) {},
    ),
    GenBox(
      name: "Email",
      iconPath: "assets/gen_icons/email.svg",
      fieldLabel: "Email",
      onPressed: (value) {},
    ),
    GenBox(
      name: "Twitter",
      iconPath: "assets/gen_icons/twitter.svg",
      fieldLabel: "Username",
      onPressed: (value) {},
    ),
    GenBox(
      name: "Instagram",
      iconPath: "assets/gen_icons/instagram.svg",
      fieldLabel: "Username",
      onPressed: (value) {},
    ),
    GenBox(
      name: "Telephone",
      iconPath: "assets/gen_icons/telephone.svg",
      fieldLabel: "Phone Number",
      onPressed: (value) {},
    ),
  ];
}

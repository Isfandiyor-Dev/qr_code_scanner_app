import 'package:qr_code_scanner_app/data/models/gen_box/gen_box_model.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/generate/containers/business_container.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/generate/containers/contact_container.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/generate/containers/event_container.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/generate/containers/location_container.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/generate/containers/single_field_container.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/generate/containers/wifi_container.dart';

class GenQrTypes {
  final List<GenBox> genBoxes = [
    SingleFieldBox(
      name: "Text",
      iconPath: "assets/gen_icons/text.svg",
      fieldLabel: "Text",
      hintText: "Enter text",
      generateContainer: SingleFieldContainer(
        name: "Text",
        iconPath: "assets/gen_icons/text.svg",
        fieldLabel: "Text",
      ),
    ),
    SingleFieldBox(
      name: "Website",
      iconPath: "assets/gen_icons/website.svg",
      fieldLabel: "Website URL",
      hintText: "Enter website URL",
      generateContainer: SingleFieldContainer(
        name: "Website",
        iconPath: "assets/gen_icons/website.svg",
        fieldLabel: "Website URL",
      ),
    ),
    GenBox(
      name: "Wi-Fi",
      iconPath: "assets/gen_icons/wifi.svg",
      generateContainer: const WifiContainer(
        iconPath: "assets/gen_icons/wifi.svg",
      ),
    ),
    GenBox(
      name: "Event",
      iconPath: "assets/gen_icons/event.svg",
      generateContainer: const EventContainer(
        iconPath: "assets/gen_icons/event.svg",
      ),
    ),
    GenBox(
      name: "Contact",
      iconPath: "assets/gen_icons/contact.svg",
      generateContainer: const ContactContainer(
        iconPath: "assets/gen_icons/contact.svg",
      ),
    ),
    GenBox(
      name: "Business",
      iconPath: "assets/gen_icons/business.svg",
      generateContainer: const BusinessContainer(
        iconPath: "assets/gen_icons/business.svg",
      ),
    ),
    GenBox(
      name: "Location",
      iconPath: "assets/gen_icons/location.svg",
      generateContainer: const LocationContainer(
        iconPath: "assets/gen_icons/location.svg",
      ),
    ),
    SingleFieldBox(
      name: "WhatsApp",
      iconPath: "assets/gen_icons/whatsapp.svg",
      fieldLabel: "WhatsApp Number",
      hintText: "Enter WhatsApp number",
      generateContainer: SingleFieldContainer(
        name: "WhatsApp",
        iconPath: "assets/gen_icons/whatsapp.svg",
        fieldLabel: "WhatsApp Number",
      ),
    ),
    SingleFieldBox(
      name: "Email",
      iconPath: "assets/gen_icons/email.svg",
      fieldLabel: "Email",
      hintText: "Enter email",
      generateContainer: SingleFieldContainer(
        name: "Email",
        iconPath: "assets/gen_icons/email.svg",
        fieldLabel: "Email",
      ),
    ),
    SingleFieldBox(
      name: "Twitter",
      iconPath: "assets/gen_icons/twitter.svg",
      fieldLabel: "Username",
      hintText: "Enter Twitter username",
      generateContainer: SingleFieldContainer(
        name: "Twitter",
        iconPath: "assets/gen_icons/twitter.svg",
        fieldLabel: "Username",
      ),
    ),
    SingleFieldBox(
      name: "Instagram",
      iconPath: "assets/gen_icons/instagram.svg",
      fieldLabel: "Username",
      hintText: "Enter Instagram username",
      generateContainer: SingleFieldContainer(
        name: "Instagram",
        iconPath: "assets/gen_icons/instagram.svg",
        fieldLabel: "Username",
      ),
    ),
    SingleFieldBox(
      name: "Telephone",
      iconPath: "assets/gen_icons/telephone.svg",
      fieldLabel: "Phone Number",
      hintText: "Enter phone number",
      generateContainer: SingleFieldContainer(
        name: "Telephone",
        iconPath: "assets/gen_icons/telephone.svg",
        fieldLabel: "Phone Number",
      ),
    ),
  ];
}

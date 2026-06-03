import 'package:qr_code_app/features/history/data_source/models/gen_box/gen_box_model.dart';
import 'package:qr_code_app/features/generate/presentation/widgets/containers/business_container.dart';
import 'package:qr_code_app/features/generate/presentation/widgets/containers/contact_container.dart';
import 'package:qr_code_app/features/generate/presentation/widgets/containers/event_container.dart';
import 'package:qr_code_app/features/generate/presentation/widgets/containers/location_container.dart';
import 'package:qr_code_app/features/generate/presentation/widgets/containers/single_field_container.dart';
import 'package:qr_code_app/features/generate/presentation/widgets/containers/wifi_container.dart';
import 'package:qr_code_app/gen/assets.gen.dart';

/// Provides the available QR generation templates shown on the Generate screen.
class GenQrTypes {
  /// Ordered list of QR templates and their matching input forms.
  final List<GenBox> genBoxes = [
    SingleFieldBox(
      name: "Text",
      iconPath: Assets.genIcons.text.path,
      fieldLabel: "Text",
      hintText: "Enter text",
      generateContainer: SingleFieldContainer(
        name: "Text",
        iconPath: Assets.genIcons.text.path,
        fieldLabel: "Text",
      ),
    ),
    SingleFieldBox(
      name: "Website",
      iconPath: Assets.genIcons.website.path,
      fieldLabel: "Website URL",
      hintText: "Enter website URL",
      generateContainer: SingleFieldContainer(
        name: "Website",
        iconPath: Assets.genIcons.website.path,
        fieldLabel: "Website URL",
      ),
    ),
    GenBox(
      name: "Wi-Fi",
      iconPath: Assets.genIcons.wifi.path,
      generateContainer: WifiContainer(
        iconPath: Assets.genIcons.wifi.path,
      ),
    ),
    GenBox(
      name: "Contact",
      iconPath: Assets.genIcons.contact.path,
      generateContainer: ContactContainer(
        iconPath: Assets.genIcons.contact.path,
      ),
    ),
    GenBox(
      name: "Location",
      iconPath: Assets.genIcons.location.path,
      generateContainer: LocationContainer(
        iconPath: Assets.genIcons.location.path,
      ),
    ),
    SingleFieldBox(
      name: "WhatsApp",
      iconPath: Assets.genIcons.whatsapp.path,
      fieldLabel: "WhatsApp Number",
      hintText: "Enter WhatsApp number",
      generateContainer: SingleFieldContainer(
        name: "WhatsApp",
        iconPath: Assets.genIcons.whatsapp.path,
        fieldLabel: "WhatsApp Number",
      ),
    ),
    SingleFieldBox(
      name: "Email",
      iconPath: Assets.genIcons.email.path,
      fieldLabel: "Email",
      hintText: "Enter email",
      generateContainer: SingleFieldContainer(
        name: "Email",
        iconPath: Assets.genIcons.email.path,
        fieldLabel: "Email",
      ),
    ),
    SingleFieldBox(
      name: "Telephone",
      iconPath: Assets.genIcons.telephone.path,
      fieldLabel: "Phone Number",
      hintText: "Enter phone number",
      generateContainer: SingleFieldContainer(
        name: "Telephone",
        iconPath: Assets.genIcons.telephone.path,
        fieldLabel: "Phone Number",
      ),
    ),
    GenBox(
      name: "Event",
      iconPath: Assets.genIcons.event.path,
      generateContainer: EventContainer(
        iconPath: Assets.genIcons.event.path,
      ),
    ),
    GenBox(
      name: "Business",
      iconPath: Assets.genIcons.business.path,
      generateContainer: BusinessContainer(
        iconPath: Assets.genIcons.business.path,
      ),
    ),
    SingleFieldBox(
      name: "Twitter",
      iconPath: Assets.genIcons.twitter.path,
      fieldLabel: "Username",
      hintText: "Enter Twitter username",
      generateContainer: SingleFieldContainer(
        name: "Twitter",
        iconPath: Assets.genIcons.twitter.path,
        fieldLabel: "Username",
      ),
    ),
    SingleFieldBox(
      name: "Instagram",
      iconPath: Assets.genIcons.instagram.path,
      fieldLabel: "Username",
      hintText: "Enter Instagram username",
      generateContainer: SingleFieldContainer(
        name: "Instagram",
        iconPath: Assets.genIcons.instagram.path,
        fieldLabel: "Username",
      ),
    ),
  ];
}

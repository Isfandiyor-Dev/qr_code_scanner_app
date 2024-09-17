import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/generate/widgets/custom_textfield.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/generate/widgets/generate_button.dart';
import 'package:svg_flutter/svg.dart';

class EventContainer extends StatefulWidget {
  final String iconPath;
  const EventContainer({super.key, required this.iconPath});
  @override
  State<EventContainer> createState() => _EventContainerState();
}

class _EventContainerState extends State<EventContainer> {
  // TextEditingController larni yaratamiz
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    // Kontrollerlarni tozalash
    eventNameController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _generateEventQRCode() {
    // Har bir TextField dan textni olish
    String eventName = eventNameController.text;
    String startDate = startDateController.text;
    String endDate = endDateController.text;
    String location = locationController.text;
    String description = descriptionController.text;

    // Olingan textlarni ishlatishingiz mumkin
    print('Event Name: $eventName');
    print('Start Date: $startDate');
    print('End Date: $endDate');
    print('Location: $location');
    print('Description: $description');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.grey[800]!.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
        border: const Border.symmetric(
          horizontal: BorderSide(color: Colors.amber),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(widget.iconPath),
          CustomTextField(
            fieldLabel: "Event Name",
            controller: eventNameController,
            hintText: 'Enter event name',
          ),
          CustomTextField(
            fieldLabel: "Start Date and Time",
            controller: startDateController,
            hintText: 'Enter start date and time',
          ),
          CustomTextField(
            fieldLabel: "End Date and Time",
            controller: endDateController,
            hintText: 'Enter end date and time',
          ),
          CustomTextField(
            fieldLabel: "Event Location",
            controller: locationController,
            hintText: 'Enter location',
          ),
          CustomTextField(
            fieldLabel: "Description",
            controller: descriptionController,
            hintText: 'Enter description',
            maxLines: 4,
          ),
          GenerateButton(onPressed: () {}),
        ],
      ),
    );
  }
}

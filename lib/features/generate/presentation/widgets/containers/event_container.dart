import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_bloc.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_event.dart';
import 'package:qr_code_scanner_app/features/generate/presentation/widgets/other/custom_textfield.dart';
import 'package:qr_code_scanner_app/features/generate/presentation/widgets/other/generate_button.dart';
import 'package:qr_code_scanner_app/features/result_screen/presentation/result_page.dart';
import 'package:svg_flutter/svg.dart';

import '../../../../../core/enum/result_screen.dart';

class EventContainer extends StatefulWidget {
  final String iconPath;
  const EventContainer({super.key, required this.iconPath});
  @override
  State<EventContainer> createState() => _EventContainerState();
}

class _EventContainerState extends State<EventContainer> {

  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    eventNameController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
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
          GenerateButton(onPressed: () {
            Map<String, dynamic> data = {
              "Event Name": eventNameController.text,
              "Start Date": startDateController.text,
              "End Date": endDateController.text,
              "Location": locationController.text,
              "Description": descriptionController.text,
            };

            BlocProvider.of<HistoryBloc>(context).add(
              AddHistoryEvent(
                code: jsonEncode(data),
                isGenerated: true,
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultPage(
                  qrCode: jsonEncode(data),
                    fromScreen: FromScreenEnum.generated,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_bloc.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_event.dart';
import 'package:qr_code_scanner_app/features/generate/presentation/widgets/other/custom_textfield.dart';
import 'package:qr_code_scanner_app/features/generate/presentation/widgets/other/generate_button.dart';
import 'package:qr_code_scanner_app/features/result_screen/presentation/result_page.dart';
import 'package:svg_flutter/svg.dart';
import '../../../../../core/enums/result_screen.dart';

/// Form used to generate an event-details QR code.
class EventContainer extends StatefulWidget {
  /// Icon displayed above the event form.
  final String iconPath;

  /// Creates an event QR generation form.
  const EventContainer({super.key, required this.iconPath});

  @override
  State<EventContainer> createState() => _EventContainerState();
}

class _EventContainerState extends State<EventContainer> {
  final _formKey = GlobalKey<FormState>();

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

  /// Opens date and time pickers and writes the formatted value to [controller].
  Future<void> _pickDateTime(TextEditingController controller) async {
    final now = DateTime.now();

    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select date',
    );

    if (date == null) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Select time',
    );

    if (time == null) return;

    final DateTime fullDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    final formatted = DateFormat('yyyy-MM-dd HH:mm').format(fullDateTime);

    setState(() {
      controller.text = formatted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: context.colorScheme.secondaryContainer.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(10),
          border: Border.symmetric(
            horizontal: BorderSide(color: context.colorScheme.primary),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(widget.iconPath),
              const SizedBox(height: 20),
              CustomTextField(
                fieldLabel: "Event Name *",
                controller: eventNameController,
                hintText: 'Enter event name',
                validator: (value) => value == null || value.isEmpty
                    ? "Event name required"
                    : null,
              ),
              GestureDetector(
                onTap: () => _pickDateTime(startDateController),
                child: AbsorbPointer(
                  child: CustomTextField(
                    fieldLabel: "Start Date and Time *",
                    controller: startDateController,
                    hintText: 'Select start date and time',
                    validator: (value) => value == null || value.isEmpty
                        ? "Start date required"
                        : null,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _pickDateTime(endDateController),
                child: AbsorbPointer(
                  child: CustomTextField(
                    fieldLabel: "End Date and Time *",
                    controller: endDateController,
                    hintText: 'Select end date and time',
                    validator: (value) => value == null || value.isEmpty
                        ? "End date required"
                        : null,
                  ),
                ),
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
              const SizedBox(height: 20),
              GenerateButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> data = {};

                    data["Event Name"] = eventNameController.text.trim();
                    data["Start Date"] = startDateController.text.trim();
                    data["End Date"] = endDateController.text.trim();

                    void addIfNotEmpty(String key, String value) {
                      if (value.trim().isNotEmpty) data[key] = value.trim();
                    }

                    addIfNotEmpty("Location", locationController.text);
                    addIfNotEmpty("Description", descriptionController.text);

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
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

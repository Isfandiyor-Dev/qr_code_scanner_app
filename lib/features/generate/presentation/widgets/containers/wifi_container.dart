import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_app/core/enums/result_screen.dart';
import 'package:qr_code_app/core/extensions/context/app_text_theme_extension.dart';
import 'package:qr_code_app/features/history/presentation/bloc/history/history_bloc.dart';
import 'package:qr_code_app/features/history/presentation/bloc/history/history_event.dart';
import 'package:qr_code_app/features/generate/presentation/widgets/other/custom_textfield.dart';
import 'package:qr_code_app/features/generate/presentation/widgets/other/generate_button.dart';
import 'package:qr_code_app/features/result_screen/presentation/result_page.dart';
import 'package:svg_flutter/svg.dart';

/// Form used to generate a Wi-Fi network QR code.
class WifiContainer extends StatefulWidget {
  /// Icon displayed above the Wi-Fi form.
  final String iconPath;

  /// Creates a Wi-Fi QR generation form.
  const WifiContainer({
    super.key,
    required this.iconPath,
  });

  @override
  State<WifiContainer> createState() => _WifiContainerState();
}

class _WifiContainerState extends State<WifiContainer> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController networkNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedType = 'WPA';

  @override
  void dispose() {
    networkNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? _networkNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Network name cannot be empty.';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (selectedType != 'nopass' && (value == null || value.trim().isEmpty)) {
      return 'Password cannot be empty.';
    }
    return null;
  }

  void _onGeneratePressed(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // The WIFI payload format is recognized by most QR scanners and OS cameras.
    final data =
        'WIFI:T:$selectedType;S:${networkNameController.text};P:${passwordController.text};;';

    BlocProvider.of<HistoryBloc>(context).add(
      AddHistoryEvent(
        code: data,
        isGenerated: true,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          qrCode: data,
          fromScreen: FromScreenEnum.generated,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.78,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.secondaryContainer.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(10),
        border: Border.symmetric(
          horizontal: BorderSide(color: context.colorScheme.primary),
        ),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(widget.iconPath),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                borderRadius: BorderRadius.circular(15),
                decoration: InputDecoration(
                  labelText: 'Security Type',
                  filled: true,
                  fillColor: context.colorScheme.primaryContainer,
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffD9D9D9), width: 0.8),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber, width: 1),
                  ),
                ),
                dropdownColor: context.colorScheme.primaryContainer,
                iconEnabledColor: Colors.white,
                style: context.textTheme.bodyMedium,
                items: const [
                  DropdownMenuItem(
                    value: 'WPA',
                    child: Text('WPA/WPA2/WPA3'),
                  ),
                  DropdownMenuItem(
                    value: 'WEP',
                    child: Text('WEP'),
                  ),
                  DropdownMenuItem(
                    value: 'nopass',
                    child: Text('No password (Open network)'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                fieldLabel: "Network Name (SSID)",
                controller: networkNameController,
                hintText: 'Enter network name',
                validator: _networkNameValidator,
              ),
              CustomTextField(
                fieldLabel: "Password",
                controller: passwordController,
                hintText: 'Enter password',
                validator: _passwordValidator,
              ),
              GenerateButton(
                onPressed: () => _onGeneratePressed(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

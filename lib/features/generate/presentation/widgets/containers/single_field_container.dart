import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_bloc.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_event.dart';
import 'package:qr_code_scanner_app/features/generate/presentation/widgets/other/custom_textfield.dart';
import 'package:qr_code_scanner_app/features/generate/presentation/widgets/other/generate_button.dart';
import 'package:qr_code_scanner_app/features/result_screen/presentation/result_page.dart';
import 'package:svg_flutter/svg.dart';

import '../../../../../core/enums/result_screen.dart';

/// Form used by QR types that only require one text field.
class SingleFieldContainer extends StatefulWidget {
  /// Display name of the generated QR type.
  final String name;

  /// Icon displayed above the form.
  final String iconPath;

  /// Label shown for the input field.
  final String fieldLabel;

  /// Creates a single-field QR generation form.
  const SingleFieldContainer({
    super.key,
    required this.name,
    required this.iconPath,
    required this.fieldLabel,
  });

  @override
  State<SingleFieldContainer> createState() => _SingleFieldContainerState();
}

class _SingleFieldContainerState extends State<SingleFieldContainer> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();

  String? _nonEmptyValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty.';
    }
    return null;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onGeneratePressed(BuildContext context) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    BlocProvider.of<HistoryBloc>(context).add(
      AddHistoryEvent(
        code: _textController.text,
        isGenerated: true,
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          qrCode: _textController.text,
          fromScreen: FromScreenEnum.generated,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.37,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(widget.iconPath),
            CustomTextField(
              fieldLabel: widget.fieldLabel,
              controller: _textController,
              hintText: '',
              validator: _nonEmptyValidator,
            ),
            GenerateButton(
              onPressed: () => _onGeneratePressed(context),
            ),
          ],
        ),
      ),
    );
  }
}

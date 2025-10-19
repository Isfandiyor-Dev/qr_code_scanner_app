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

class SingleFieldContainer extends StatefulWidget {
  final String name;
  final String iconPath;
  final String fieldLabel;

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

  // Validator funksiyasi — senior uslub: bir joyda yozib, qayta ishlatamiz
  String? _nonEmptyValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty.';
    }
    return null; // valid
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onGeneratePressed(BuildContext context) {
    // Formni tekshiramiz — agar false bo'lsa errorlar ko'rsatiladi
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    // Hamma narsa ok bo'lsa davom etamiz
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
    // Eslatma: FormFieldlarni qayta validatsiya qilish uchun onChanged ichida validate chaqiramiz,
    // lekin setState ishlatmaymiz — formKey orqali validate() o‘zini qayta chizadi va errorni yangilaydi.
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
              // onChanged: (value) {
              //   // Har bir o'zgarishda maydonni qayta tekshiramiz.
              //   // Bu setState ishlatmaydi, FormField errorlarini yangilaydi.
              //   _formKey.currentState?.validate();
              // },
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

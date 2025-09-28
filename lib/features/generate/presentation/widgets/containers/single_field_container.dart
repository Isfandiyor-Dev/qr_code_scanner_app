import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_bloc.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_event.dart';
import 'package:qr_code_scanner_app/features/generate/presentation/widgets/other/custom_textfield.dart';
import 'package:qr_code_scanner_app/features/generate/presentation/widgets/other/generate_button.dart';
import 'package:qr_code_scanner_app/features/result_screen/presentation/result_page.dart';
import 'package:svg_flutter/svg.dart';

import '../../../../../core/enum/result_screen.dart';

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
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.37,
      width: MediaQuery.of(context).size.width * 0.78,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[800]!.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
        border: const Border.symmetric(
          horizontal: BorderSide(color: Colors.amber),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(widget.iconPath),
          CustomTextField(
            fieldLabel: widget.fieldLabel,
            controller: textController,
            hintText: "",
          ),
          GenerateButton(
            onPressed: () {
              BlocProvider.of<HistoryBloc>(context).add(
                AddHistoryEvent(
                  code: textController.text,
                  isGenerated: true,
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultPage(
                    qrCode: textController.text,
                    fromScreen: FromScreenEnum.generated,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

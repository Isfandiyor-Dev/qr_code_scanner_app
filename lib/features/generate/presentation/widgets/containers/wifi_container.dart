import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_app/core/enum/result_screen.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_bloc.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_event.dart';
import 'package:qr_code_scanner_app/features/generate/presentation/widgets/other/custom_textfield.dart';
import 'package:qr_code_scanner_app/features/generate/presentation/widgets/other/generate_button.dart';
import 'package:qr_code_scanner_app/features/result_screen/presentation/result_page.dart';
import 'package:svg_flutter/svg.dart';

class WifiContainer extends StatefulWidget {
  final String iconPath;
  const WifiContainer({
    super.key,
    required this.iconPath,
  });

  @override
  State<WifiContainer> createState() => _WifiContainerState();
}

class _WifiContainerState extends State<WifiContainer> {
  final TextEditingController networkNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    networkNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      width: MediaQuery.of(context).size.width * 0.78,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[800]!.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
        border: const Border.symmetric(
          horizontal: BorderSide(color: Colors.amber),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(widget.iconPath),
            CustomTextField(
              fieldLabel: "Network",
              controller: networkNameController,
              hintText: 'Enter network name',
            ),
            CustomTextField(
              fieldLabel: "Password",
              controller: passwordController,
              hintText: 'Enter password',
            ),
            GenerateButton(onPressed: () {
              String data =
                  'WIFI:T:N/A;P:${passwordController.text};S:${networkNameController.text};';

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
            }),
          ],
        ),
      ),
    );
  }
}

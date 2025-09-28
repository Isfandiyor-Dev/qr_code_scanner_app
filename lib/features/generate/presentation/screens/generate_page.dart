import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/features/history/data_source/models/gen_box/gen_box_model.dart';
import 'package:qr_code_scanner_app/features/generate/data_source/repositories/gen_qr_repository.dart';
import 'package:qr_code_scanner_app/features/generate/presentation/screens/qr_generate_page.dart';
import 'package:svg_flutter/svg.dart';

class GeneratePage extends StatelessWidget {
  GeneratePage({super.key});
  final genQrTypes = GenQrTypes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "Generate QR",
            style: TextStyle(
              color: Colors.grey[200],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: GridView.builder(
        padding:
            const EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 20),
        itemCount: genQrTypes.genBoxes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 40,
          crossAxisSpacing: 25,
        ),
        itemBuilder: (context, index) {
          GenBox genBox = genQrTypes.genBoxes[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QrGeneratePage(
                    genBox: genBox,
                    generateContainer: genBox.generateContainer,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(15),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xff333333),
                border: Border.all(
                  color: Color(0xFFFDB623),
                  width: 1,
                ),
              ),
              child: Stack(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(genBox.iconPath)),
                  // const SizedBox(height: 5),
                  // Text(
                  //   genBox.name,
                  //   style: const TextStyle(
                  //     color: Color(0xffFDB623),
                  //     fontSize: 12,
                  //   ),
                  // ),
                  Align(
                    alignment: Alignment(0, -1.5),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFFFDB623),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Text(
                          genBox.name,
                          style: const TextStyle(
                            color: Color(0xFF2D3047),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

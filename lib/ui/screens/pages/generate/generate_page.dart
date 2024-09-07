import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/data/models/gen_box/gen_box_model.dart';
import 'package:qr_code_scanner_app/data/repositories/gen_qr_repository.dart';
import 'package:svg_flutter/svg.dart';

class GeneratePage extends StatelessWidget {
  GeneratePage({super.key});
  final genQrTypes = GenQrTypes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff333333).withOpacity(0.87),
      appBar: AppBar(
        title: Text(
          "Generate QR",
          style: TextStyle(
            color: Colors.grey[200],
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(25),
        itemCount: genQrTypes.genBoxes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 25,
          crossAxisSpacing: 25,
        ),
        itemBuilder: (context, index) {
          GenBox genBox = genQrTypes.genBoxes[index];
          return InkWell(
            onTap: () {
              //  Navigator.push(context, MaterialPageRoute(builder: (context) => )
            },
            borderRadius: BorderRadius.circular(15),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xff333333),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(genBox.iconPath),
                  const SizedBox(height: 5),
                  Text(
                    genBox.name,
                    style: const TextStyle(
                      color: Color(0xffFDB623),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
}

import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_media_query_size_extension.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';
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
            style: context.textTheme.headlineLarge,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: GridView.builder(
        padding:
            const EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 40),
        itemCount: genQrTypes.genBoxes.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: context.width * 0.24,
          mainAxisSpacing: 40,
          crossAxisSpacing: 25,
          childAspectRatio: 1,
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
                  gradient: LinearGradient(
                    begin: AlignmentGeometry.bottomLeft,
                    end: AlignmentGeometry.topRight,
                    colors: [
                      context.colorScheme.tertiaryFixed,
                      context.colorScheme.tertiaryFixedDim
                    ],
                  ),
                  border: Border.all(
                    color: context.colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isTablet = constraints.maxWidth > 600;
                    final topOffset = isTablet ? -15.0 : -10.0;
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: SvgPicture.asset(genBox.iconPath),
                        ),
                        Positioned(
                          top: topOffset,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: context.colorScheme.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Text(
                                  genBox.name,
                                  style: context.textTheme.labelSmall?.copyWith(
                                    color: context.colorScheme.tertiary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )),
          );
        },
      ),
    );
  }
}

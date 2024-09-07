import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/data/models/gen_box/gen_box_model.dart';

class SingleFieldContainer extends StatelessWidget {
  final GenBox genBox;
  SingleFieldContainer({
    super.key,
    required this.genBox,
  });

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
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
          const Icon(
            Icons.language_rounded,
            size: 40,
          ),
          Column(
            children: [
              Row(
                children: [
                  Text(genBox.fieldLabel!),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  fillColor: Colors.grey,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.amber,
              fixedSize: const Size(200, 50),
            ),
            onPressed: () {},
            child: const Text(
              "Generate QR Code",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner_app/blocs/history/history_bloc.dart';
import 'package:qr_code_scanner_app/blocs/history/history_event.dart';
import 'package:qr_code_scanner_app/blocs/history/history_state.dart';
import 'package:qr_code_scanner_app/data/models/scan_qr/scan_qr_model.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/history/history_item_detail.dart';

class ScanList extends StatefulWidget {
  const ScanList({super.key});

  @override
  State<ScanList> createState() => _ScanListState();
}

class _ScanListState extends State<ScanList> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(GetHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state is ErrorHistoryState) {
          return const Center(
            child: Text("Xatolik yuz berdi!"),
          );
        } else if (state is LoadedHistoryState) {
          List<QrModel> qrCodes = state.qrCodesList;

          if (qrCodes.isEmpty) {
            return const Center(
              child: Text(
                "Ma'lumot yo'q",
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            );
          }
          qrCodes = qrCodes.where((element) => !element.isGenerated).toList();
          return ListView.builder(
            itemCount: qrCodes.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              QrModel qrCode = qrCodes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HistoryItemDetail(qrCode: qrCode.code),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF232323).withOpacity(0.6),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff000000).withOpacity(0.33),
                        blurRadius: 11,
                      )
                    ],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    leading: Image.asset(
                      "assets/icons/history_item_leading.png",
                      width: 30,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            qrCode.code,
                            style: const TextStyle(
                              color: Colors.white,
                              height: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context
                                .read<HistoryBloc>()
                                .add(DeleteHistoryEvent(id: qrCode.id));
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Color(0xffFDB623),
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Data",
                          style: TextStyle(
                            color: Colors.white24,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy HH:mm')
                              .format(qrCode.scannetAt),
                          style: const TextStyle(
                            color: Colors.white24,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}

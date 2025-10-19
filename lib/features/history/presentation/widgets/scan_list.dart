import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_bloc.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_event.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_state.dart';
import 'package:qr_code_scanner_app/features/history/data_source/models/scan_qr/scan_qr_model.dart';
import 'package:qr_code_scanner_app/features/history/presentation/widgets/history_list_view.dart';
import 'package:svg_flutter/svg.dart';

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
            child: Text("Oops! Something went wrong."),
          );
        } else if (state is LoadedHistoryState) {
          List<QrCodeModel> qrCodes = state.qrCodesList;
          qrCodes = qrCodes.where((element) => !element.isGenerated).toList();

          if (qrCodes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/empty.svg",
                    width: 65,
                    height: 65,
                  ),
                  Gap(10),
                  Text(
                    "Scan history is empty",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            );
          }

          return HistoryListView(qrCodes: qrCodes);
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

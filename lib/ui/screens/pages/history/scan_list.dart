import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_app/blocs/history/history_bloc.dart';
import 'package:qr_code_scanner_app/blocs/history/history_event.dart';
import 'package:qr_code_scanner_app/blocs/history/history_state.dart';
import 'package:qr_code_scanner_app/data/models/scan_qr/scan_qr_model.dart';

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
        if (state is InitialHistoryState) {
          return const Center(
            child: Text("Ma'lumot yuklanmadi"),
          );
        }

        if (state is LoadingHistoryState) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (state is ErrorHistoryState) {
          return const Center(
            child: Text("Xatolik yuz berdi!"),
          );
        }

        List<ScanQrModel> qrCodes = (state as LoadedHistoryState).qrCodesList;

        if (qrCodes.isEmpty) {
          return const Center(
            child: Text("Ma'lumot yo'q"),
          );
        }

        return ListView.builder(
          itemCount: qrCodes.length,
          itemBuilder: (context, index) {
            ScanQrModel qrCode = qrCodes[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  child: Text(qrCode.id.toString()),
                ),
                title: Text(
                  qrCode.code,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(qrCode.scannetAt.toString()),
                trailing: IconButton(
                  onPressed: () {
                    context
                        .read<HistoryBloc>()
                        .add(DeleteHistoryEvent(id: qrCode.id));
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red[900],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

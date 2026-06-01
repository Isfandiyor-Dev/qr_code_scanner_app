import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner_app/core/enums/result_screen.dart';
import 'package:qr_code_scanner_app/features/history/data_source/models/scan_qr/scan_qr_model.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_bloc.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_event.dart';
import 'package:qr_code_scanner_app/features/result_screen/presentation/result_page.dart';
import 'package:qr_code_scanner_app/gen/assets.gen.dart';

/// Animated list of QR history entries.
class HistoryListView extends StatelessWidget {
  /// History entries to display.
  final List<QrCodeModel> qrCodes;

  /// Creates a history list for [qrCodes].
  const HistoryListView({super.key, required this.qrCodes});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: qrCodes.length,
        padding: const EdgeInsets.all(20),
        itemBuilder: (context, index) {
          QrCodeModel qrCode = qrCodes[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 44,
              curve: Curves.easeOutCubic,
              child: FadeInAnimation(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          qrCode: qrCode.code,
                          fromScreen: FromScreenEnum.history,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 25, 25, 25)
                          .withValues(alpha: .6),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0A0A0A).withValues(alpha: .33),
                          blurRadius: 12,
                        )
                      ],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    clipBehavior: Clip.hardEdge,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: Image.asset(
                        Assets.icons.historyItemLeading.path,
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
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 2,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final confirmed =
                                  await _confirmDelete(context, qrCode.code);
                              if ((confirmed ?? false) && context.mounted) {
                                context
                                    .read<HistoryBloc>()
                                    .add(DeleteHistoryEvent(id: qrCode.id));
                              }
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
                                .format(qrCode.scannedAt),
                            style: const TextStyle(
                              color: Colors.white24,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<bool?> _confirmDelete(BuildContext context, String code) async {
  final bool? confirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Warning'),
      content: Text(
        'Are you sure you want to delete “$code”?',
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
  return confirm;
}

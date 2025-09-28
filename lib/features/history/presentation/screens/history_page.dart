import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history_cubit/history_cubit.dart';
import 'package:qr_code_scanner_app/features/history/presentation/widgets/create_list.dart';
import 'package:qr_code_scanner_app/features/history/presentation/widgets/scan_list.dart';

class QrHistoryPage extends StatefulWidget {
  const QrHistoryPage({super.key});

  @override
  State<QrHistoryPage> createState() => _QrHistoryPageState();
}

class _QrHistoryPageState extends State<QrHistoryPage> {

 final List<Widget> qrLists = [
    const ScanList(),
    const CreateList(),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HistoryCubit>();
    return BlocBuilder<HistoryCubit, int>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          leadingWidth: 150,
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text("History"),
          ),
          bottom: AppBar(
            toolbarHeight: 70,
            centerTitle: true,
            title: Container(
              height: 70,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xff333333).withOpacity(0.84),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      cubit.setIndexPage(0);
                    },
                    child: AnimatedContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      duration: const Duration(milliseconds: 300),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: state == 0
                            ? const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                tileMode: TileMode.decal,
                                colors: [
                                    Color(0xffFDB623),
                                    Color.fromARGB(255, 175, 133, 48),
                                    Color.fromARGB(255, 62, 53, 16),
                                  ])
                            : null,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text("Scan"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      cubit.setIndexPage(1);
                    },
                    child: AnimatedContainer(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 50,
                      duration: const Duration(milliseconds: 300),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: state == 1
                            ? const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                tileMode: TileMode.decal,
                                colors: [
                                    Color(0xffFDB623),
                                    Color.fromARGB(255, 175, 133, 48),
                                    Color.fromARGB(255, 62, 53, 16),
                                  ])
                            : null,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text("Create"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 60,
            top: 15,
          ),
          decoration: BoxDecoration(
            color: const Color(0xff333333).withOpacity(0.84),
            borderRadius: BorderRadius.circular(10),
          ),
          child: qrLists[state],
        ),
      );
    });
  }
}

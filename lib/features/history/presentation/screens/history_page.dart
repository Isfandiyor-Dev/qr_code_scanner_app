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
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, int>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          leadingWidth: 150,
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text("History"),
          ),
        ),
        body: DefaultTabController(
          initialIndex: state,
          length: 2,
          child: Column(
            children: [
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xff141414),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TabBar(
                  isScrollable: false,
                  dividerHeight: 0,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xffFDB623),
                        Color(0xFFBE891D),
                        Color(0xff735D2E),
                      ],
                    ),
                  ),
                  indicatorColor: Colors.amber,
                  labelColor: Colors.white,
                  unselectedLabelColor: Color(0xffD9D9D9),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(text: "Scan"),
                    Tab(text: "Create"),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    const ScanList(),
                    const CreateList(),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

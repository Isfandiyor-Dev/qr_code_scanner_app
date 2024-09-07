import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_app/blocs/navigation_bar/navigation_bar_cubit.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/generate/generate_page.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/history/history_page.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/scanner/scanner_page.dart';

class ScreensManager extends StatelessWidget {
  ScreensManager({super.key});

  final List<Widget> _pages = [
    const QrScannerPage(),
    GeneratePage(),
    const QrHistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: const BottomAppBar(
        height: 100,
        color: Color(0xff333333),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MyBottomBarItem(
              index: 1,
              label: "Generate",
              icon: Icons.qr_code_2_rounded,
            ),
            SizedBox(width: 90),
            MyBottomBarItem(
              index: 2,
              label: "History",
              icon: Icons.history_rounded,
            ),
          ],
        ),
      ),
      body: BlocBuilder<NavigationBarCubit, int>(
        builder: (ctx, state) {
          return _pages[state];
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.amber,
              spreadRadius: 5,
              blurRadius: 15,
              blurStyle: BlurStyle.normal,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            BlocProvider.of<NavigationBarCubit>(context).toggleBarBtn(0);
          },
          backgroundColor: Colors.amber,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.qr_code_scanner_rounded,
            size: 35,
          ),
        ),
      ),
    );
  }
}

class MyBottomBarItem extends StatefulWidget {
  final int index;
  final String label;
  final IconData icon;

  const MyBottomBarItem({
    super.key,
    required this.index,
    required this.label,
    required this.icon,
  });

  @override
  State<MyBottomBarItem> createState() => _MyBottomBarItemState();
}

class _MyBottomBarItemState extends State<MyBottomBarItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        BlocProvider.of<NavigationBarCubit>(context).toggleBarBtn(widget.index);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Ink(
          width: 60,
          height: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

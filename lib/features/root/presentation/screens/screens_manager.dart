import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';
import 'package:qr_code_scanner_app/features/root/presentation/bloc/navigation_bar/navigation_bar_cubit.dart';
import 'package:qr_code_scanner_app/features/generate/presentation/screens/generate_page.dart';
import 'package:qr_code_scanner_app/features/history/presentation/screens/history_page.dart';
import 'package:qr_code_scanner_app/features/qr_scanner/presentation/screens/scanner_page.dart';

class ScreensManager extends StatefulWidget {
  const ScreensManager({super.key});

  @override
  State<ScreensManager> createState() => _ScreensManagerState();
}

class _ScreensManagerState extends State<ScreensManager> {
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const QrScannerPage(),
      GeneratePage(),
      const QrHistoryPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBarCubit, int>(builder: (ctx, state) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomAppBar(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MyBottomBarItem(
                index: 1,
                label: "Generate",
                icon: Icons.qr_code_2_rounded,
                isSelected: state == 1,
              ),
              const SizedBox(width: 90),
              MyBottomBarItem(
                index: 2,
                label: "History",
                icon: Icons.history_rounded,
                isSelected: state == 2,
              ),
            ],
          ),
        ),
        body: _pages[state],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          width: 65,
          height: 65,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.primary,
                spreadRadius: 2,
                blurRadius: 10,
                blurStyle: BlurStyle.normal,
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              BlocProvider.of<NavigationBarCubit>(context).toggleBarBtn(0);
            },
            backgroundColor: context.colorScheme.primary,
            shape: const CircleBorder(),
            child: Image.asset(
              "assets/icons/scan.png",
              width: 30,
            ),
          ),
        ),
      );
    });
  }
}

class MyBottomBarItem extends StatefulWidget {
  final int index;
  final String label;
  final IconData icon;
  final bool isSelected;

  const MyBottomBarItem({
    super.key,
    required this.index,
    required this.label,
    required this.icon,
    required this.isSelected,
  });

  @override
  State<MyBottomBarItem> createState() => _MyBottomBarItemState();
}

class _MyBottomBarItemState extends State<MyBottomBarItem> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: () {
        BlocProvider.of<NavigationBarCubit>(context).toggleBarBtn(widget.index);
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              color: widget.isSelected
                  ? context.colorScheme.primary
                  : context.colorScheme.onPrimaryContainer,
              size: widget.isSelected ? 26 : 25,
            ),
            const SizedBox(height: 5),
            Text(
              widget.label,
              style: TextStyle(
                color: widget.isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.onPrimaryContainer,
                fontSize: widget.isSelected ? 12 : 11,
                fontWeight:
                    widget.isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

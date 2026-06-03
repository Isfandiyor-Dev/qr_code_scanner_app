import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:qr_code_app/core/di/di.dart';
import 'package:qr_code_app/core/extensions/context/app_text_theme_extension.dart';
import 'package:qr_code_app/core/widgets/back_widget.dart';
import 'package:qr_code_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:qr_code_app/features/settings/presentation/cubit/settings_state.dart';
import 'package:qr_code_app/features/settings/presentation/widgets/setting_toggle_card.dart';
import 'package:qr_code_app/features/settings/presentation/widgets/support_tile.dart';

/// Settings page for scan feedback preferences and support links.
class SettingsScreen extends StatelessWidget {
  /// Creates the settings screen.
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsCubit>(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Constrained to 45x45 so it stays pinned to the left.
                // (BackWidget centers its box, which would otherwise float to
                // the middle of a full-width parent.)
                const SizedBox(
                  width: 45,
                  height: 45,
                  child: BackWidget(),
                ),
                const Gap(28),

                const _SectionTitle('Settings'),
                const Gap(16),
                BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, state) {
                    final cubit = context.read<SettingsCubit>();
                    return Column(
                      children: [
                        SettingToggleCard(
                          icon: Icons.vibration,
                          title: 'Vibrate',
                          subtitle: 'Vibration when scan is done.',
                          value: state.vibrateEnabled,
                          onChanged: cubit.toggleVibrate,
                        ),
                        const Gap(14),
                        SettingToggleCard(
                          icon: Icons.notifications_active_outlined,
                          title: 'Beep',
                          subtitle: 'Beep when scan is done.',
                          value: state.beepEnabled,
                          onChanged: cubit.toggleBeep,
                        ),
                      ],
                    );
                  },
                ),
                const Gap(36),

                // const _SectionTitle('Support'),
                // const Gap(16),
                // const _SupportCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Amber, Itim-styled section heading ("Settings" / "Support").
class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 22,
        letterSpacing: 0.2,
      ),
    );
  }
}

/// The grouped Support card holding the three (currently inert) action rows.
///
/// Uses a [Material] (rather than a coloured [Container]) so the ink ripples
/// from each [SupportTile]'s `InkWell` are painted on top of the card's colour
/// instead of being hidden behind it.
class _SupportCard extends StatelessWidget {
  const _SupportCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final divider = Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: Colors.white.withValues(alpha: 0.05),
    );

    return Material(
      color: colorScheme.tertiaryFixedDim,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          SupportTile(
            icon: Icons.verified_rounded,
            title: 'Rate Us',
            subtitle: 'Your best reward to us.',
            onTap: () {},
          ),
          divider,
          SupportTile(
            icon: Icons.share,
            title: 'Share',
            subtitle: 'Share app with others.',
            onTap: () {},
          ),
          divider,
          SupportTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Follow our policies that benefits you.',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

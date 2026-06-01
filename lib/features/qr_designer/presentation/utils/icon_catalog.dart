import 'package:flutter/material.dart';

/// Curated set of built-in Material icons offered as center logos.
///
/// Every entry is a **const** [IconData] so Flutter's icon tree-shaking keeps
/// working (dynamically constructed `IconData` would force
/// `--no-tree-shake-icons`). A selection is persisted by its [IconData.codePoint]
/// and resolved back through [iconForCodePoint].
const List<IconData> kLogoIconCatalog = <IconData>[
  Icons.favorite_rounded,
  Icons.star_rounded,
  Icons.bolt_rounded,
  Icons.rocket_launch_rounded,
  Icons.diamond_rounded,
  Icons.workspace_premium_rounded,
  Icons.verified_rounded,
  Icons.local_fire_department_rounded,
  Icons.eco_rounded,
  Icons.public_rounded,
  Icons.language_rounded,
  Icons.link_rounded,
  Icons.wifi_rounded,
  Icons.qr_code_2_rounded,
  Icons.home_rounded,
  Icons.business_rounded,
  Icons.storefront_rounded,
  Icons.shopping_bag_rounded,
  Icons.shopping_cart_rounded,
  Icons.card_giftcard_rounded,
  Icons.restaurant_rounded,
  Icons.local_cafe_rounded,
  Icons.fastfood_rounded,
  Icons.music_note_rounded,
  Icons.headphones_rounded,
  Icons.movie_rounded,
  Icons.sports_esports_rounded,
  Icons.fitness_center_rounded,
  Icons.directions_car_rounded,
  Icons.flight_rounded,
  Icons.location_on_rounded,
  Icons.camera_alt_rounded,
  Icons.photo_camera_rounded,
  Icons.palette_rounded,
  Icons.brush_rounded,
  Icons.code_rounded,
  Icons.work_rounded,
  Icons.school_rounded,
  Icons.email_rounded,
  Icons.phone_rounded,
  Icons.chat_bubble_rounded,
  Icons.person_rounded,
  Icons.pets_rounded,
  Icons.spa_rounded,
  Icons.local_florist_rounded,
  Icons.celebration_rounded,
  Icons.lightbulb_rounded,
  Icons.lock_rounded,
];

/// Resolves a persisted [codePoint] back to a const catalog [IconData].
///
/// Returns `null` when [codePoint] is null or not part of the current catalog,
/// letting callers decide on a fallback.
IconData? iconForCodePoint(int? codePoint) {
  if (codePoint == null) return null;
  for (final icon in kLogoIconCatalog) {
    if (icon.codePoint == codePoint) return icon;
  }
  return null;
}

/// Bundled brand/social SVG logos offered as center logos, ordered by typical
/// popularity. Stored/selected by their asset path. Registered in `pubspec.yaml`
/// under `assets/social_icons/`.
const List<String> kSocialLogoAssets = <String>[
  'assets/social_icons/Instagram.svg',
  'assets/social_icons/Facebook.svg',
  'assets/social_icons/WhatsApp.svg',
  'assets/social_icons/Telegram.svg',
  'assets/social_icons/TikTok.svg',
  'assets/social_icons/YouTube.svg',
  'assets/social_icons/X.svg',
  'assets/social_icons/Twitter.svg',
  'assets/social_icons/LinkedIn.svg',
  'assets/social_icons/Snapchat.svg',
  'assets/social_icons/Pinterest.svg',
  'assets/social_icons/Messenger.svg',
  'assets/social_icons/Threads.svg',
  'assets/social_icons/Skype.svg',
  'assets/social_icons/Dribbble.svg',
  'assets/social_icons/Behance.svg',
];

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../data_source/models/logo_config.dart';
import '../../data_source/models/qr_design_config.dart';
import '../../data_source/models/qr_design_enums.dart';
import '../../domain/repositories/qr_design_repository.dart';
import '../../domain/use_cases/load_qr_design_use_case.dart';
import '../../domain/use_cases/save_qr_design_use_case.dart';
import 'qr_customization_state.dart';

/// Drives a single QR code's design for one screen or editing session.
///
/// Each QR is identified by its [code] and keeps an independent design. Edits
/// only live in memory (the preview reflects them instantly); nothing is written
/// to storage until [save] is called. This isolation means editing one QR never
/// affects another.
class QrCustomizationCubit extends Cubit<QrCustomizationState> {
  final LoadQrDesignUseCase _loadUseCase;
  final SaveQrDesignUseCase _saveUseCase;
  final IQrDesignRepository _repository;
  final ImagePicker _imagePicker;

  /// The QR payload this cubit's design belongs to.
  String _code = '';

  static const int _maxRecentColors = 18;

  QrCustomizationCubit({
    required LoadQrDesignUseCase loadUseCase,
    required SaveQrDesignUseCase saveUseCase,
    required IQrDesignRepository repository,
    ImagePicker? imagePicker,
  })  : _loadUseCase = loadUseCase,
        _saveUseCase = saveUseCase,
        _repository = repository,
        _imagePicker = imagePicker ?? ImagePicker(),
        super(QrCustomizationState.initial());

  /// Current editable design configuration.
  QrDesignConfig get config => state.config;

  // Lifecycle.

  /// Binds this cubit to [code]. When [initial] is provided it's used directly
  /// (avoids a redundant read); otherwise the design is loaded from storage.
  Future<void> start({required String code, QrDesignConfig? initial}) async {
    _code = code;
    if (initial != null) {
      emit(QrCustomizationState(
        config: initial,
        status: QrCustomizationStatus.ready,
        isDirty: false,
      ));
      return;
    }
    await load();
  }

  /// (Re)loads this QR's saved design (or the global default) from storage.
  Future<void> load() async {
    emit(state.copyWith(status: QrCustomizationStatus.loading));
    try {
      final loaded = await _loadUseCase(_code);
      emit(QrCustomizationState(
        config: loaded,
        status: QrCustomizationStatus.ready,
        isDirty: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: QrCustomizationStatus.error,
        errorMessage: 'Could not load design: $e',
      ));
    }
  }

  /// Persists the current design for this QR. Returns whether it succeeded.
  Future<bool> save() async {
    emit(state.copyWith(status: QrCustomizationStatus.saving));
    try {
      await _saveUseCase(_code, state.config);
      emit(state.copyWith(
        status: QrCustomizationStatus.saved,
        isDirty: false,
        errorMessage: null,
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(
        status: QrCustomizationStatus.error,
        errorMessage: 'Could not save design: $e',
      ));
      return false;
    }
  }

  // QR appearance.

  /// Updates the rendered QR symbol size.
  void setQrSize(double value) =>
      _updateConfig((c) => c.copyWith(qrSize: value));

  /// Updates the QR module foreground color and records it as recent.
  void setForegroundColor(int color) => _updateConfig((c) => c.copyWith(
        foregroundColor: color,
        recentColors: _pushRecent(c.recentColors, color),
      ));

  /// Updates the QR background color and records it as recent.
  void setBackgroundColor(int color) => _updateConfig((c) => c.copyWith(
        backgroundColor: color,
        recentColors: _pushRecent(c.recentColors, color),
      ));

  /// Updates the QR quiet-zone margin.
  void setMargin(double value) =>
      _updateConfig((c) => c.copyWith(margin: value));

  /// Updates the QR module shape.
  void setModuleShape(QrModuleShape shape) =>
      _updateConfig((c) => c.copyWith(moduleShape: shape));

  /// Updates the QR module corner roundness.
  void setModuleRoundness(double value) =>
      _updateConfig((c) => c.copyWith(moduleRoundness: value));

  /// Toggles unified finder and alignment pattern styling when supported.
  void setUnifiedEyes(bool value) =>
      _updateConfig((c) => c.copyWith(unifiedEyes: value));

  /// Updates the padding inside the QR card.
  void setContainerPadding(double value) =>
      _updateConfig((c) => c.copyWith(containerPadding: value));

  /// Updates the QR card corner radius.
  void setContainerBorderRadius(double value) =>
      _updateConfig((c) => c.copyWith(containerBorderRadius: value));

  /// Updates the QR card border color and records it as recent.
  void setContainerBorderColor(int color) => _updateConfig((c) => c.copyWith(
        containerBorderColor: color,
        recentColors: _pushRecent(c.recentColors, color),
      ));

  /// Updates the QR card border width.
  void setContainerBorderWidth(double value) =>
      _updateConfig((c) => c.copyWith(containerBorderWidth: value));

  // Logo selection.

  /// Updates the selected logo source type.
  void setLogoType(LogoType type) =>
      _updateLogo((logo) => logo.copyWith(type: type));

  /// Selects a built-in Material icon as the logo.
  void setMaterialIcon(int codePoint) => _updateLogo(
        (logo) => logo.copyWith(
          type: LogoType.materialIcon,
          materialIconCodePoint: codePoint,
          // Keep a single icon source active at a time.
          assetIconPath: null,
        ),
      );

  /// Selects a built-in bundled SVG asset (e.g. a social logo) as the logo.
  void setSocialIcon(String assetPath) => _updateLogo(
        (logo) => logo.copyWith(
          type: LogoType.assetIcon,
          assetIconPath: assetPath,
          // Keep a single icon source active at a time.
          materialIconCodePoint: null,
        ),
      );

  /// Picks a gallery image, copies it to durable storage and sets it as logo.
  Future<void> pickLogoImage() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      if (picked == null) return;
      // Don't delete the prior file here: the saved config may still reference
      // it until the user explicitly saves. A rare orphan is safer than a
      // dangling reference that would blank the logo after a restart.
      final stablePath = await _repository.persistLogoFile(picked.path);
      _updateLogo(
        (logo) => logo.copyWith(type: LogoType.image, imagePath: stablePath),
      );
    } catch (e) {
      _emitError('Could not load image: $e');
    }
  }

  /// Picks an `.svg` file, copies it to durable storage and sets it as logo.
  Future<void> pickLogoSvg() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['svg'],
      );
      final path = result?.files.single.path;
      if (path == null) return;
      final stablePath = await _repository.persistLogoFile(path);
      _updateLogo(
        (logo) => logo.copyWith(type: LogoType.svg, svgPath: stablePath),
      );
    } catch (e) {
      _emitError('Could not load SVG: $e');
    }
  }

  /// Removes the configured logo and clears all logo source paths.
  void removeLogo() => _updateLogo(
        (logo) => logo.copyWith(
          type: LogoType.none,
          materialIconCodePoint: null,
          imagePath: null,
          svgPath: null,
          assetIconPath: null,
        ),
      );

  // Logo appearance.

  /// Updates the logo content size.
  void setLogoSize(double value) =>
      _updateLogo((logo) => logo.copyWith(size: value));

  /// Updates the Material icon logo color and records it as recent.
  void setLogoColor(int color) => _updateConfig((c) => c.copyWith(
        logo: c.logo.copyWith(color: color),
        recentColors: _pushRecent(c.recentColors, color),
      ));

  /// Updates the logo badge background color and records it as recent.
  void setLogoBackgroundColor(int color) => _updateConfig((c) => c.copyWith(
        logo: c.logo.copyWith(backgroundColor: color),
        recentColors: _pushRecent(c.recentColors, color),
      ));

  /// Updates the logo badge border color and records it as recent.
  void setLogoBorderColor(int color) => _updateConfig((c) => c.copyWith(
        logo: c.logo.copyWith(borderColor: color),
        recentColors: _pushRecent(c.recentColors, color),
      ));

  /// Updates the logo badge border width.
  void setLogoBorderWidth(double value) =>
      _updateLogo((logo) => logo.copyWith(borderWidth: value));

  /// Updates the logo badge corner radius.
  void setLogoBorderRadius(double value) =>
      _updateLogo((logo) => logo.copyWith(borderRadius: value));

  /// Updates the padding between the logo content and badge edge.
  void setLogoPadding(double value) =>
      _updateLogo((logo) => logo.copyWith(padding: value));

  /// Updates the logo badge opacity.
  void setLogoOpacity(double value) =>
      _updateLogo((logo) => logo.copyWith(opacity: value));

  /// Updates the logo badge shape.
  void setLogoShape(LogoShape shape) =>
      _updateLogo((logo) => logo.copyWith(shape: shape));

  /// Toggles the logo badge shadow.
  void setLogoShadow(bool value) =>
      _updateLogo((logo) => logo.copyWith(shadow: value));

  /// Updates the logo badge elevation used for shadow depth.
  void setLogoElevation(double value) =>
      _updateLogo((logo) => logo.copyWith(elevation: value));

  /// Updates the backdrop blur behind the logo badge.
  void setLogoBlur(double value) =>
      _updateLogo((logo) => logo.copyWith(blur: value));

  /// Toggles a transparent logo badge background.
  void setLogoTransparentBackground(bool value) =>
      _updateLogo((logo) => logo.copyWith(transparentBackground: value));

  // Color library.

  /// Adds [color] to the recent color list without changing the active design.
  void registerRecentColor(int color) => _updateConfig(
      (c) => c.copyWith(recentColors: _pushRecent(c.recentColors, color)));

  /// Adds or removes [color] from the favorite color list.
  void toggleFavoriteColor(int color) => _updateConfig((c) {
        final favorites = List<int>.from(c.favoriteColors);
        if (favorites.contains(color)) {
          favorites.remove(color);
        } else {
          favorites.insert(0, color);
        }
        return c.copyWith(favoriteColors: favorites);
      });

  // Reset actions are in-memory only and are persisted on the next save.

  /// Resets only QR appearance values while preserving logo and color lists.
  void resetQrSettings() => _updateConfig((c) => c.resetQrAppearance());

  /// Resets the logo configuration to defaults.
  void resetLogoSettings() => _updateLogo((_) => LogoConfig.defaults());

  /// Clears recent and favorite colors.
  void resetColors() => _updateConfig(
        (c) => c.copyWith(recentColors: const [], favoriteColors: const []),
      );

  /// Resets the whole design back to defaults in the current session (not yet
  /// persisted; the user still has to save).
  void resetEverything() => _updateConfig((_) => QrDesignConfig.defaults());

  // Internals.

  void _updateConfig(QrDesignConfig Function(QrDesignConfig config) update) {
    emit(state.copyWith(
      config: update(state.config),
      status: QrCustomizationStatus.ready,
      isDirty: true,
      errorMessage: null,
    ));
  }

  void _updateLogo(LogoConfig Function(LogoConfig logo) update) {
    _updateConfig((c) => c.copyWith(logo: update(c.logo)));
  }

  void _emitError(String message) {
    emit(state.copyWith(
      status: QrCustomizationStatus.error,
      errorMessage: message,
    ));
  }

  List<int> _pushRecent(List<int> current, int color) {
    final updated = List<int>.from(current)..remove(color);
    updated.insert(0, color);
    if (updated.length > _maxRecentColors) {
      return updated.sublist(0, _maxRecentColors);
    }
    return updated;
  }
}

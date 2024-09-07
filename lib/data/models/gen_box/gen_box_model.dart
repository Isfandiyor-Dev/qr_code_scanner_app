class GenBox {
  final String name;
  final String? fieldLabel;
  final void Function(String value)? onPressed;
  final String iconPath;

  GenBox({
    required this.name,
    this.fieldLabel,
    this.onPressed,
    required this.iconPath,
  });
}

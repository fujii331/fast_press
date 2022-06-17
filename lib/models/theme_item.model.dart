class ThemeItem {
  final String themeWord;
  final String themeRule;
  final int clearQuantity;
  final List<String> displayTargets;
  final bool isImage;

  const ThemeItem({
    required this.themeWord,
    required this.themeRule,
    required this.clearQuantity,
    required this.displayTargets,
    required this.isImage,
  });
}

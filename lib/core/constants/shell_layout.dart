/// Shell layout tokens from Figma (326px inner frame).
///
/// Bottom nav: [navHorizontalInset] on sides, [navBottomInset] below the bar.
/// Page content uses [contentHorizontalPadding] (narrower than the nav bar).
class ShellLayout {
  ShellLayout._();

  static const double navHorizontalInset = 14;
  static const double navBottomInset = 0;
  static const double contentNavInsetDelta = 10;
  static const double contentHorizontalPadding =
      navHorizontalInset + contentNavInsetDelta;

  static const double navBarHeight = 70;
  static const double navBottomRadius = 30;
  static const double navInnerHorizontalPadding = 6;
}

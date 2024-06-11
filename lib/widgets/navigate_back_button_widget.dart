import '../all_utills.dart';

class NavigateBackButtonWidget extends StatelessWidget {
  const NavigateBackButtonWidget({
    super.key,
    this.hasLogo = true,
    this.hasIcon = true,
  });

  final bool hasLogo;
  final bool hasIcon;

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(120, 120, 120, 0.10),
        borderRadius: AppWidgets.halfBorderRadius,
      ),
      child: const Icon(Icons.arrow_back_ios_new_outlined),
    );

    return Column(
      children: [
        // AppWidgets.halfVerticalGap,
        Row(
          children: [
            if (hasIcon)
              GestureDetector(
                onTap: () => _onPressed(context),
                child: widget,
              ),
            if (hasLogo)
              Expanded(
                child: Center(child: SvgPicture.asset(Assets.icons.logo)),
              ),
            if (hasIcon)
              Opacity(
                opacity: 0,
                child: widget,
              ),
          ],
        ),
      ],
    );
  }

  void _onPressed(BuildContext context) =>
      Utils.displayToast('Feature not integrated yet!');
}

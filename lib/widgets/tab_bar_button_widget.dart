import '../all_utills.dart';

class TabBarButtonWidget extends StatelessWidget {
  const TabBarButtonWidget({
    super.key,
    this.isSelected = false,
    required this.text,
  });

  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppWidgets.borderRadius,
        color: isSelected ? context.theme.primaryColor : Colors.transparent,
        border: isSelected ? null : Border.all(color: context.theme.hintColor),
        gradient: AppColors.buttonGradient,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Text(
        text,
        style: context.textTheme.bodyLarge,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}

import '../../all_utills.dart';

class SomosCaptionTextField extends StatefulWidget {
  const SomosCaptionTextField({
    super.key,
    this.maxLines = 1,
    this.enabled = true,
    this.obscureText = false,
    this.isTitleRequired = false,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.sentences,
    this.title,
    this.hintText,
    this.controller,
    // TODO make these two required later
    // this.onChanged,
    this.validator,
    this.prefix,
    this.suffix,
    this.titleStyle,
    this.inputFormatters,
    this.maxLength,
    this.onChanged,
    this.autoValidateMode,
    this.suffixIcon,
    this.prefixIcon,
  });

  final bool enabled;
  final bool obscureText;
  final bool isTitleRequired;
  final int? maxLines, maxLength;
  final String? title;
  final String? hintText;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final TextInputType textInputType;
  final AutovalidateMode? autoValidateMode;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  // final void Function(String?)? onChanged;
  final TextStyle? titleStyle;
  final List<FilteringTextInputFormatter>? inputFormatters;

  final Widget? prefix;
  final Widget? suffix;
  final void Function(String?)? onChanged;

  @override
  State<SomosCaptionTextField> createState() => _SomosCaptionTextFieldState();
}

class _SomosCaptionTextFieldState extends State<SomosCaptionTextField> {
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          CustomFieldTitleWidget(
            title: widget.title!,
            isTitleRequired: widget.isTitleRequired,
          ),
        if (widget.title != null) Gap(8.h),
        TextFormField(
          enabled: widget.enabled,
          autovalidateMode:
              widget.autoValidateMode ?? AutovalidateMode.onUserInteraction,
          obscureText: _obscureText,
          maxLength: widget.maxLength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          decoration: InputDecoration(
            counterText: '',
            labelStyle: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colorScheme.onTertiary,
            ),
            hintStyle: context.textTheme.bodyLarge?.copyWith(
              color: AppColors.hintStyle,
            ),
            hintText: widget.hintText,
            suffixIcon: widget.suffixIcon ??
                (widget.obscureText
                    // TODO color here not working for dark mode
                    ? IconButton(
                        icon: _obscureText
                            ? SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: SvgPicture.asset(
                                  Assets.icons.hidePassword,
                                  color: context.theme.hintColor,
                                ),
                              )
                            : SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: SvgPicture.asset(
                                  Assets.icons.showPassword,
                                  color: context.theme.hintColor,
                                ),
                              ),
                        onPressed: _onPressed,
                        // fit: BoxFit.cover,
                      )
                    : widget.suffix),
            prefixIcon: widget.prefix,
            suffixIconColor: context.colorScheme.onTertiary,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
          controller: widget.controller,
          textInputAction: widget.textInputAction,
          keyboardType: widget.textInputType,
          maxLines: widget.maxLines,
          validator: widget.validator,
          textCapitalization: widget.textCapitalization,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
        ),
      ],
    );
  }

  void _onPressed() => setState(() => _obscureText = !_obscureText);
}

class CustomFieldTitleWidget extends StatelessWidget {
  const CustomFieldTitleWidget({
    super.key,
    this.isTitleRequired = true,
    required this.title,
  });

  final bool isTitleRequired;
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Text(
          title,
          style: textTheme.bodyLarge,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        if (isTitleRequired) const SizedBox(width: 2),
        if (isTitleRequired)
          Text(
            '*',
            style: textTheme.bodyLarge?.copyWith(color: Colors.red),
          )
      ],
    );
  }
}

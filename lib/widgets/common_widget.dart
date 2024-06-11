import '../all_utills.dart';

class VerticalSpacing extends StatelessWidget {
  const VerticalSpacing({super.key, this.of = 20});

  final double of;

  @override
  Widget build(BuildContext context) => SizedBox(height: of.h);
}

class HorizontalSpacing extends StatelessWidget {
  const HorizontalSpacing({super.key, this.of = 20});

  final double of;

  @override
  Widget build(BuildContext context) => SizedBox(width: of.w);
}

class SomosElevatedButton extends StatefulWidget {
  const SomosElevatedButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor,
    this.borderColor,
    this.bottomMargin = false,
    this.bottomMarginValue,
    this.size,
  });

  final String title;
  final FutureBuildContextCallback? onPressed;
  final bool bottomMargin;
  final Size? size;
  final double? bottomMarginValue;

  final Color? backgroundColor;
  final Color? borderColor;

  @override
  State<SomosElevatedButton> createState() => _SomosElevatedButtonState();
}

class _SomosElevatedButtonState extends State<SomosElevatedButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.bottomMargin
          ? EdgeInsets.only(bottom: widget.bottomMarginValue?.h ?? 15.h)
          : null,
      decoration: BoxDecoration(
        gradient:
            widget.backgroundColor == null ? AppColors.buttonGradient : null,
        borderRadius: BorderRadius.circular(16.h),
        border: widget.borderColor == null
            ? null
            : Border.all(color: widget.borderColor!),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          fixedSize: widget.size,
          backgroundColor: widget.backgroundColor ?? Colors.transparent,
        ),
        onPressed:
            widget.onPressed == null ? null : () => _onButtonPressed(context),
        child: _isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 3.0.h,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.theme.hintColor,
                  ),
                ),
              )
            : Text(
                widget.title,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
      ),
    );
  }

  void _onButtonPressed(BuildContext context) async {
    try {
      if (mounted) setState(() => _isLoading = true);

      await widget.onPressed!(context);

      if (mounted) setState(() => _isLoading = false);
    } catch (r) {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class BackgroundImageWidget extends StatelessWidget {
  const BackgroundImageWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.screenSize.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.images.background.path),
          fit: BoxFit.fill,
          opacity: 0.7,
        ),
        color: context.theme.scaffoldBackgroundColor,
      ),
      child: SafeArea(child: child),
    );
  }
}

class SomosContainer extends StatelessWidget {
  final Widget? child;
  final BuildContextCallback? onPressed;
  final double? width;
  final EdgeInsets? margin;
  final DecorationImage? image;
  final BoxBorder? border;
  final BoxShape shape;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final BorderRadiusGeometry? borderRadius;
  final Color? color;
  final EdgeInsets? padding;
  final double? height;
  final Alignment? alignment;

  const SomosContainer(
      {super.key,
      this.child,
      this.width,
      this.height,
      this.alignment,
      this.color,
      this.padding,
      this.image,
      this.border,
      this.borderRadius,
      this.shape = BoxShape.rectangle,
      this.onPressed,
      this.margin,
      this.gradient,
      this.boxShadow});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed == null ? null : () => onPressed!(context),
      child: Container(
        margin: margin,
        alignment: alignment,
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
            boxShadow: boxShadow,
            color: gradient == null ? color : null,
            border: border,
            gradient: color == null ? gradient : null,
            image: image,
            borderRadius: borderRadius,
            shape: shape),
        child: child,
      ),
    );
  }
}

class BaseScaffold extends StatelessWidget {
  final Widget child;
  final bool? extendBodyBehindAppBar;
  final bool resizeBottomInset;
  final Widget? appBarTitleWidget;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final EdgeInsets? scaffoldPadding;
  final double appBarHeight;
  final bool showLeading;
  final String? appBarTitle;
  final bool showAppBar;
  final bool appBarCenterTitle;
  final Widget? leadingAppBar;
  final bool showBackButton;
  final List<Widget> appBarAction;
  final bool bottomSafeArea;
  final double? leadingWidthAppBar;
  final bool showAppBarBackButton;
  final PreferredSizeWidget? bottom;

  const BaseScaffold({
    super.key,
    required this.child,
    this.bottomSafeArea = true,
    this.showAppBarBackButton = true,
    this.appBarTitle,
    this.appBarCenterTitle = true,
    this.appBarAction = const [],
    this.leadingAppBar,
    this.showBackButton = true,
    this.leadingWidthAppBar,
    this.bottom,
    this.appBarHeight = 56,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.showAppBar = true,
    this.resizeBottomInset = true,
    this.extendBodyBehindAppBar,
    this.scaffoldPadding,
    this.showLeading = true,
    this.appBarTitleWidget,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: resizeBottomInset,
        bottomSheet: bottomSheet,
        bottomNavigationBar: bottomNavigationBar,
        extendBodyBehindAppBar: extendBodyBehindAppBar ?? true,
        appBar: showAppBar
            ? SomosAppBar(
                title: appBarTitle,
                appBarHeight: appBarHeight,
                leadingWidget: leadingAppBar,
                action: appBarAction,
                showLeading: showLeading,
                titleWidget: appBarTitleWidget,
                leadingWidth: leadingWidthAppBar,
              )
            : null,
        body: HideKeyboardOnBackgroundClick(
          child: BackgroundImageWidget(
            child: SafeArea(
              bottom: bottomSafeArea,
              child: Padding(
                padding:
                    scaffoldPadding ?? EdgeInsets.symmetric(horizontal: 20.w),
                child: child,
              ),
            ),
          ),
        ),
      );
}

class HideKeyboardOnBackgroundClick extends StatelessWidget {
  final Widget child;

  const HideKeyboardOnBackgroundClick({super.key, required this.child});

  @override
  Widget build(BuildContext context) => GestureDetector(
      child: child, onTap: () => FocusManager.instance.primaryFocus?.unfocus());
}

class CacheImage extends StatelessWidget {
  final String imageUrl;
  final double? height, width;
  final BoxFit boxFit;
  final double borderWidth;
  final Gradient? gradient;
  final bool showGradient;
  final bool isCircle;
  final Color? color;
  final Alignment? alignment;
  final double? placeholderSize;

  const CacheImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.boxFit = BoxFit.contain,
    this.borderWidth = 0,
    this.isCircle = false,
    this.color,
    this.placeholderSize,
    this.alignment,
    this.gradient,
    this.showGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    // TODO remove it after having a proper image
    if (imageUrl == 'https://assets.coinlayer.com/icons/AVAX.png' ||
        imageUrl == 'https://assets.coinlayer.com/icons/SOL.png') {
      return SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Icon(
            Icons.question_mark,
            size: width,
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => SomosContainer(
        width: width,
        alignment: alignment,
        height: height,
        gradient: showGradient ? AppColors.buttonGradient : gradient,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        image: DecorationImage(
          image: imageProvider,
          fit: boxFit,
        ),
      ),
      placeholder: (context, url) => placeholderWidget(),
      errorWidget: (context, url, error) => SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Icon(
            Icons.question_mark,
            size: width,
          ),
        ),
      ),
    );
  }

  // fixed it because of the out of bound constraints error when loading
  Widget placeholderWidget() => SizedBox(
        width: width,
        height: height,
        child: const Center(child: CircularProgressIndicator.adaptive()),
      );
}

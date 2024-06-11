import 'package:somos_app/gen/fonts.gen.dart';

import '../../all_screen.dart';
import '../../all_utills.dart';

class LandingPageScreen extends ConsumerWidget {
  static const String routeName = '/LandingPageScreen';

  const LandingPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      showLeading: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const OnBoardingWidget(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTexts.unlockFuturesOfFinance.toUpperCase(),
                style: context.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.normal,
                  letterSpacing: -1,
                  fontSize: 54.sp,
                  fontFamily: FontFamily.bebas,
                ),
              ),
              Gap(8.h),
              Text(
                AppTexts.takeYourInvestment,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.normal,
                  color: context.theme.hintColor,
                  fontSize: 20.sp,
                ),
              ),
              Gap(30.h),
              SomosElevatedButton(
                title: AppTexts.createWallet,
                onPressed: (context) => _onCreateWalletPressed(context, ref),
              ),
              Gap(15.h),
              SomosElevatedButton(
                title: AppTexts.importWallet,
                bottomMargin: true,
                onPressed: (context) => _onImportWalletPressed(context, ref),
                backgroundColor: Colors.black,
                borderColor: context.theme.hintColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onCreateWalletPressed(
      BuildContext context, WidgetRef ref) async {
    context.push(CreatePasswordScreen.routeName);
  }

  Future<void> _onImportWalletPressed(
      BuildContext context, WidgetRef ref) async {
    context.push(ImportWalletScreen.routeName);
  }
}

class TabPageIndicatorWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const TabPageIndicatorWidget(
      {super.key, this.selectedIndex = 0, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      primary: true,
      padding: EdgeInsets.zero,
      itemCount: 3,
      // Change this to the number of tabs you have
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => onTap(index),
          child: PageIndicatorWidget(
            isSelected: selectedIndex == index,
          ),
        );
      },
    );
  }
}

class PageIndicatorWidget extends StatelessWidget {
  final bool isSelected;

  const PageIndicatorWidget({
    super.key,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 40.w,
      height: 30.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: !isSelected
            ? null
            : const GradientBoxBorder(gradient: AppColors.buttonGradient),
      ),
      margin: EdgeInsets.symmetric(horizontal: 5.0.w),
      child: Container(
        width: 10.w,
        height: 10.h,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}

class OnBoardingWidget extends StatefulWidget {
  const OnBoardingWidget({super.key});

  @override
  State<OnBoardingWidget> createState() => _OnBoardingWidgetState();
}

class _OnBoardingWidgetState extends State<OnBoardingWidget> {
  final pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.41.sh,
      width: 1.sw,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          SizedBox(
            height: 0.3.sh,
            child: PageView(
              controller: pageController,
              onPageChanged: _updateCurrentPage,
              children: [
                Image.asset(
                  Assets.images.landingPageView1.path,
                  height: 268.h,
                  fit: BoxFit.contain,
                ),
                Image.asset(
                  Assets.images.landingPageView2.path,
                  height: 268.h,
                  fit: BoxFit.contain,
                ),
                Image.asset(
                  Assets.images.landingPageView3.path,
                  height: 268.h,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 0.07.sh,
            child: TabPageIndicatorWidget(
              selectedIndex: currentPage,
              onTap: (int value) {
                setState(() => currentPage = value);

                pageController.jumpToPage(currentPage);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _updateCurrentPage(int value) => setState(() => currentPage = value);
}

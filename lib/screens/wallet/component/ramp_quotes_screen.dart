// import 'package:somos_app/all_utills.dart';
//
// import 'payment_method_screen.dart';
//
// class RampQuoteScreen extends StatefulWidget {
//   static const String routeName = '/RampQuoteScreen';
//   const RampQuoteScreen({super.key});
//
//   @override
//   State<RampQuoteScreen> createState() => _RampQuoteScreenState();
// }
//
// class _RampQuoteScreenState extends State<RampQuoteScreen> {
//   int _secondsRemaining = 20;
//   late Timer _timer;
//   @override
//   void initState() {
//     if (context.mounted) {
//       startTimer();
//     }
//     super.initState();
//   }
//
//   void startTimer() {
//     _timer = Timer.periodic(
//       const Duration(seconds: 1),
//       (timer) {
//         if (_secondsRemaining > 0) {
//           setState(() {
//             _secondsRemaining--;
//           });
//         } else {
//           setState(() {
//             _secondsRemaining = 30;
//           });
//         }
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffold(
//       appBarTitleWidget:  QuoteTitleWidget(
//         title: 'Select a Quote',
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             const VerticalSpacing(of: 30),
//             SomosContainer(
//               borderRadius: BorderRadius.circular(8),
//               color: AppColors.hintStyle,
//               padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
//               child: RichText(
//                 text: TextSpan(
//                     text: 'New Quotes in ',
//                     children: [TextSpan(text: '0.$_secondsRemaining s')]),
//               ),
//             ),
//             const VerticalSpacing(of: 15),
//             Text(
//               'Compare rates from these providers.\n Quotes are sorted by overall price.',
//               style: context.textTheme.headlineMedium?.copyWith(
//                 fontSize: 18.sp,
//                 letterSpacing: 0.5,
//                 color: AppColors.textColor,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             const VerticalSpacing(),
//             RampDetailWidget(
//               onPressed: _rampPressed,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _rampPressed(BuildContext context) async {}
// }
//
// class RampDetailWidget extends StatelessWidget {
//   final FutureBuildContextCallback onPressed;
//   const RampDetailWidget({super.key, required this.onPressed});
//
//   @override
//   Widget build(BuildContext context) {
//     return SomosContainer(
//         borderRadius: BorderRadius.circular(8),
//         padding: const EdgeInsets.all(15),
//         border: const GradientBoxBorder(gradient: AppColors.buttonGradient),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Image.asset(
//                   Assets.images.rampLogo.path,
//                   fit: BoxFit.contain,
//                   width: 90.w,
//                   height: 20.h,
//                 ),
//                 const HorizontalSpacing(of: 10),
//                 const Icon(Icons.info_outline_rounded)
//               ],
//             ),
//             const VerticalSpacing(),
//             const RateConversionWidget(),
//             const VerticalSpacing(),
//             SomosElevatedButton(
//                 title: 'Continue with Ramp', onPressed: onPressed)
//           ],
//         ));
//   }
//
//   Future<void> _pressedContinueRamp(BuildContext context) async {}
// }
//
// class RateConversionWidget extends StatelessWidget {
//   final String? currentCurrency;
//   final String? conversionCurrency;
//   const RateConversionWidget(
//       {super.key, this.currentCurrency, this.conversionCurrency});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(currentCurrency ?? '0.0694 ETH',
//             style: context.textTheme.bodyLarge
//                 ?.copyWith(fontWeight: FontWeight.w700)),
//         Text("≈ ${conversionCurrency ?? '\$ 247.4 USD'}",
//             style: context.textTheme.bodyLarge
//                 ?.copyWith(fontWeight: FontWeight.w700))
//       ],
//     );
//   }
// }

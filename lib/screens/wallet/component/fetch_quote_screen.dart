// import 'package:somos_app/all_utills.dart';
// import 'package:somos_app/screens/wallet/component/payment_method_screen.dart';
// import 'package:step_progress_indicator/step_progress_indicator.dart';
//
// class FetchingQuoteScreen extends ConsumerWidget {
//   static const String routeName = '/FetchingQuoteScreen';
//   const FetchingQuoteScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return BaseScaffold(
//       appBarTitleWidget: const QuoteTitleWidget(title: 'Select a quote'),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'Fetching Quotes',
//             style: context.textTheme.headlineLarge
//                 ?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700),
//           ),
//           const VerticalSpacing(of: 15),
//           const StepProgressIndicator(
//             totalSteps: 5,
//             unselectedColor: AppColors.textColor,
//             currentStep: 4,
//             size: 8,
//             padding: 0,
//             roundedEdges: Radius.circular(8),
//             selectedGradientColor: AppColors.buttonGradient,
//           ),
//           const VerticalSpacing(of: 15),
//           Image.asset(Assets.images.fetchQuote.path,
//               width: 250.w, height: 150.h, fit: BoxFit.cover)
//         ],
//       ),
//     );
//   }
// }

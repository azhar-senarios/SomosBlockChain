// import 'package:somos_app/all_utills.dart';
// import 'package:somos_app/screens/wallet/sell_screen.dart';
//
// class PaymentScreen extends ConsumerWidget {
//   const PaymentScreen({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final paymentOptionsAsyncValue = ref.watch(paymentOptionsProvider);
//     final selectedPaymentOption = ref.watch(selectedPaymentOptionProvider);
//
//     return paymentOptionsAsyncValue.when(
//       data: (paymentOptions) {
//         return paymentOptions != null && paymentOptions.isNotEmpty
//             ? ListView.builder(
//                 shrinkWrap: true,
//                 primary: true,
//                 padding: EdgeInsets.symmetric(vertical: 20.h),
//                 itemCount: paymentOptions.length,
//                 itemBuilder: (context, index) {
//                   final paymentOption = paymentOptions[index];
//                   return PaymentRadioButton(
//                     title: paymentOption.title,
//                     paymentOption: paymentOption,
//                     selectedPaymentOption: selectedPaymentOption,
//                     onChanged: (value) {
//                       ref.read(selectedPaymentOptionProvider.notifier).state =
//                           value;
//                       context.pop();
//                     },
//                   );
//                 },
//               )
//             : Center(
//                 child: Text(
//                   'No Payment Method Found',
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//               );
//       },
//       loading: Utils.buildLoadingHandlerWidget,
//       error: Utils.buildErrorHandlerWidget,
//     );
//   }
// }
//
// class PaymentRadioButton extends ConsumerWidget {
//   final String title;
//   final PaymentOption paymentOption;
//   final PaymentOption? selectedPaymentOption;
//   final ValueChanged<PaymentOption?> onChanged;
//
//   const PaymentRadioButton({
//     super.key,
//     required this.title,
//     required this.paymentOption,
//     required this.selectedPaymentOption,
//     required this.onChanged,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return SomosContainer(
//       borderRadius: BorderRadius.circular(8),
//       margin: EdgeInsets.only(bottom: 10.h),
//       border: selectedPaymentOption == paymentOption
//           ? const GradientBoxBorder(gradient: AppColors.buttonGradient)
//           : Border.all(color: context.colorScheme.background),
//       child: ListTile(
//         dense: true,
//         visualDensity: const VisualDensity(vertical: -2),
//         contentPadding: EdgeInsets.only(left: 15.w),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//           side: const BorderSide(
//             color: AppColors.textPlaceHolderColor,
//           ),
//         ),
//         title: Text(
//           title,
//           style: Theme.of(context).textTheme.bodyLarge,
//         ),
//         leading: Icon(
//           paymentOption.icon,
//         ),
//         trailing: Radio(
//           value: paymentOption,
//           activeColor: AppColors.primaryColor,
//           groupValue: selectedPaymentOption,
//           onChanged: onChanged,
//           fillColor: MaterialStateProperty.all(
//             paymentOption == selectedPaymentOption
//                 ? AppColors.primaryColor
//                 : AppColors.textPlaceHolderColor,
//           ),
//         ),
//         onTap: () => onChanged(paymentOption),
//       ),
//     );
//   }
// }
//
// class PaymentOption {
//   final String title;
//   final IconData icon;
//
//   PaymentOption({required this.title, required this.icon});
//   static final dummyPaymentOptions = [
//     PaymentOption(title: 'Credit Card', icon: Icons.credit_card),
//     PaymentOption(title: 'PayPal', icon: Icons.payment),
//     PaymentOption(title: 'Google Pay', icon: Icons.payment),
//     PaymentOption(title: 'Apple Pay', icon: Icons.payment),
//   ];
// }
//
// class QuoteTitleWidget extends StatelessWidget {
//   final String? title;
//   final String? subTitle;
//   const QuoteTitleWidget({super.key, this.title, this.subTitle});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title ?? 'Payment Method',
//           style: Theme.of(context).textTheme.headlineLarge,
//         ),
//         Row(
//           children: [
//             SomosContainer(
//               margin: EdgeInsets.only(top: 5.h),
//               width: 8.w,
//               height: 8.h,
//               shape: BoxShape.circle,
//               color: AppColors.greenColor,
//             ),
//             const HorizontalSpacing(of: 8),
//             Text(
//               subTitle ?? 'Ethereum Main Network',
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//           ],
//         )
//       ],
//     );
//   }
// }

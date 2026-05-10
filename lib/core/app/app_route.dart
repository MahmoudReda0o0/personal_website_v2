// class AppRoutes {
//   static const login = '/login';
//   static const home = '/home';
//   static const notifications = '/notifications';
//   static const attendance = '/attendance';
//   static const attendanceReport = '/attendance-report';
//   static const faceAttendance = '/face-attendance';
//   static const expenses = '/expenses';
//   static const expenseCreate = '/expense-create';
//   static const payslips = '/payslips';
//   static const salaries = '/salaries';
//   static const contracts = '/contracts';
//   static const timeOff = '/time-off';
//   static const holidays = '/holidays';
//   static const requestHoliday = '/requestHoliday';
//   static const profile = '/profile';
// }

// class AppPages {
//   static final pages = [
//     GetPage(
//       name: AppRoutes.login,
//       page: () => LoginScreen(),
//       binding: BindingsBuilder(() {
//         Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
//       }),
//     ),
//     GetPage(
//       name: AppRoutes.home,
//       page: () => const HomeScreen(),
//       binding: BindingsBuilder(() {
//         Get.put(HomeController(), permanent: true);
//       }),
//     ),
//     GetPage(
//       name: AppRoutes.notifications,
//       page: () => NotificationScreen(),
//       binding: BindingsBuilder(() {
//         Get.lazyPut<NotificationController>(
//           () => NotificationController(),
//           fenix: true,
//         );
//       }),
//     ),
//     GetPage(
//       name: AppRoutes.attendance,
//       page: () => const AttendanceScreen(),
//       binding: BindingsBuilder(() {
//         Get.lazyPut<AttendanceController>(() => AttendanceController());
//       }),
//     ),
//     GetPage(
//       name: AppRoutes.attendanceReport,
//       page: () => const AttendanceReportScreen(),
//     ),
//     GetPage(
//       name: AppRoutes.faceAttendance,
//       page: () => const FaceAttendanceScreen(),
//     ),
//     GetPage(name: AppRoutes.expenses, page: () => const ExpenseScreen()),
//     GetPage(
//       name: AppRoutes.expenseCreate,
//       page: () => const ExpenseCreateScreen(),
//     ),
//     // GetPage(name: AppRoutes.payslips, page: () => const PayslipScreen()),
//     GetPage(
//       name: AppRoutes.payslips,
//       page: () => PayslipScreen(),
//       binding: BindingsBuilder(() {
//         Get.lazyPut<PayslipController>(() => PayslipController(), fenix: true);
//       }),
//     ),
//     GetPage(name: AppRoutes.contracts, page: () => const ContractsScreen()),
//     GetPage(name: AppRoutes.timeOff, page: () => const TeamOffScreen()),
//     GetPage(name: AppRoutes.requestHoliday, page: () => RequestHolidayScreen()),
//     GetPage(
//       name: AppRoutes.profile,
//       page: () => ProfileScreen(),
//       binding: BindingsBuilder(() {
//         Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
//       }),
//     ),
//     GetPage(
//       name: AppRoutes.holidays,
//       page: () => const HolidaysScreen(),
//       binding: BindingsBuilder(() {
//         Get.lazyPut<HolidaysController>(() => HolidaysController());
//       }),
//     ),
//   ];
// }

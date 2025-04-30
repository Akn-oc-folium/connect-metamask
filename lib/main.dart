import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:web3_flutter/views/dashboard.dart';
import 'package:web3_flutter/views/stock_filter_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      title: 'Dashboard App',
      theme: ThemeData(colorScheme: ColorSchemes.lightNeutral(), radius: 0.7),
      home: StockFilterPage(),
    );
  }
}

//Dashboard
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ShadcnApp(
//       title: 'Dashboard App',
//       theme: ThemeData(colorScheme: ColorSchemes.lightNeutral(), radius: 0.7),
//       home: Dashboard(),
//     );
//   }
// }

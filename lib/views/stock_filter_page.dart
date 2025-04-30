import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../viewmodels/stock_filter_viewmodel.dart';
import '../widgets/filter_stocks_form.dart';

class StockFilterPage extends StatelessWidget {
  const StockFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StockFilterViewModel>.reactive(
      viewModelBuilder: () => StockFilterViewModel(),
      builder: (context, vm, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Build a Strategy')),
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: FilterStocksForm(),
          ),
        );
      },
    );
  }
}

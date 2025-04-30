// lib/viewmodels/stock_filter_viewmodel.dart

import 'package:stacked/stacked.dart';

class AdvancedFilter {
  String label;
  double? from;
  double? to;
  AdvancedFilter({required this.label, this.from, this.to});
}

class StockFilterViewModel extends BaseViewModel {
  String strategyName = '';
  String? strategyCategory;
  String? stockUniverse;
  String? sector;
  bool allSectors = false;
  bool smallcap = false;
  bool midcap = false;
  bool largecap = false;

  // NEW: option lists
  List<String> get categoryOptions => ['Growth', 'Value', 'Income'];
  List<String> get universeOptions => ['NYSE', 'NASDAQ', 'AMEX'];
  List<String> get sectorOptions => ['Tech', 'Finance', 'Industrial'];

  bool _filterExpanded = false;
  bool get filterExpanded => _filterExpanded;

  List<AdvancedFilter> advancedFilters = [
    AdvancedFilter(label: 'EPS'),
    AdvancedFilter(label: 'EBITDA'),
    AdvancedFilter(label: 'Net Income'),
    AdvancedFilter(label: 'PE Ratio'),
    AdvancedFilter(label: 'Shares Diluted'),
  ];

  bool _advancedExpanded = false;
  bool get advancedExpanded => _advancedExpanded;

  final List<String> rankOptions = [
    'EPS',
    'EBITDA',
    'Sharpe Ratio',
    'Price-to-Earnings',
    'Net Income',
  ];

  String? selectedRank;
  bool rankExpanded = false;

  final List<String> distributionOptions = [
    'Top 10',
    'Top 15',
    'Choose Manually',
  ];
  String? selectedDistribution;

  final List<String> weightTypeOptions = [
    'Market Cap',
    'Equal Weight',
    'Custom',
  ];
  String? selectedWeightType;

  bool normalizeWeights = false;
  bool weightingExpanded = false;

  final List<String> rebalanceOptions = ['Daily', 'Weekly', 'Monthly'];
  String? selectedRebalance;
  bool rulesExpanded = false;

  int settlementDays = 0;

  void toggleFilterExpanded() {
    _filterExpanded = !_filterExpanded;
    notifyListeners();
  }

  void setStrategyName(String v) {
    strategyName = v;
    notifyListeners();
  }

  void setStrategyCategory(String? v) {
    strategyCategory = v;
    notifyListeners();
  }

  void setStockUniverse(String? v) {
    stockUniverse = v;
    notifyListeners();
  }

  void setSector(String? v) {
    sector = v;
    notifyListeners();
  }

  void toggleAllSectors(bool? v) {
    allSectors = v ?? false;
    notifyListeners();
  }

  void toggleSmallcap(bool? v) {
    smallcap = v ?? false;
    notifyListeners();
  }

  void toggleMidcap(bool? v) {
    midcap = v ?? false;
    notifyListeners();
  }

  void toggleLargecap(bool? v) {
    largecap = v ?? false;
    notifyListeners();
  }

  void toggleAdvanced() {
    _advancedExpanded = !_advancedExpanded;
    notifyListeners();
  }

  void setAdvancedFrom(int idx, double val) {
    advancedFilters[idx].from = val;
    notifyListeners();
  }

  void setAdvancedTo(int idx, double val) {
    advancedFilters[idx].to = val;
    notifyListeners();
  }

  void addAdvancedFilter(String label) {
    advancedFilters.add(AdvancedFilter(label: label));
    notifyListeners();
  }

  void toggleRank() {
    rankExpanded = !rankExpanded;
    notifyListeners();
  }

  void setRank(String? rank) {
    selectedRank = rank;
    notifyListeners();
  }

  void addRankFilter() {
    notifyListeners();
  }

  void setDistribution(String? v) {
    selectedDistribution = v;
    notifyListeners();
  }

  void setWeightType(String? v) {
    selectedWeightType = v;
    notifyListeners();
  }

  void toggleNormalizeWeights(bool v) {
    normalizeWeights = v;
    notifyListeners();
  }

  void toggleWeighting() {
    weightingExpanded = !weightingExpanded;
    notifyListeners();
  }

  void toggleRules() {
    rulesExpanded = !rulesExpanded;
    notifyListeners();
  }

  void setRebalance(String? v) {
    selectedRebalance = v;
    notifyListeners();
  }

  void setSettlementDays(int days) {
    settlementDays = days;
    notifyListeners();
  }

  void reset() {
    strategyName = '';
    strategyCategory = null;
    stockUniverse = null;
    sector = null;
    allSectors = false;
    smallcap = midcap = largecap = false;
    notifyListeners();
  }

  void apply() {
    // TODO: wire up your API or callback
    print({
      'name': strategyName,
      'category': strategyCategory,
      'universe': stockUniverse,
      'sector': sector,
      'allSectors': allSectors,
      'marketCaps': {'small': smallcap, 'mid': midcap, 'large': largecap},
    });
  }
}

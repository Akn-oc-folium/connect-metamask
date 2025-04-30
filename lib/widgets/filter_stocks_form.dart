// lib/widgets/filter_stocks_form.dart

import 'package:flutter/material.dart' as m;
import 'package:stacked/stacked.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as s;

import '../viewmodels/stock_filter_viewmodel.dart';

class FilterStocksForm extends m.StatelessWidget {
  const FilterStocksForm({super.key});

  @override
  m.Widget build(m.BuildContext context) {
    return ViewModelBuilder<StockFilterViewModel>.reactive(
      viewModelBuilder: () => StockFilterViewModel(),
      builder: (context, vm, child) {
        return m.Column(
          children: [
            // Scrollable body
            m.Expanded(
              child: m.SingleChildScrollView(
                child: m.Column(
                  crossAxisAlignment: m.CrossAxisAlignment.stretch,
                  children: [
                    _StrategyNameField(vm),
                    const m.SizedBox(height: 24),
                    _StrategyCategoryField(vm),
                    const m.SizedBox(height: 24),
                    _FilterStocksPanel(vm),
                    const m.SizedBox(height: 24),
                    _AdvancedFiltersPanel(vm),
                    const m.SizedBox(height: 24),
                    _RankByPanel(vm),
                    const m.SizedBox(height: 24),
                    _WeightingPanel(vm),
                    const m.SizedBox(height: 24),
                    _RulesPanel(vm),
                  ],
                ),
              ),
            ),

            // Fixed actions
            const m.Divider(height: 1),
            _ActionButtons(vm),
          ],
        );
      },
    );
  }
}

/// 1) Strategy Name
class _StrategyNameField extends m.StatelessWidget {
  final StockFilterViewModel vm;
  const _StrategyNameField(this.vm);

  @override
  m.Widget build(m.BuildContext context) {
    return m.Column(
      crossAxisAlignment: m.CrossAxisAlignment.stretch,
      children: [
        const m.Text('Strategy Name'),
        const m.SizedBox(height: 4),
        s.TextField(
          initialValue: vm.strategyName,
          placeholder: const m.Text('Give your strategy a unique name…'),
          onChanged: vm.setStrategyName,
        ),
      ],
    );
  }
}

/// 2) Strategy Category dropdown
class _StrategyCategoryField extends m.StatelessWidget {
  final StockFilterViewModel vm;
  const _StrategyCategoryField(this.vm);

  @override
  m.Widget build(m.BuildContext context) {
    return m.Column(
      crossAxisAlignment: m.CrossAxisAlignment.stretch,
      children: [
        const m.Text('Strategy Category'),
        const m.SizedBox(height: 6),
        m.LayoutBuilder(
          builder: (ctx, bc) {
            final w = bc.maxWidth;
            return m.SizedBox(
              width: w,
              child: s.Select<String>(
                itemBuilder:
                    (c, item) => m.Padding(
                      padding: const m.EdgeInsets.all(8),
                      child: m.Text(item),
                    ),
                popupConstraints: m.BoxConstraints(minWidth: w, maxHeight: 300),
                value: vm.strategyCategory,
                onChanged: vm.setStrategyCategory,
                placeholder: const m.Text('Select an option'),
                popup:
                    s.SelectPopup(
                      items: s.SelectItemList(
                        children:
                            vm.categoryOptions
                                .map(
                                  (e) => s.SelectItemButton(
                                    value: e,
                                    child: m.Text(e),
                                  ),
                                )
                                .toList(),
                      ),
                    ).call,
              ),
            );
          },
        ),
      ],
    );
  }
}

/// 3) “Filter Stocks” expansion panel
class _FilterStocksPanel extends m.StatelessWidget {
  final StockFilterViewModel vm;
  const _FilterStocksPanel(this.vm);

  @override
  m.Widget build(m.BuildContext context) {
    final capMap = {
      'Consider All Sectors': vm.allSectors,
      'Smallcap': vm.smallcap,
      'Midcap': vm.midcap,
      'Largecap': vm.largecap,
    };

    return m.Card(
      elevation: 0,
      clipBehavior: m.Clip.antiAlias,
      shape: m.RoundedRectangleBorder(
        borderRadius: m.BorderRadius.circular(12),
      ),
      color: const m.Color(0xFFF8FAFC),
      child: m.ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: m.EdgeInsets.zero,
        dividerColor: m.Colors.grey.shade200,
        expansionCallback: (_, __) => vm.toggleFilterExpanded(),
        children: [
          m.ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: vm.filterExpanded,
            backgroundColor: m.Colors.transparent,
            headerBuilder:
                (ctx, isOpen) => const m.ListTile(
                  leading: m.Icon(s.BootstrapIcons.sliders2Vertical),
                  title: m.Text(
                    'Filter Stocks',
                    style: m.TextStyle(fontWeight: m.FontWeight.w600),
                  ),
                ),
            body: m.Padding(
              padding: const m.EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: m.Column(
                crossAxisAlignment: m.CrossAxisAlignment.start,
                children: [
                  // Stock Universe
                  _dropdownField(
                    label: 'Stock Universe',
                    value: vm.stockUniverse,
                    options: vm.universeOptions,
                    onChanged: vm.setStockUniverse,
                  ),
                  const m.SizedBox(height: 12),
                  // Sector
                  _dropdownField(
                    label: 'Show by Sector',
                    value: vm.sector,
                    options: vm.sectorOptions,
                    onChanged: vm.setSector,
                  ),
                  // Checkboxes
                  for (final entry in capMap.entries)
                    s.Checkbox(
                      state:
                          entry.value
                              ? s.CheckboxState.checked
                              : s.CheckboxState.unchecked,
                      onChanged:
                          (st) => {
                            // call the correct toggle based on the key
                            if (entry.key == 'Consider All Sectors')
                              vm.toggleAllSectors(st == s.CheckboxState.checked)
                            else if (entry.key == 'Smallcap')
                              vm.toggleSmallcap(st == s.CheckboxState.checked)
                            else if (entry.key == 'Midcap')
                              vm.toggleMidcap(st == s.CheckboxState.checked)
                            else if (entry.key == 'Largecap')
                              vm.toggleLargecap(st == s.CheckboxState.checked),
                          },
                      trailing: m.Text(entry.key),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper for a full-width dropdown inside the panel
  m.Widget _dropdownField({
    required String label,
    required String? value,
    required List<String> options,
    required m.ValueChanged<String?> onChanged,
  }) {
    return m.Column(
      crossAxisAlignment: m.CrossAxisAlignment.start,
      children: [
        m.Text(label),
        const m.SizedBox(height: 6),
        m.LayoutBuilder(
          builder: (ctx, bc) {
            final w = bc.maxWidth;
            return m.SizedBox(
              width: w,
              child: s.Select<String>(
                itemBuilder:
                    (c, item) => m.Padding(
                      padding: const m.EdgeInsets.all(8),
                      child: m.Text(item),
                    ),
                popupConstraints: m.BoxConstraints(minWidth: w, maxHeight: 300),
                value: value,
                onChanged: onChanged,
                placeholder: const m.Text('Select…'),
                popup:
                    s.SelectPopup(
                      items: s.SelectItemList(
                        children:
                            options
                                .map(
                                  (e) => s.SelectItemButton(
                                    value: e,
                                    child: m.Text(e),
                                  ),
                                )
                                .toList(),
                      ),
                    ).call,
              ),
            );
          },
        ),
      ],
    );
  }
}

/// 4) “Advanced Filters” panel
class _AdvancedFiltersPanel extends m.StatelessWidget {
  final StockFilterViewModel vm;
  const _AdvancedFiltersPanel(this.vm);

  @override
  m.Widget build(m.BuildContext context) {
    return m.Card(
      elevation: 0,
      clipBehavior: m.Clip.antiAlias,
      shape: m.RoundedRectangleBorder(
        borderRadius: m.BorderRadius.circular(12),
      ),
      color: const m.Color(0xFFF8FAFC),
      child: m.ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: m.EdgeInsets.zero,
        dividerColor: m.Colors.grey.shade200,
        expansionCallback: (_, __) => vm.toggleAdvanced(),
        children: [
          m.ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: vm.advancedExpanded,
            backgroundColor: m.Colors.transparent,
            headerBuilder:
                (ctx, isOpen) => const m.ListTile(
                  leading: m.Icon(s.BootstrapIcons.sliders2Vertical),
                  title: m.Text(
                    'Advanced Filters',
                    style: m.TextStyle(fontWeight: m.FontWeight.w600),
                  ),
                ),
            body: m.Padding(
              padding: const m.EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: m.Column(
                crossAxisAlignment: m.CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < vm.advancedFilters.length; i++)
                    _advancedRow(i),
                  m.TextButton(
                    onPressed: () => vm.addAdvancedFilter('New Filter'),
                    child: const m.Text(
                      '+ Add Filter',
                      style: m.TextStyle(color: m.Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds one “From – To” numeric row
  m.Widget _advancedRow(int i) {
    final f = vm.advancedFilters[i];
    return m.Padding(
      padding: const m.EdgeInsets.symmetric(vertical: 8),
      child: m.Row(
        children: [
          m.SizedBox(
            width: 100,
            child: m.Text(
              f.label,
              style: const m.TextStyle(fontWeight: m.FontWeight.w600),
            ),
          ),
          const m.SizedBox(width: 12),
          _numberField(
            initial: f.from?.toString() ?? '',
            placeholder: 'From',
            onChanged: (v) => vm.setAdvancedFrom(i, double.tryParse(v) ?? 0),
          ),
          const m.SizedBox(width: 8),
          const m.Text('–'),
          const m.SizedBox(width: 8),
          _numberField(
            initial: f.to?.toString() ?? '',
            placeholder: 'To',
            onChanged: (v) => vm.setAdvancedTo(i, double.tryParse(v) ?? 0),
          ),
        ],
      ),
    );
  }

  m.Widget _numberField({
    required String initial,
    required String placeholder,
    required m.ValueChanged<String> onChanged,
  }) {
    return m.SizedBox(
      width: 100,
      child: s.TextField(
        initialValue: initial,
        placeholder: m.Text(placeholder),
        onChanged: onChanged,
        features: [s.InputFeature.spinner()],
        submitFormatters: [s.TextInputFormatters.mathExpression()],
      ),
    );
  }
}

class _RankByPanel extends m.StatelessWidget {
  final StockFilterViewModel vm;

  const _RankByPanel(this.vm);

  @override
  m.Widget build(m.BuildContext context) {
    // split options into two columns
    final half = (vm.rankOptions.length + 1) ~/ 2;
    final left = vm.rankOptions.sublist(0, half);
    final right = vm.rankOptions.sublist(half);

    return m.Card(
      elevation: 0,
      clipBehavior: m.Clip.antiAlias,
      shape: m.RoundedRectangleBorder(
        borderRadius: m.BorderRadius.circular(12),
      ),
      color: const m.Color(0xFFF8FAFC),
      child: m.ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: m.EdgeInsets.zero,
        dividerColor: m.Colors.grey.shade200,
        expansionCallback: (_, __) => vm.toggleRank(),
        children: [
          m.ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: vm.rankExpanded,
            backgroundColor: m.Colors.transparent,
            headerBuilder:
                (ctx, isOpen) => const m.ListTile(
                  leading: m.Icon(s.BootstrapIcons.sliders2Vertical),
                  title: m.Text(
                    'Rank By',
                    style: m.TextStyle(
                      fontWeight: m.FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
            body: m.Padding(
              padding: const m.EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: m.Column(
                crossAxisAlignment: m.CrossAxisAlignment.start,
                children: [
                  const m.Text(
                    'Market Cap',
                    style: m.TextStyle(fontWeight: m.FontWeight.w600),
                  ),
                  const m.SizedBox(height: 12),

                  m.Row(
                    children: [
                      m.Expanded(child: _buildRadioColumn(left)),
                      const m.SizedBox(width: 24),
                      m.Expanded(child: _buildRadioColumn(right)),
                    ],
                  ),

                  const m.SizedBox(height: 16),
                  m.TextButton(
                    onPressed: vm.addRankFilter,
                    child: const m.Text(
                      '+ Add Filter',
                      style: m.TextStyle(color: m.Colors.blue, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a vertical list of radios
  m.Widget _buildRadioColumn(List<String> opts) {
    return s.RadioGroup<String>(
      value: vm.selectedRank,
      onChanged: vm.setRank,
      child: m.Column(
        crossAxisAlignment: m.CrossAxisAlignment.start,
        children:
            opts.map((opt) {
              return s.RadioItem<String>(
                value: opt,
                trailing: m.Text(
                  opt,
                  style: const m.TextStyle(fontWeight: m.FontWeight.w600),
                ),
              );
            }).toList(),
      ),
    );
  }
}

/// ─── Weighting Panel ─────────────────────────────
class _WeightingPanel extends m.StatelessWidget {
  final StockFilterViewModel vm;
  const _WeightingPanel(this.vm);

  @override
  m.Widget build(m.BuildContext context) {
    return m.Card(
      elevation: 0,
      clipBehavior: m.Clip.antiAlias,
      shape: m.RoundedRectangleBorder(
        borderRadius: m.BorderRadius.circular(12),
      ),
      color: const m.Color(0xFFF8FAFC),
      child: m.ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: m.EdgeInsets.zero,
        dividerColor: m.Colors.grey.shade200,
        expansionCallback: (_, __) => vm.toggleWeighting(),
        children: [
          m.ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: vm.weightingExpanded,
            backgroundColor: m.Colors.transparent,
            headerBuilder:
                (ctx, open) => const m.ListTile(
                  leading: m.Icon(s.BootstrapIcons.sliders2Vertical),
                  title: m.Text(
                    'Weighting',
                    style: m.TextStyle(
                      fontWeight: m.FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),

            // insert a Divider right under the header
            body: m.Column(
              mainAxisSize: m.MainAxisSize.min,
              children: [
                m.Divider(
                  height: 1,
                  thickness: 1,
                  color: m.Colors.grey.shade200,
                ),

                m.Padding(
                  padding: const m.EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: m.Column(
                    crossAxisAlignment: m.CrossAxisAlignment.start,
                    children: [
                      // 1) Distribution label
                      const m.Text(
                        'Distribution',
                        style: m.TextStyle(fontWeight: m.FontWeight.w600),
                      ),
                      const m.SizedBox(height: 12),

                      // 2) Radios in two columns
                      m.Row(
                        children: [
                          m.Expanded(
                            child: _radioColumn(vm.distributionOptions),
                          ),
                          const m.SizedBox(width: 24),
                          // if odd count puts remainder on right
                          m.Expanded(
                            child: _radioColumn(
                              vm.distributionOptions.sublist(
                                (vm.distributionOptions.length + 1) ~/ 2,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const m.SizedBox(height: 24),
                      // 3) Weight Type dropdown
                      const m.Text('Choose Weight Type'),
                      const m.SizedBox(height: 6),
                      s.Select<String>(
                        itemBuilder:
                            (c, item) => m.Padding(
                              padding: const m.EdgeInsets.all(8),
                              child: m.Text(item),
                            ),
                        popupConstraints: const m.BoxConstraints(
                          maxHeight: 300,
                        ),
                        value: vm.selectedWeightType,
                        onChanged: vm.setWeightType,
                        placeholder: const m.Text('Choose Weight Type'),
                        popup:
                            s.SelectPopup(
                              items: s.SelectItemList(
                                children:
                                    vm.weightTypeOptions
                                        .map(
                                          (e) => s.SelectItemButton(
                                            value: e,
                                            child: m.Text(e),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ).call,
                      ),

                      const m.SizedBox(height: 24),
                      // 4) Normalize toggle
                      m.Row(
                        children: [
                          m.Switch(
                            value: vm.normalizeWeights,
                            onChanged: vm.toggleNormalizeWeights,
                          ),
                          const m.SizedBox(width: 12),
                          const m.Text('Normalize weights'),
                        ],
                      ),

                      const m.SizedBox(height: 8),
                      // 5) Add Filter stub
                      m.TextButton(
                        onPressed: vm.addRankFilter, // or create a new method
                        child: const m.Text(
                          '+ Add Filter',
                          style: m.TextStyle(
                            color: m.Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a sub-column of radio items from a list of labels.
  m.Widget _radioColumn(List<String> opts) {
    return s.RadioGroup<String>(
      value: vm.selectedDistribution,
      onChanged: vm.setDistribution,
      child: m.Column(
        crossAxisAlignment: m.CrossAxisAlignment.start,
        children:
            opts.map((opt) {
              return s.RadioItem<String>(value: opt, trailing: m.Text(opt));
            }).toList(),
      ),
    );
  }
}

/// ─── Rules Panel ─────────────────────────────────
class _RulesPanel extends m.StatelessWidget {
  final StockFilterViewModel vm;
  const _RulesPanel(this.vm);

  @override
  m.Widget build(m.BuildContext context) {
    // split into two roughly equal columns
    final half = (vm.rebalanceOptions.length + 1) ~/ 2;
    final left = vm.rebalanceOptions.sublist(0, half);
    final right = vm.rebalanceOptions.sublist(half);

    return m.Card(
      elevation: 0,
      clipBehavior: m.Clip.antiAlias,
      shape: m.RoundedRectangleBorder(
        borderRadius: m.BorderRadius.circular(12),
      ),
      color: const m.Color(0xFFF8FAFC),
      child: m.ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: m.EdgeInsets.zero,
        dividerColor: m.Colors.grey.shade200,
        expansionCallback: (_, __) => vm.toggleRules(),
        children: [
          m.ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: vm.rulesExpanded,
            backgroundColor: m.Colors.transparent,
            headerBuilder:
                (ctx, open) => const m.ListTile(
                  leading: m.Icon(s.BootstrapIcons.sliders2Vertical),
                  title: m.Text(
                    'Rules',
                    style: m.TextStyle(
                      fontWeight: m.FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
            body: m.Column(
              mainAxisSize: m.MainAxisSize.min,
              children: [
                // line under header
                m.Divider(
                  height: 1,
                  thickness: 1,
                  color: m.Colors.grey.shade200,
                ),
                // panel contents
                m.Padding(
                  padding: const m.EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: m.Column(
                    crossAxisAlignment: m.CrossAxisAlignment.start,
                    children: [
                      // 1) Rebalance Frequency
                      const m.Text(
                        'Rebalance Frequency',
                        style: m.TextStyle(fontWeight: m.FontWeight.w600),
                      ),
                      const m.SizedBox(height: 12),

                      m.Row(
                        children: [
                          m.Expanded(child: _radioColumn(left)),
                          const m.SizedBox(width: 24),
                          m.Expanded(child: _radioColumn(right)),
                        ],
                      ),

                      const m.SizedBox(height: 24),

                      // 2) Settlement Days
                      const m.Text('Settlement Days'),
                      const m.SizedBox(height: 8),
                      m.SizedBox(
                        width: 100,
                        child: s.TextField(
                          initialValue: vm.settlementDays.toString(),
                          onChanged: (str) {
                            final v = int.tryParse(str) ?? 0;
                            vm.setSettlementDays(v);
                          },
                          features: const [s.InputFeature.spinner()],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  m.Widget _radioColumn(List<String> opts) {
    return s.RadioGroup<String>(
      value: vm.selectedRebalance,
      onChanged: vm.setRebalance,
      child: m.Column(
        crossAxisAlignment: m.CrossAxisAlignment.start,
        children:
            opts.map((opt) {
              return s.RadioItem<String>(value: opt, trailing: m.Text(opt));
            }).toList(),
      ),
    );
  }
}

/// 5) Bottom row of action buttons
class _ActionButtons extends m.StatelessWidget {
  final StockFilterViewModel vm;
  const _ActionButtons(this.vm);

  @override
  m.Widget build(m.BuildContext context) {
    return m.Padding(
      padding: const m.EdgeInsets.all(16),
      child: m.Row(
        mainAxisAlignment: m.MainAxisAlignment.spaceBetween,
        children: [
          s.OutlineButton(
            onPressed: vm.reset,
            child: const m.Text('Reset Filters'),
          ),
          s.OutlineButton(
            onPressed: vm.apply,
            child: const m.Text('Show Results'),
          ),
        ],
      ),
    );
  }
}

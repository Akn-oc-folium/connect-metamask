import 'package:stacked/stacked.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../models/table_model.dart';

class SearchableTableViewModel extends BaseViewModel {
  final List<ColumnConfig> columns;
  final List<Map<String, dynamic>> rows;
  final int rowsPerPage;
  final int maxPages;
  final ResizableTableController controller;

  String _search = '';
  int _page = 1;

  SearchableTableViewModel({
    required this.columns,
    required this.rows,
    this.rowsPerPage = 10,
    this.maxPages = 3,
    ResizableTableController? controller,
  }) : controller =
           controller ??
           ResizableTableController(
             defaultColumnWidth: 150,
             defaultRowHeight: 50,
             defaultHeightConstraint: const ConstrainedTableSize(
               min: 50,
               max: 50,
             ),
             defaultWidthConstraint: const ConstrainedTableSize(min: 80),
           );

  String get search => _search;
  int get page => _page;

  List<Map<String, dynamic>> get filtered {
    if (_search.isEmpty) return rows;
    final q = _search.toLowerCase();
    return rows.where((r) {
      return columns.any((c) {
        final v = r[c.field]?.toString().toLowerCase() ?? '';
        return v.contains(q);
      });
    }).toList();
  }

  int get totalPages =>
      (filtered.length / rowsPerPage).ceil().clamp(1, double.infinity).toInt();

  List<Map<String, dynamic>> get paged {
    final start = (page - 1) * rowsPerPage;
    return filtered.skip(start).take(rowsPerPage).toList();
  }

  void setSearch(String v) {
    _search = v;
    _page = 1;
    notifyListeners();
  }

  void goToPage(int p) {
    _page = p.clamp(1, totalPages);
    notifyListeners();
  }

  void prevPage() => goToPage(page - 1);
  void nextPage() => goToPage(page + 1);

  void save() {
    // TODO: implement export/save logic
  }
}

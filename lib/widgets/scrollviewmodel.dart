import 'package:stacked/stacked.dart';
import '../models/table_model.dart';

class SearchableTableViewModel extends BaseViewModel {
  final List<ColumnConfig> columns;
  final List<TableRowModel> _allRows;
  final int rowsPerPage;
  final int maxPages;

  String _search = '';
  int _page = 1;

  SearchableTableViewModel({
    required this.columns,
    required List<Map<String, dynamic>> rows,
    this.rowsPerPage = 10,
    this.maxPages = 3,
  }) : _allRows = rows.map((r) => TableRowModel(r)).toList();

  String get search => _search;

  List<TableRowModel> get filtered {
    if (_search.isEmpty) return _allRows;
    final q = _search.toLowerCase();
    return _allRows.where((row) {
      return columns.any((col) {
        final cell = row.data[col.field];
        return cell != null && cell.toString().toLowerCase().contains(q);
      });
    }).toList();
  }

  List<TableRowModel> get paged {
    final start = (_page - 1) * rowsPerPage;
    return filtered.skip(start).take(rowsPerPage).toList();
  }

  int get page => _page;

  int get totalPages {
    final t = (filtered.length / rowsPerPage).ceil();
    return t < 1 ? 1 : t;
  }

  void setSearch(String v) {
    _search = v;
    _page = 1;
    notifyListeners();
  }

  void goToPage(int p) {
    _page = p < 1 ? 1 : (p > totalPages ? totalPages : p);
    notifyListeners();
  }

  void save() {
    // TODO: wire up your save/export
  }
}

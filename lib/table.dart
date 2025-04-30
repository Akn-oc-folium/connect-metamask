import 'package:flutter/material.dart';

/// Type alias for building custom cell widgets.
typedef CellBuilder = Widget Function(dynamic value);

/// Defines a column with a header title, JSON field key, optional cell builder,
/// whether the column supports sorting, and an optional fixed width.
class ColumnConfig {
  final String title;
  final String field;
  final CellBuilder? cellBuilder;
  final bool sortable;
  final double? width;

  const ColumnConfig({
    required this.title,
    required this.field,
    this.cellBuilder,
    this.sortable = false,
    this.width,
  });
}

/// A generic, horizontally scrollable, paginated, and sortable table powered by JSON data.
class GenericPaginatedTable extends StatefulWidget {
  /// Column definitions (title, JSON key, optional builder, sortable flag, width).
  final List<ColumnConfig> columns;

  /// List of JSON maps representing each row.
  final List<Map<String, dynamic>> rows;

  /// Number of rows per page.
  final int rowsPerPage;

  /// Optional styling for header text.
  final TextStyle? headerStyle;

  const GenericPaginatedTable({
    Key? key,
    required this.columns,
    required this.rows,
    this.rowsPerPage = 10,
    this.headerStyle,
  }) : super(key: key);

  @override
  _GenericPaginatedTableState createState() => _GenericPaginatedTableState();
}

class _GenericPaginatedTableState extends State<GenericPaginatedTable> {
  late List<Map<String, dynamic>> _allRows;
  int _currentPage = 1;
  int? _sortColumnIndex;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    // Copy rows so we can reset sorting
    _allRows = List.from(widget.rows);
  }

  int get totalPages =>
      (_allRows.length / widget.rowsPerPage)
          .ceil()
          .clamp(1, double.infinity)
          .toInt();

  List<Map<String, dynamic>> get pagedRows {
    final start = (_currentPage - 1) * widget.rowsPerPage;
    final end = (start + widget.rowsPerPage).clamp(0, _allRows.length);
    return _allRows.sublist(start, end);
  }

  /// Clears sort state and resets original order.
  void _clearSort() {
    setState(() {
      _sortColumnIndex = null;
      _sortAscending = true;
      _allRows = List.from(widget.rows);
      _currentPage = 1;
    });
  }

  /// Applies sorting on a specific column.
  void _applySort(int columnIndex, bool ascending) {
    final field = widget.columns[columnIndex].field;
    _allRows.sort((a, b) {
      final v1 = a[field];
      final v2 = b[field];
      if (v1 is Comparable && v2 is Comparable) {
        return ascending ? v1.compareTo(v2) : v2.compareTo(v1);
      }
      return 0;
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      _currentPage = 1;
    });
  }

  /// Cycles through no-sort → asc → desc → no-sort states.
  void _toggleSort(int columnIndex) {
    if (_sortColumnIndex != columnIndex) {
      _applySort(columnIndex, true);
    } else if (_sortAscending) {
      _applySort(columnIndex, false);
    } else {
      _clearSort();
    }
  }

  void _goTo(int page) {
    setState(() {
      _currentPage = page.clamp(1, totalPages);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ClipRect(
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                ),
                child: DataTableTheme(
                  data: DataTableThemeData(
                    headingRowColor: MaterialStateProperty.all(
                      Colors.grey.shade200,
                    ),
                    dataRowColor: MaterialStateProperty.all(Colors.white),
                    dividerThickness: 1,
                    horizontalMargin: 24,
                    columnSpacing: 24,
                  ),
                  child: DataTable(
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    headingTextStyle:
                        widget.headerStyle ??
                        const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                    columns: List.generate(widget.columns.length, (index) {
                      final col = widget.columns[index];
                      return DataColumn(
                        label:
                            col.width != null
                                ? SizedBox(
                                  width: col.width,
                                  child: Text(
                                    col.title,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                                : Text(col.title),
                        onSort:
                            col.sortable ? (_, __) => _toggleSort(index) : null,
                      );
                    }),
                    rows:
                        pagedRows.map((jsonRow) {
                          return DataRow(
                            cells:
                                widget.columns.map((col) {
                                  final value = jsonRow[col.field];
                                  Widget content =
                                      col.cellBuilder?.call(value) ??
                                      Text(
                                        value?.toString() ?? '',
                                        overflow:
                                            col.width != null
                                                ? TextOverflow.ellipsis
                                                : TextOverflow.visible,
                                      );
                                  if (col.width != null) {
                                    content = SizedBox(
                                      width: col.width,
                                      child: content,
                                    );
                                  }
                                  return DataCell(content);
                                }).toList(),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
            // Divider above pagination
            const Divider(height: 1, thickness: 1),
            // Pagination Controls
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed:
                        _currentPage > 1 ? () => _goTo(_currentPage - 1) : null,
                    child: const Text('Previous'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Page $_currentPage of $totalPages'),
                  ),
                  TextButton(
                    onPressed:
                        _currentPage < totalPages
                            ? () => _goTo(_currentPage + 1)
                            : null,
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

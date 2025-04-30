/// Defines a column header configuration.
class ColumnConfig {
  final String title;
  final String field;
  final bool alignRight;
  const ColumnConfig({
    required this.title,
    required this.field,
    this.alignRight = false,
  });
}

class TableRowModel {
  final Map<String, dynamic> data;

  const TableRowModel(this.data);
}

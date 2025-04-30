import 'package:stacked/stacked.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../models/table_model.dart';
import 'searchable_table_viewmodel.dart';

class SearchableTableView extends StatelessWidget {
  final List<ColumnConfig> columns;
  final List<Map<String, dynamic>> rows;
  final int rowsPerPage;
  final int maxPages;

  const SearchableTableView({
    super.key,
    required this.columns,
    required this.rows,
    this.rowsPerPage = 10,
    this.maxPages = 3,
  });

  TableCell _buildCell(BuildContext context, String text, bool alignRight) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchableTableViewModel>.reactive(
      viewModelBuilder:
          () => SearchableTableViewModel(
            columns: columns,
            rows: rows,
            rowsPerPage: rowsPerPage,
            maxPages: maxPages,
          ),
      builder: (context, vm, child) {
        return SizedBox(
          width: 855,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.outline(
                    onPressed: vm.save,
                    density: ButtonDensity.icon,
                    icon: const Icon(Icons.save),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 308,
                    child: TextField(
                      placeholder: const Text('Search something...'),
                      features: [
                        InputFeature.leading(
                          StatedWidget.builder(
                            builder: (context, states) {
                              if (states.hovered) {
                                return const Icon(Icons.search);
                              } else {
                                return const Icon(
                                  Icons.search,
                                ).iconMutedForeground();
                              }
                            },
                          ),
                          visibility: InputFeatureVisibility.textEmpty,
                        ),
                        InputFeature.clear(
                          visibility:
                              (InputFeatureVisibility.textNotEmpty &
                                  InputFeatureVisibility.focused) |
                              InputFeatureVisibility.hovered,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Expanded(
                child: OutlinedContainer(
                  width: 855,
                  height: 652,
                  child: ResizableTable(
                    controller: vm.controller,
                    rows: [
                      TableHeader(
                        cells:
                            columns
                                .map(
                                  (c) => _buildCell(
                                    context,
                                    c.title,
                                    c.alignRight,
                                  ),
                                )
                                .toList(),
                      ),
                      ...vm.paged.map((r) {
                        return TableRow(
                          cells: List.generate(columns.length, (i) {
                            final c = columns[i];
                            final text = r[c.field]?.toString() ?? '';
                            if (i == columns.length - 1) {
                              return TableCell(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  alignment: Alignment.center,
                                  child: Chip(
                                    style: ButtonStyle.primary(),
                                    child: Text(text),
                                  ),
                                ),
                              );
                            }
                            return _buildCell(context, text, c.alignRight);
                          }),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Pagination(
                page: vm.page,
                totalPages: vm.totalPages,
                maxPages: vm.maxPages,
                onPageChanged: vm.goToPage,
              ),
            ],
          ),
        );
      },
    );
  }
}

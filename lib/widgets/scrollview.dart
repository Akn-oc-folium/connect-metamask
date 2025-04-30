// import 'dart:ui';
// import 'package:stacked/stacked.dart';
// import 'package:shadcn_flutter/shadcn_flutter.dart';
// import 'package:web3_flutter/widgets/searchable_table_viewmodel.dart';

// import '../models/table_model.dart';

// class SearchableTableView extends StatelessWidget {
//   final List<ColumnConfig> columns;
//   final List<Map<String, dynamic>> rows;
//   final int rowsPerPage;
//   final int maxPages;

//   const SearchableTableView({
//     super.key,
//     required this.columns,
//     required this.rows,
//     this.rowsPerPage = 10,
//     this.maxPages = 3,
//   });

//   TableCell _buildCell(
//     BuildContext context,
//     String text, [
//     bool alignRight = false,
//   ]) {
//     return TableCell(
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
//         child: Text(text),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<SearchableTableViewModel>.reactive(
//       viewModelBuilder:
//           () => SearchableTableViewModel(
//             columns: columns,
//             rows: rows,
//             rowsPerPage: rowsPerPage,
//             maxPages: maxPages,
//           ),
//       builder: (context, vm, child) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Search + Save
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     initialValue: 'Hello World!',
//                     placeholder: const Text('Search something...'),
//                     features: [
//                       InputFeature.leading(
//                         StatedWidget.builder(
//                           builder: (context, states) {
//                             if (states.hovered) {
//                               return const Icon(Icons.search);
//                             } else {
//                               return const Icon(
//                                 Icons.search,
//                               ).iconMutedForeground();
//                             }
//                           },
//                         ),
//                         visibility: InputFeatureVisibility.textEmpty,
//                       ),
//                       InputFeature.clear(
//                         visibility:
//                             (InputFeatureVisibility.textNotEmpty &
//                                 InputFeatureVisibility.focused) |
//                             InputFeatureVisibility.hovered,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 IconButton.outline(
//                   onPressed: vm.save,
//                   density: ButtonDensity.icon,
//                   icon: const Icon(Icons.save),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),

//             // Scrollable table area
//             SizedBox(
//               height: 400,
//               child: ScrollConfiguration(
//                 behavior: ScrollConfiguration.of(context).copyWith(
//                   dragDevices: {
//                     PointerDeviceKind.touch,
//                     PointerDeviceKind.mouse,
//                   },
//                   overscroll: false,
//                 ),
//                 child: OutlinedContainer(
//                   child: ScrollableClient(
//                     diagonalDragBehavior: DiagonalDragBehavior.free,
//                     builder: (ctx, offset, viewportSize, child) {
//                       return Table(
//                         horizontalOffset: offset.dx,
//                         verticalOffset: offset.dy,
//                         viewportSize: viewportSize,
//                         defaultColumnWidth: const FixedTableSize(150),
//                         defaultRowHeight: const FixedTableSize(40),
//                         frozenCells: const FrozenTableData(
//                           frozenRows: [TableRef(0)],
//                           frozenColumns: [TableRef(0)],
//                         ),
//                         rows: [
//                           // Header row
//                           TableHeader(
//                             cells:
//                                 columns
//                                     .map(
//                                       (c) => _buildCell(
//                                         ctx,
//                                         c.title,
//                                         c.alignRight,
//                                       ),
//                                     )
//                                     .toList(),
//                           ),
//                           // Data rows
//                           ...vm.paged.map(
//                             (r) => TableRow(
//                               cells:
//                                   columns
//                                       .map(
//                                         (c) => _buildCell(
//                                           ctx,
//                                           r.data[c.field]?.toString() ?? '',
//                                           c.alignRight,
//                                         ),
//                                       )
//                                       .toList(),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),

//             // Pagination
//             Pagination(
//               page: vm.page,
//               totalPages: vm.totalPages,
//               maxPages: vm.maxPages,
//               onPageChanged: vm.goToPage,
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

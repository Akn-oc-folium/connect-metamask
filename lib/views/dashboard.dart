import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/table_model.dart';
import '../widgets/searchable_table_view.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock API data
    const sampleJson = '''[
      {
    "name": "HDFC Bank",
    "sector": "Financial Services",
    "marketCap": "₹57.887 T",
    "price": "₹17,686",
    "category": "Classified"
  },
  {
    "name": "Reliance Industries",
    "sector": "Communications",
    "marketCap": "₹47.887 T",
    "price": "₹12,23",
    "category": "Classified"
  },
  {
    "name": "Reliance Industries",
    "sector": "Communications",
    "marketCap": "₹47.887 T",
    "price": "₹12,23",
    "category": "Classified"
  },
  {
    "name": "Reliance Industries",
    "sector": "Communications",
    "marketCap": "₹47.887 T",
    "price": "₹12,23",
    "category": "Classified"
  },
  {
    "name": "Reliance Industries",
    "sector": "Communications",
    "marketCap": "₹47.887 T",
    "price": "₹12,23",
    "category": "Classified"
  },
  {
    "name": "Reliance Industries",
    "sector": "Communications",
    "marketCap": "₹47.887 T",
    "price": "₹12,23",
    "category": "Classified"
  },
  {
    "name": "HDFC Bank",
    "sector": "Financial Services",
    "marketCap": "₹57.887 T",
    "price": "₹17,686",
    "category": "Classified"
  },
  {
    "name": "Reliance Industries",
    "sector": "Communications",
    "marketCap": "₹47.887 T",
    "price": "₹12,23",
    "category": "Classified"
  },
  {
    "name": "Reliance Industries",
    "sector": "Communications",
    "marketCap": "₹47.887 T",
    "price": "₹12,23",
    "category": "Classified"
  },
  {
    "name": "Reliance Industries",
    "sector": "Communications",
    "marketCap": "₹47.887 T",
    "price": "₹12,23",
    "category": "Classified"
  },
  {
    "name": "Reliance Industries",
    "sector": "Communications",
    "marketCap": "₹47.887 T",
    "price": "₹12,23",
    "category": "Classified"
  },
  {
    "name": "Reliance Industries",
    "sector": "Communications",
    "marketCap": "₹47.887 T",
    "price": "₹12,23",
    "category": "Classified"
  },
  {
    "name": "HDFC Bank",
    "sector": "Financial Services",
    "marketCap": "₹57.887 T",
    "price": "₹17,686",
    "category": "Classified"
  },
  {
    "name": "Reliance Industries",
    "sector": "Communications",
    "marketCap": "₹47.887 T",
    "price": "₹12,23",
    "category": "Classified"
  },
  {
    "name": "Reliance Industries",
    "sector": "Communications",
    "marketCap": "₹47.887 T",
    "price": "₹12,23",
    "category": "Classified"
  },
  {
    "name": "Reliance Industries",
    "sector": "Communications",
    "marketCap": "₹47.887 T",
    "price": "₹12,23",
    "category": "Classified"
  },
  {
    "name": "Reliance Industries",
    "sector": "Communications",
    "marketCap": "₹47.887 T",
    "price": "₹12,23",
    "category": "Classified"
  },
  {
    "name": "Reliance Industries",
    "sector": "Communications",
    "marketCap": "₹47.887 T",
    "price": "₹12,23",
    "category": "Classified"
  }
    ]''';

    final rows = List<Map<String, dynamic>>.from(jsonDecode(sampleJson));
    final cols = <ColumnConfig>[
      const ColumnConfig(title: 'Name', field: 'name'),
      const ColumnConfig(title: 'Sector', field: 'sector'),
      const ColumnConfig(
        title: 'Market Cap',
        field: 'marketCap',
        alignRight: true,
      ),
      const ColumnConfig(title: 'Price', field: 'price', alignRight: true),
      const ColumnConfig(title: 'Category', field: 'category'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SearchableTableView(
        columns: cols,
        rows: rows,
        rowsPerPage: 10,
        maxPages: 3,
      ),
    );
  }
}

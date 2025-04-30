import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web3_flutter/table.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample JSON string (could come from network/local asset)
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

    Widget categoryBadge(dynamic v) => Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        v.toString(),
        style: TextStyle(color: Colors.green, fontSize: 12),
      ),
    );

    // Decode JSON into list of maps
    final rows = List<Map<String, dynamic>>.from(jsonDecode(sampleJson));

    // Define your columns
    final cols = [
      ColumnConfig(title: 'Name', field: 'name', sortable: true),
      ColumnConfig(title: 'Sector', field: 'sector', sortable: true),
      ColumnConfig(title: 'Market Cap', field: 'marketCap', sortable: true),
      ColumnConfig(title: 'Price', field: 'price', sortable: true),
      ColumnConfig(
        title: 'Category',
        field: 'category',
        cellBuilder: (v) => categoryBadge(v),
      ),
    ];

    return MaterialApp(
      title: 'Generic Table Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Finance Table Example')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GenericPaginatedTable(
            columns: cols,
            rows: rows,
            rowsPerPage: 10,
          ),
        ),
      ),
    );
  }
}

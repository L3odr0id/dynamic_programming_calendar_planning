import 'package:flutter/material.dart';
import 'package:ultimate_calc/calc_page/calculated_table.dart';
import 'package:ultimate_calc/core/calculation.dart';

class TablesList extends StatelessWidget {
  final List<CalculatedTable> tables;
  final DateTime start;
  const TablesList({
    Key? key,
    required this.tables,
    required this.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: tables.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 8, left: 16, right: 16),
                child: CalculatedTableWidget(
                  table: tables[index],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ultimate_calc/calc_page/tables_list.dart';
import 'package:ultimate_calc/core/calculation.dart';

class CalcPage extends StatelessWidget {
  final CalcDTO tablesInfo;
  const CalcPage({
    Key? key,
    required this.tablesInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final time = DateTime.now();
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: CalculationResult.calcMe(tablesInfo),
          builder: (context, AsyncSnapshot<CalculationResult> snapshot) {
            if (snapshot.hasData) {
              return TablesList(
                tables: snapshot.data!.tables,
                start: time,
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

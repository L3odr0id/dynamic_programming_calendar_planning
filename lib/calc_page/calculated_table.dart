import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ultimate_calc/core/calculation.dart';

class CalculatedTableWidget extends StatelessWidget {
  final CalculatedTable table;
  const CalculatedTableWidget({
    Key? key,
    required this.table,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Build Table ${table.logicalStep}');
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: CTcellW.defHeight * (table.cells.length + 3),
        width: CTcellW.defWidth * (table.cells.length + 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'step'.tr() +
                  ' ${table.logicalStep}. ' +
                  'req'.tr() +
                  ' ${table.currentReq}',
            ),
            Row(
              children: [
                CTcellW(
                  text: 'X${table.logicalStep - 1}',
                  height: 2,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CTcellW(
                      text: 'X${table.logicalStep}',
                      width: table.cells.length,
                    ),
                    SizedBox(
                      height: CTcellW.defHeight,
                      width: CTcellW.defWidth * table.cells.length,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: table.cells.length,
                        itemBuilder: (context, colIndex) {
                          return CTcellW(
                            text: (table.dto.minRequirement + colIndex)
                                .toString(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const CTcellW(
                  text: 'Fmin',
                  height: 2,
                ),
              ],
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: table.cells.length,
                itemBuilder: (context, rowIndex) {
                  return SizedBox(
                    height: CTcellW.defHeight,
                    width: CTcellW.defWidth * (table.cells.length + 2),
                    child: Row(
                      children: [
                        CTcellW(
                          text:
                              (table.dto.minRequirement + rowIndex).toString(),
                        ),
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: table.cells.length,
                            itemBuilder: (context, colIndex) {
                              return CTcellW(
                                text: table.cells
                                    .elementAt(rowIndex)
                                    .elementAt(colIndex)
                                    .toString(),
                                bg: cellColor(
                                  table.cells
                                      .elementAt(rowIndex)
                                      .elementAt(colIndex),
                                  table.findMinForRow(rowIndex).value,
                                  table.globalMin.value,
                                ),
                              );
                            },
                          ),
                        ),
                        CTcellW(
                          text:
                              (table.findMinForRow(rowIndex).value).toString(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Text('data4'),
          ],
        ),
      ),
    );
  }

  Color cellColor(int value, int localmin, int globalmin) {
    if (value == globalmin) {
      return Colors.lightGreen;
    }
    if (value > localmin) {
      return Colors.white;
    }
    return Colors.orange;
  }
}

class CTcellW extends StatelessWidget {
  final String text;
  final int width;
  final int height;
  final Color bg;
  const CTcellW({
    Key? key,
    required this.text,
    this.height = 1,
    this.width = 1,
    this.bg = Colors.white,
  }) : super(key: key);

  static const defHeight = 22.0;
  static const defWidth = 80.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: defHeight * height,
      width: defWidth * width,
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: Colors.black),
      ),
    );
  }
}

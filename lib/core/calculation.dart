import 'package:ultimate_calc/core/bellman_equation.dart';
import 'package:ultimate_calc/core/path.dart';

class CalcDTO {
  final Iterable<int> requirements;

  final int overtimePay;
  final int downtimePay;

  final int hireCost;
  final int fireCost;

  int get minRequirement {
    int min = requirements.first;
    for (var i in requirements) {
      if (i < min) {
        min = i;
      }
    }
    return min;
  }

  int get maxRequirement {
    int max = requirements.first;
    for (var i in requirements) {
      if (i > max) {
        max = i;
      }
    }
    return max;
  }

  const CalcDTO({
    required this.requirements,
    required this.overtimePay,
    required this.downtimePay,
    required this.fireCost,
    required this.hireCost,
  });
}

class CalculatedTable {
  /// list of rows. Top level - rows, sublevel - columns in a row
  /// Xreq = _
  /// Xprev   xNext   Fmin
  ///       min - max
  /// min
  ///  |
  /// max
  final Iterable<Iterable<int>> cells;
  final int currentReq;
  final int logicalStep;
  final CalcDTO dto;
  final List<PathPart> mins = [];
  late final PathPart globalMin;

  int sumFor(int externalColIndex) {
    return findMinForRow(externalColIndex).value;
  }

  PathPart findMinForRow(int rowIndex) {
    return mins[rowIndex];
  }

  static int genCell({
    required int colIndex,
    required int rowIndex,
    required CalcDTO dto,
    required int currentReq,
    required CalculatedTable? prevTable,
  }) {
    return BellmanEquation(
      nextStepValue: calcNext(colIndex, dto),
      currentStepValue: calcCurrent(rowIndex, dto),
      requiredValue: currentReq,
      sumForNextStep: prevTable != null ? prevTable.sumFor(colIndex) : 0,
      overtimePay: dto.overtimePay,
      downtimePay: dto.downtimePay,
      fireCost: dto.fireCost,
      hireCost: dto.hireCost,
    ).result;
  }

  static Iterable<int> genCollsInRow({
    required int rowIndex,
    required CalcDTO dto,
    required int currentReq,
    required CalculatedTable? prevTable,
  }) {
    return Iterable.generate(
      dto.maxRequirement - dto.minRequirement + 1,
      (int colIndex) => genCell(
        colIndex: colIndex,
        rowIndex: rowIndex,
        dto: dto,
        currentReq: currentReq,
        prevTable: prevTable,
      ),
    );
  }

  static int calcCurrent(int rowIndex, CalcDTO dto) {
    return rowIndex + dto.minRequirement;
  }

  static int calcNext(int colIndex, CalcDTO dto) {
    return colIndex + dto.minRequirement;
  }

  //
  CalculatedTable({
    required this.dto,
    required CalculatedTable? prevTable,
    required this.currentReq,
    required this.logicalStep,
  }) : cells = Iterable.generate(
          dto.maxRequirement - dto.minRequirement + 1,
          (int rowIndex) => genCollsInRow(
            rowIndex: rowIndex,
            dto: dto,
            currentReq: currentReq,
            prevTable: prevTable,
          ),
        ) {
    PathPart _gm = PathPart(
      value: cells.first.first,
      step: logicalStep,
      colIndex: 0,
      rowIndex: 0,
    );
    for (int i = 0; i < cells.length; ++i) {
      PathPart min = PathPart(
        value: cells.elementAt(i).first,
        step: logicalStep,
        colIndex: 0,
        rowIndex: i,
      );
      for (int j = 0; j < cells.length; ++j) {
        if (cells.elementAt(i).elementAt(j) < min.value) {
          min = PathPart(
            value: cells.elementAt(i).elementAt(j),
            step: logicalStep,
            colIndex: j,
            rowIndex: i,
          );
          if (min.value < _gm.value) {
            _gm = min;
          }
        }
      }
      mins.add(min);
    }
    if (prevTable == null) {
      globalMin = _gm;
    } else {
      globalMin = prevTable.findMinForRow(prevTable.globalMin.rowIndex);
    }
  }
}

class CalculationResult {
  CalculationResult._({required this.tables});

  final List<CalculatedTable> tables;

  static Future<CalculationResult> calcMe(CalcDTO tablesDTO) async {
    final tables = <CalculatedTable>[];

    for (int i = 0; i < tablesDTO.requirements.length; ++i) {
      final int logicalStep = tablesDTO.requirements.length - i;
      tables.add(
        CalculatedTable(
          dto: tablesDTO,
          // if not last table, give previous
          prevTable: i == 0 ? null : tables[i - 1],
          // get reversed of requirements
          currentReq: tablesDTO.requirements.elementAt(logicalStep - 1),
          logicalStep: logicalStep,
        ),
      );
    }

    print(tablesDTO.minRequirement);
    print(tablesDTO.maxRequirement);
    return CalculationResult._(tables: tables);
  }
}

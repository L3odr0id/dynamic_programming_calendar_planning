class OptimaPath {}

class PathPart {
  final int colIndex;
  final int rowIndex;
  final int step;
  final int value;

  const PathPart({
    required this.colIndex,
    required this.rowIndex,
    required this.step,
    required this.value,
  });
}

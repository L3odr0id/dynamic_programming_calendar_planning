class Tables {
  final Iterable<int> requirements;

  final int overtimePay;
  final int downtimePay;

  final int hireCost;
  final int fireCost;

  const Tables({
    required this.requirements,
    required this.overtimePay,
    required this.downtimePay,
    required this.fireCost,
    required this.hireCost,
  });
}

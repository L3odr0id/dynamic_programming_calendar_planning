class BellmanEquation {
  final int nextStepValue;
  final int currentStepValue;
  final int requiredValue;
  final int sumForNextStep;

  final int overtimePay;
  final int downtimePay;
  final int hireCost;
  final int fireCost;

  const BellmanEquation({
    required this.nextStepValue,
    required this.currentStepValue,
    required this.requiredValue,
    required this.sumForNextStep,
    required this.overtimePay,
    required this.downtimePay,
    required this.fireCost,
    required this.hireCost,
  });

  /// Diff between current and next values
  int get nextHaveDiff {
    return nextStepValue - currentStepValue;
  }

  /// Diff between next and required values
  int get nextRequiredDiff {
    return nextStepValue - requiredValue;
  }

  int get fireHireCost {
    final int nhdiff = nextHaveDiff;
    if (nhdiff >= 0) {
      return nhdiff * hireCost;
    } else {
      // use [-] to make result positive
      return -nhdiff * fireCost;
    }
  }

  int get overtimeDowntimePay {
    final int nrdiff = nextRequiredDiff;
    if (nrdiff >= 0) {
      return nrdiff * downtimePay;
    } else {
      // use [-] to make result positive
      return -nrdiff * overtimePay;
    }
  }

  int get result {
    return fireHireCost + overtimeDowntimePay + sumForNextStep;
  }
}

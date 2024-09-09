class RecordToTextResult {
  const RecordToTextResult(this.text, this.timestamp);
  final String text;
  final DateTime timestamp;
}

class SummaryTextResult {
  const SummaryTextResult(this.text, this.executeTime);

  final String text;
  final int executeTime;
}

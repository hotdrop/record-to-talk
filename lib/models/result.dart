class RecordToTextResult {
  const RecordToTextResult(this.text, this.executeTime);

  // TODO タイムラインが必要
  final String text;
  final int executeTime;
}

class SummaryTextResult {
  const SummaryTextResult(this.text, this.executeTime);

  final String text;
  final int executeTime;
}


extension SafeString on String? {
  String get checkNull {
    if (this == null || this!.trim().isEmpty) return '--';
    return this!;
  }
}

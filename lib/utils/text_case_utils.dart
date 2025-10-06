enum TextCase {
  sentence,
  title,
  upper,
}

String applyTextCase(String text, TextCase? textCase) {
  if (textCase == null) return text;

  switch (textCase) {
    case TextCase.upper:
      return text.toUpperCase();

    case TextCase.title:
      return text.replaceAllMapped(RegExp(r'\b\w'), (match) {
        return match.group(0)!.toUpperCase();
      });

    case TextCase.sentence:
      return _capitalizeSentences(text);
  }
}

/// Capitalizes the first letter of each sentence (after `.`, `!`, or `?`).
String _capitalizeSentences(String text) {
  final sentenceRegex = RegExp(r'([^.!?]*[.!?]*)', multiLine: true);
  final matches = sentenceRegex.allMatches(text);

  final result = matches.map((match) {
    final sentence = match.group(0)?.trimLeft() ?? '';
    if (sentence.isEmpty) return '';

    return sentence[0].toUpperCase() + sentence.substring(1);
  }).join(' ');

  return result.trim();
}



String getInitials(String fullName) {
  List<String> nameParts = fullName.trim().split(RegExp(r'\s+'));
  return nameParts.map((part) => part[0].toUpperCase()).join();
}


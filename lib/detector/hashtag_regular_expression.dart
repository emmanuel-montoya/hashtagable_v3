const _symbols = '·・ー_';

const _numbers = '0-9０-９';

const _englishLetters = 'a-zA-Zａ-ｚＡ-Ｚ';

const _japaneseLetters = 'ぁ-んァ-ン一-龠';

const _koreanLetters = '\u1100-\u11FF\uAC00-\uD7A3';

const _spanishLetters = 'áàãâéêíóôõúüçÁÀÃÂÉÊÍÓÔÕÚÜÇ';

const _arabicLetters = '\u0621-\u064A';

const _thaiLetters = '\u0E00-\u0E7F';

const _norwegianLetters = 'åøæ';

const _germanLetters = 'ÄäÖöÜüẞß';

const _turkishLetters = 'IıÖöŞşÇçÜüĞğ';

const hashTagContentLetters = _symbols +
    _numbers +
    _englishLetters +
    _japaneseLetters +
    _koreanLetters +
    _spanishLetters +
    _arabicLetters +
    _thaiLetters +
    _norwegianLetters +
    _turkishLetters +
    _germanLetters;

/// Regular expression to extract hashtag from text
///
/// Supports English, Japanese, Korean, Spanish, Arabic, and Thai
final hashTagRegExp = RegExp(
  "(?!\\n)(?:^|\\s)(#([$hashTagContentLetters]+))",
  multiLine: true,
);

/// Regular expression when you select decorateAtSign
final hashTagAtSignRegExp = RegExp(
  "(?!\\n)(?:^|\\s)([#@]([$hashTagContentLetters]+))",
  multiLine: true,
);

/// Regular expression when you select decorateCashtag ($)
final hashTagCashtagRegExp = RegExp(
  "(?!\\n)(?:^|\\s)([#\\\$]([$hashTagContentLetters]+))",
  multiLine: true,
);

/// Regular expression when you select decorateAtSign and decorateCashtag ($)
final hashTagAtSignCashtagRegExp = RegExp(
  "(?!\\n)(?:^|\\s)([#@\\\$]([$hashTagContentLetters]+))",
  multiLine: true,
);

/// Creates a custom [RegExp] for arbitrary tag prefix symbols (e.g. ['#', '@', '$'])
RegExp createTagRegExp(List<String> prefixes) {
  final escaped = prefixes.map(RegExp.escape).join();
  return RegExp(
    "(?!\\n)(?:^|\\s)([$escaped]([$hashTagContentLetters]+))",
    multiLine: true,
  );
}


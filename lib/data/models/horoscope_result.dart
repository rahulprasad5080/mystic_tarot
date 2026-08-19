/// Model for parsing DivineAPI Horoscope responses (Daily, Weekly, Monthly, Yearly).
class HoroscopePrediction {
  final String? personal;
  final String? health;
  final String? profession;
  final String? emotions;
  final String? travel;
  final String? luck;

  const HoroscopePrediction({
    this.personal,
    this.health,
    this.profession,
    this.emotions,
    this.travel,
    this.luck,
  });

  factory HoroscopePrediction.fromJson(Map<String, dynamic> json) {
    String? parseStringOrList(dynamic val) {
      if (val == null) return null;
      if (val is String) return val;
      if (val is List) return val.map((e) => e.toString()).join('\n');
      return val.toString();
    }

    return HoroscopePrediction(
      personal: parseStringOrList(json['personal']),
      health: parseStringOrList(json['health']),
      profession: parseStringOrList(json['profession'] ?? json['career']),
      emotions: parseStringOrList(json['emotions'] ?? json['emotion'] ?? json['love']),
      travel: parseStringOrList(json['travel']),
      luck: parseStringOrList(json['luck'] ?? json['luck_prediction']),
    );
  }
}

class HoroscopeSpecial {
  final String? luckyColor;
  final String? luckyNumber;
  final String? luckyTime;

  const HoroscopeSpecial({
    this.luckyColor,
    this.luckyNumber,
    this.luckyTime,
  });

  factory HoroscopeSpecial.fromJson(Map<String, dynamic> json) {
    return HoroscopeSpecial(
      luckyColor: json['lucky_color']?.toString() ?? json['color']?.toString(),
      luckyNumber: json['lucky_number']?.toString() ?? json['number']?.toString(),
      luckyTime: json['lucky_time']?.toString() ?? json['time']?.toString(),
    );
  }
}

class HoroscopeResult {
  final String sign;
  final String? period; // date, week, month, or year
  final HoroscopePrediction prediction;
  final HoroscopeSpecial? special;

  const HoroscopeResult({
    required this.sign,
    this.period,
    required this.prediction,
    this.special,
  });

  factory HoroscopeResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    final sign = data['sign']?.toString() ?? 'Aries';
    final period = data['date']?.toString() ??
        data['week']?.toString() ??
        data['month']?.toString() ??
        data['year']?.toString();

    final rawPred = data['prediction'] as Map<String, dynamic>? ??
        data['weekly_horoscope'] as Map<String, dynamic>? ??
        data['monthly_horoscope'] as Map<String, dynamic>? ??
        data['yearly_horoscope'] as Map<String, dynamic>? ??
        data;

    final prediction = HoroscopePrediction.fromJson(rawPred);

    HoroscopeSpecial? special;
    if (data['special'] is Map<String, dynamic>) {
      special = HoroscopeSpecial.fromJson(data['special'] as Map<String, dynamic>);
    }

    return HoroscopeResult(
      sign: sign,
      period: period,
      prediction: prediction,
      special: special,
    );
  }
}

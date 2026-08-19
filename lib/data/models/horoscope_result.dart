import '../../core/utils/json_utils.dart';

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
    return HoroscopePrediction(
      personal: JsonUtils.parseString(json['personal']),
      health: JsonUtils.parseString(json['health']),
      profession: JsonUtils.parseString(json['profession'] ?? json['career']),
      emotions: JsonUtils.parseString(json['emotions'] ?? json['emotion'] ?? json['love']),
      travel: JsonUtils.parseString(json['travel']),
      luck: JsonUtils.parseString(json['luck'] ?? json['luck_prediction']),
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
      luckyColor: JsonUtils.parseString(json['lucky_color'] ?? json['color']),
      luckyNumber: JsonUtils.parseString(json['lucky_number'] ?? json['number']),
      luckyTime: JsonUtils.parseString(json['lucky_time'] ?? json['time']),
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
    final rawData = json['data'];
    final Map<String, dynamic> data = rawData is Map ? JsonUtils.parseMap(rawData) : json;

    final sign = JsonUtils.parseString(data['sign']) ?? 'Aries';
    final period = JsonUtils.parseString(
      data['date'] ?? data['week'] ?? data['month'] ?? data['year'],
    );

    final rawPred = data['prediction'] ??
        data['weekly_horoscope'] ??
        data['monthly_horoscope'] ??
        data['yearly_horoscope'] ??
        data;

    final Map<String, dynamic> predMap = rawPred is Map ? JsonUtils.parseMap(rawPred) : data;

    final prediction = HoroscopePrediction.fromJson(predMap);

    HoroscopeSpecial? special;
    if (data['special'] is Map) {
      special = HoroscopeSpecial.fromJson(JsonUtils.parseMap(data['special']));
    }

    return HoroscopeResult(
      sign: sign,
      period: period,
      prediction: prediction,
      special: special,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/reading_types.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/horoscope_result.dart';
import '../../state/providers/reading_provider.dart';
import '../widgets/divine_loading_widget.dart';
import '../widgets/error_retry_widget.dart';

class ZodiacSignInfo {
  final String name;
  final String symbol;
  final String dateRange;
  final IconData icon;

  const ZodiacSignInfo({
    required this.name,
    required this.symbol,
    required this.dateRange,
    required this.icon,
  });
}

class HoroscopeScreen extends ConsumerStatefulWidget {
  final String? initialSign;

  const HoroscopeScreen({super.key, this.initialSign});

  @override
  ConsumerState<HoroscopeScreen> createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends ConsumerState<HoroscopeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _selectedSign;

  static const List<ZodiacSignInfo> _zodiacSigns = [
    ZodiacSignInfo(name: 'Aries', symbol: '♈', dateRange: 'Mar 21 - Apr 19', icon: Icons.whatshot_rounded),
    ZodiacSignInfo(name: 'Taurus', symbol: '♉', dateRange: 'Apr 20 - May 20', icon: Icons.landscape_rounded),
    ZodiacSignInfo(name: 'Gemini', symbol: '♊', dateRange: 'May 21 - Jun 20', icon: Icons.air_rounded),
    ZodiacSignInfo(name: 'Cancer', symbol: '♋', dateRange: 'Jun 21 - Jul 22', icon: Icons.water_drop_rounded),
    ZodiacSignInfo(name: 'Leo', symbol: '♌', dateRange: 'Jul 23 - Aug 22', icon: Icons.wb_sunny_rounded),
    ZodiacSignInfo(name: 'Virgo', symbol: '♍', dateRange: 'Aug 23 - Sep 22', icon: Icons.nature_rounded),
    ZodiacSignInfo(name: 'Libra', symbol: '♎', dateRange: 'Sep 23 - Oct 22', icon: Icons.balance_rounded),
    ZodiacSignInfo(name: 'Scorpio', symbol: '♏', dateRange: 'Oct 23 - Nov 21', icon: Icons.bolt_rounded),
    ZodiacSignInfo(name: 'Sagittarius', symbol: '♐', dateRange: 'Nov 22 - Dec 21', icon: Icons.explore_rounded),
    ZodiacSignInfo(name: 'Capricorn', symbol: '♑', dateRange: 'Dec 22 - Jan 19', icon: Icons.terrain_rounded),
    ZodiacSignInfo(name: 'Aquarius', symbol: '♒', dateRange: 'Jan 20 - Feb 18', icon: Icons.waves_rounded),
    ZodiacSignInfo(name: 'Pisces', symbol: '♓', dateRange: 'Feb 19 - Mar 20', icon: Icons.pool_rounded),
  ];

  final List<ReadingType> _horoscopeTypes = [
    ReadingTypes.all.firstWhere((r) => r.id == 'daily_horoscope'),
    ReadingTypes.all.firstWhere((r) => r.id == 'weekly_horoscope'),
    ReadingTypes.all.firstWhere((r) => r.id == 'monthly_horoscope'),
    ReadingTypes.all.firstWhere((r) => r.id == 'yearly_horoscope'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _selectedSign = widget.initialSign ?? 'Aries';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSignInfo = _zodiacSigns.firstWhere(
      (s) => s.name.toLowerCase() == _selectedSign.toLowerCase(),
      orElse: () => _zodiacSigns.first,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentSignInfo.symbol,
              style: const TextStyle(fontSize: 24, color: AppColors.gold),
            ),
            const SizedBox(width: 8),
            Text(
              '${currentSignInfo.name} Horoscope',
              style: const TextStyle(
                color: AppColors.textLight,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.gold,
          labelColor: AppColors.gold,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
            Tab(text: 'Yearly'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Zodiac Selector Bar
          _buildZodiacSelector(),
          const Divider(color: AppColors.surfaceLight, height: 1),

          // Predictions Content Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _horoscopeTypes.map((type) {
                return _buildHoroscopeContent(type);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZodiacSelector() {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _zodiacSigns.length,
        itemBuilder: (context, index) {
          final sign = _zodiacSigns[index];
          final isSelected = sign.name.toLowerCase() == _selectedSign.toLowerCase();

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedSign = sign.name;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? AppColors.goldGradient
                    : LinearGradient(
                        colors: [
                          AppColors.surfaceDark.withValues(alpha: 0.8),
                          AppColors.surfaceLight.withValues(alpha: 0.3),
                        ],
                      ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.gold : AppColors.surfaceLight,
                  width: isSelected ? 1.5 : 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    sign.symbol,
                    style: TextStyle(
                      fontSize: 20,
                      color: isSelected ? AppColors.backgroundDark : AppColors.gold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sign.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? AppColors.backgroundDark : AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHoroscopeContent(ReadingType type) {
    final params = ReadingParams(
      readingType: type,
      sign: _selectedSign,
    );

    final readingAsync = ref.watch(readingProvider(params));

    return readingAsync.when(
      loading: () => const DivineLoadingWidget(),
      error: (err, stack) => ErrorRetryWidget(
        message: err.toString(),
        onRetry: () => ref.invalidate(readingProvider(params)),
      ),
      data: (response) {
        if (!response.isSuccess || response.data == null) {
          return ErrorRetryWidget(
            message: (response.message != null && response.message!.isNotEmpty)
                ? response.message!
                : 'Unable to fetch horoscope prediction.',
            onRetry: () => ref.invalidate(readingProvider(params)),
          );
        }

        final HoroscopeResult horoscope = response.data as HoroscopeResult;
        final pred = horoscope.prediction;

        return RefreshIndicator(
          color: AppColors.gold,
          backgroundColor: AppColors.surfaceDark,
          onRefresh: () async {
            ref.invalidate(readingProvider(params));
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Special Lucky Stats Card (if available)
              if (horoscope.special != null) _buildSpecialCard(horoscope.special!),

              const SizedBox(height: 12),

              // Prediction Sections
              if (pred.personal != null && pred.personal!.isNotEmpty)
                _buildPredictionSection(
                  title: 'Personal & Relationships',
                  content: pred.personal!,
                  icon: Icons.favorite_rounded,
                  color: AppColors.categoryLove,
                ),

              if (pred.profession != null && pred.profession!.isNotEmpty)
                _buildPredictionSection(
                  title: 'Career & Profession',
                  content: pred.profession!,
                  icon: Icons.work_rounded,
                  color: AppColors.celestialBlue,
                ),

              if (pred.health != null && pred.health!.isNotEmpty)
                _buildPredictionSection(
                  title: 'Health & Well-being',
                  content: pred.health!,
                  icon: Icons.spa_rounded,
                  color: AppColors.categorySpirituality,
                ),

              if (pred.emotions != null && pred.emotions!.isNotEmpty)
                _buildPredictionSection(
                  title: 'Emotions & Mindset',
                  content: pred.emotions!,
                  icon: Icons.psychology_rounded,
                  color: AppColors.accentBlue,
                ),

              if (pred.travel != null && pred.travel!.isNotEmpty)
                _buildPredictionSection(
                  title: 'Travel & Mobility',
                  content: pred.travel!,
                  icon: Icons.flight_takeoff_rounded,
                  color: AppColors.gold,
                ),

              if (pred.luck != null && pred.luck!.isNotEmpty)
                _buildPredictionSection(
                  title: 'Luck & Opportunities',
                  content: pred.luck!,
                  icon: Icons.auto_awesome_rounded,
                  color: AppColors.primaryGold,
                ),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpecialCard(HoroscopeSpecial special) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.1),
            blurRadius: 12,
            spreadRadius: 1,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (special.luckyColor != null)
            _buildSpecialItem('Lucky Color', special.luckyColor!, Icons.palette_rounded, AppColors.gold),
          if (special.luckyNumber != null)
            _buildSpecialItem('Lucky Number', special.luckyNumber!, Icons.pin_rounded, AppColors.celestialBlue),
          if (special.luckyTime != null)
            _buildSpecialItem('Lucky Time', special.luckyTime!, Icons.schedule_rounded, AppColors.categorySpirituality),
        ],
      ),
    );
  }

  Widget _buildSpecialItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionSection({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 14.5,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

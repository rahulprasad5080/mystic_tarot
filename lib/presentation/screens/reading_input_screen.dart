import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/reading_types.dart';
import '../../data/models/user_profile.dart';
import '../../data/services/user_profile_service.dart';
import '../../state/providers/locale_provider.dart';
import '../widgets/native_ad_widget.dart';

/// Screen for entering user details (question, name, DOB, gender, sign)
/// before running a Tarot reading, with support for:
/// 1. Optional Question input (move to next step with or without asking a question).
/// 2. Profile memory (saves up to 5 profiles so users fill once and switch easily).
class ReadingInputScreen extends ConsumerStatefulWidget {
  final ReadingType readingType;

  const ReadingInputScreen({
    super.key,
    required this.readingType,
  });

  @override
  ConsumerState<ReadingInputScreen> createState() => _ReadingInputScreenState();
}

class _ReadingInputScreenState extends ConsumerState<ReadingInputScreen> {
  final _questionController = TextEditingController();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();

  String? _selectedGender;
  String? _selectedZodiacSign;

  String? _nameError;
  String? _dobError;
  String? _genderError;
  String? _zodiacError;

  List<UserProfile> _profiles = UserProfileService.defaultProfiles;
  int _activeProfileIndex = 0;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _initProfiles();

    _nameController.addListener(() {
      if (_nameError != null && _nameController.text.trim().isNotEmpty) {
        setState(() => _nameError = null);
      }
      _updateActiveProfileInMemory();
    });
  }

  Future<void> _initProfiles() async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      _prefs = prefs;
    } catch (_) {
      _prefs = await SharedPreferences.getInstance();
    }
    if (_prefs != null) {
      final service = UserProfileService(_prefs!);
      final loaded = service.loadProfiles();
      final activeId = service.loadActiveProfileId();
      int activeIndex = loaded.indexWhere((p) => p.id == activeId);
      if (activeIndex < 0) activeIndex = 0;

      setState(() {
        _profiles = loaded;
        _activeProfileIndex = activeIndex;
        _populateFieldsFromProfile(loaded[activeIndex]);
      });
    }
  }

  void _populateFieldsFromProfile(UserProfile profile) {
    _nameController.text = profile.name;
    _dobController.text = profile.dob;
    _selectedGender = profile.gender;
    _selectedZodiacSign = profile.zodiacSign;
  }

  void _updateActiveProfileInMemory() {
    if (_profiles.isEmpty) return;
    final updated = _profiles[_activeProfileIndex].copyWith(
      name: _nameController.text,
      dob: _dobController.text,
      gender: _selectedGender,
      zodiacSign: _selectedZodiacSign,
    );
    _profiles[_activeProfileIndex] = updated;
    _saveProfilesToPrefs();
  }

  Future<void> _saveProfilesToPrefs() async {
    if (_prefs == null) return;
    final service = UserProfileService(_prefs!);
    final activeId = _profiles[_activeProfileIndex].id;
    await service.saveProfiles(_profiles, activeId);
  }

  void _switchProfile(int newIndex) {
    if (newIndex == _activeProfileIndex) return;

    // Save current active profile values first
    _updateActiveProfileInMemory();

    setState(() {
      _activeProfileIndex = newIndex;
      _populateFieldsFromProfile(_profiles[newIndex]);

      // Clear field errors on switch
      _nameError = null;
      _dobError = null;
      _genderError = null;
      _zodiacError = null;
    });

    _saveProfilesToPrefs();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF006884),
              onPrimary: Colors.white,
              onSurface: Color(0xFF101828),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
        _dobError = null;
      });
      _updateActiveProfileInMemory();
    }
  }

  /// Show custom modal bottom sheet to pick Gender
  void _showGenderBottomSheet(BuildContext context) {
    final options = ['Male', 'Female', 'Non-binary', 'Prefer not to say'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAECF0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const Text(
                'Select Gender',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF101828),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Choose your gender identity',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF667085),
                ),
              ),
              const SizedBox(height: 16),

              ...options.map((gender) {
                final isSelected = gender == _selectedGender;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedGender = gender;
                        _genderError = null;
                      });
                      _updateActiveProfileInMemory();
                      Navigator.pop(ctx);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFEBF5FF)
                            : const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF006884)
                              : const Color(0xFFEAECF0),
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            gender,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? const Color(0xFF006884)
                                  : const Color(0xFF101828),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xFF006884),
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  /// Show custom modal bottom sheet to pick Zodiac Sign
  void _showZodiacBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.75,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAECF0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const Text(
                'Select Zodiac Sign',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF101828),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Select your astrological sign for accurate readings',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF667085),
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: AppConstants.zodiacSigns.length,
                  itemBuilder: (context, index) {
                    final sign = AppConstants.zodiacSigns[index];
                    final emoji = AppConstants.zodiacEmojis[sign] ?? '✨';
                    final isSelected = sign == _selectedZodiacSign;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedZodiacSign = sign;
                          _zodiacError = null;
                        });
                        _updateActiveProfileInMemory();
                        Navigator.pop(ctx);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFEBF5FF)
                              : const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF006884)
                                : const Color(0xFFEAECF0),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              emoji,
                              style: const TextStyle(fontSize: 22),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                sign,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? const Color(0xFF006884)
                                      : const Color(0xFF101828),
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF006884),
                                size: 18,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  String _getReadingTitle(ReadingType reading) {
    final map = <String, String>{
      'yes_or_no_tarot': 'Yes OR No Tarot',
      'in_depth_love': 'In-Depth Love Reading',
      'divine_angel': 'Divine Angel Reading',
      'daily_tarot': 'Daily Tarot',
      'dream_come_true': 'Dream Come True Reading',
      'which_animal': 'Which Animal Are You Reading',
      'past_present_future': 'Past-Present-Future Reading',
      'flirt_love': 'Flirt Love Reading',
      'erotic_love': 'Erotic Love Reading',
      'egyptian_prediction': 'Egyptian Prediction',
      'ex_flame': 'Ex-Flame Reading',
      'made_for_each_other': 'Made For Each Other Or Not Reading',
      'power_life': 'Power Life Reading',
      'know_your_friend': 'Know Your Friend Reading',
      'career_daily': 'Career Daily Reading',
      'heartbreak': 'Heartbreak Reading',
      'love_triangle': 'Love Triangle Reading',
      'wisdom': 'Wisdom Reading',
      'divine_magic': 'Divine Magic Reading',
      'past_lives_connection': 'Past Lives Connection Reading',
    };
    return map[reading.id] ?? reading.id;
  }

  void _startReading() {
    // Note: Question is completely optional! Move to next step whether question is entered or not.
    final name = _nameController.text.trim();
    final dob = _dobController.text.trim();
    final gender = _selectedGender;
    final sign = _selectedZodiacSign;

    setState(() {
      _nameError = name.isEmpty ? 'Please enter full name' : null;
      _dobError = dob.isEmpty ? 'Please select date of birth' : null;
      _genderError = gender == null ? 'Please select gender' : null;
      _zodiacError = sign == null ? 'Please select zodiac sign' : null;
    });

    if (name.isEmpty || dob.isEmpty || gender == null || sign == null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 22),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Please complete profile details to continue.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFD92D20),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    // Save profile details for future readings
    _updateActiveProfileInMemory();

    if (widget.readingType.inputType == ReadingInputType.cardSelect) {
      Navigator.of(context).pushNamed(
        '/card-select',
        arguments: widget.readingType,
      );
    } else {
      Navigator.of(context).pushNamed(
        '/reading-detail',
        arguments: widget.readingType,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF7F7FD);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF006884),
                        size: 22,
                      ),
                    ),
                  ),

                  // Header Title
                  const Text(
                    'Divine Readings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF006884),
                      letterSpacing: -0.3,
                    ),
                  ),

                  // Empty right space to keep header centered
                  const SizedBox(width: 36),
                ],
              ),
            ),

            // Main Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // Soft Blue Reading Icon Container
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFEBF5FF),
                      ),
                      child: Icon(
                        widget.readingType.icon,
                        color: const Color(0xFF0088B2),
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Reading Title
                    Text(
                      _getReadingTitle(widget.readingType),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF101828),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),

                    // Reading Subtitle
                    const Text(
                      'Ask the cards for clear guidance.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF667085),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Native Ad Unit matching app template
                    const NativeAdWidget(),

                    const SizedBox(height: 16),

                    // Form White Card Container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFF2F4F7),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Saved Profiles Section (Up to 5 people)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Saved Profiles',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF101828),
                                ),
                              ),
                              Text(
                                'Save for up to 5 people',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF667085),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Profile Selection Pills
                          SizedBox(
                            height: 40,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              separatorBuilder: (_, _) => const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final profile = _profiles.length > index
                                    ? _profiles[index]
                                    : UserProfile(id: '${index + 1}', name: 'Person ${index + 1}', dob: '');
                                final isSelected = index == _activeProfileIndex;
                                final displayName = profile.name.trim().isNotEmpty
                                    ? profile.name.trim()
                                    : 'Person ${index + 1}';

                                return InkWell(
                                  onTap: () => _switchProfile(index),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF006884)
                                          : const Color(0xFFF9FAFB),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF006884)
                                            : const Color(0xFFEAECF0),
                                        width: isSelected ? 1.5 : 1.0,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isSelected ? Icons.person_rounded : Icons.person_outline_rounded,
                                          size: 16,
                                          color: isSelected ? Colors.white : const Color(0xFF475467),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          displayName,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                            color: isSelected ? Colors.white : const Color(0xFF344054),
                                          ),
                                        ),
                                        if (profile.hasData && !isSelected) ...[
                                          const SizedBox(width: 4),
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF12B76A),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 1. Your Question (Optional)
                          _buildFieldLabel('Your Question (Optional)'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _questionController,
                            maxLines: 3,
                            style: const TextStyle(fontSize: 14, color: Color(0xFF101828)),
                            decoration: _buildInputDecoration(
                              'What do you seek clarity on? (Optional)',
                            ),
                          ),
                          const SizedBox(height: 18),

                          // 2. Full Name
                          _buildFieldLabel('Full Name'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _nameController,
                            style: const TextStyle(fontSize: 14, color: Color(0xFF101828)),
                            decoration: _buildInputDecoration(
                              'Enter full name',
                              errorText: _nameError,
                            ),
                          ),
                          const SizedBox(height: 18),

                          // 3. Date of Birth
                          _buildFieldLabel('Date of Birth'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _dobController,
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            style: const TextStyle(fontSize: 14, color: Color(0xFF101828)),
                            decoration: _buildInputDecoration(
                              'mm/dd/yyyy',
                              errorText: _dobError,
                            ).copyWith(
                              suffixIcon: const Icon(
                                Icons.calendar_today_outlined,
                                color: Color(0xFF667085),
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // 4. Gender (Custom Modal Bottom Sheet Picker)
                          _buildFieldLabel('Gender'),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _showGenderBottomSheet(context),
                            borderRadius: BorderRadius.circular(12),
                            child: InputDecorator(
                              decoration: _buildInputDecoration(
                                'Select',
                                errorText: _genderError,
                              ).copyWith(
                                suffixIcon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Color(0xFF667085),
                                  size: 20,
                                ),
                              ),
                              child: Text(
                                _selectedGender ?? 'Select',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _selectedGender == null
                                      ? const Color(0xFF98A2B3)
                                      : const Color(0xFF101828),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // 5. Zodiac Sign (Custom Modal Bottom Sheet Picker)
                          _buildFieldLabel('Zodiac Sign'),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _showZodiacBottomSheet(context),
                            borderRadius: BorderRadius.circular(12),
                            child: InputDecorator(
                              decoration: _buildInputDecoration(
                                'Select sign',
                                errorText: _zodiacError,
                              ).copyWith(
                                suffixIcon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Color(0xFF667085),
                                  size: 20,
                                ),
                              ),
                              child: Text(
                                _selectedZodiacSign != null
                                    ? "${AppConstants.zodiacEmojis[_selectedZodiacSign] ?? ''} $_selectedZodiacSign"
                                    : 'Select sign',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _selectedZodiacSign == null
                                      ? const Color(0xFF98A2B3)
                                      : const Color(0xFF101828),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Start Reading Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _startReading,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF006884),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Start Reading',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF101828),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, {String? errorText}) {
    return InputDecoration(
      hintText: hint,
      errorText: errorText,
      errorStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xFFD92D20),
      ),
      hintStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF98A2B3),
      ),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEAECF0), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF006884), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD92D20), width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD92D20), width: 1.5),
      ),
    );
  }
}

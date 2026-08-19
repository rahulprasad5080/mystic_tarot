import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/reading_types.dart';
import '../widgets/native_ad_widget.dart';

/// Screen for entering user details (question, name, DOB, gender, sign)
/// before running a Tarot reading, matching the exact UI mockup design.
class ReadingInputScreen extends StatefulWidget {
  final ReadingType readingType;

  const ReadingInputScreen({
    super.key,
    required this.readingType,
  });

  @override
  State<ReadingInputScreen> createState() => _ReadingInputScreenState();
}

class _ReadingInputScreenState extends State<ReadingInputScreen> {
  final _questionController = TextEditingController();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  
  String? _selectedGender;
  String? _selectedZodiacSign;

  String? _questionError;
  String? _nameError;
  String? _dobError;
  String? _genderError;
  String? _zodiacError;

  @override
  void initState() {
    super.initState();
    _questionController.addListener(() {
      if (_questionError != null && _questionController.text.trim().isNotEmpty) {
        setState(() => _questionError = null);
      }
    });
    _nameController.addListener(() {
      if (_nameError != null && _nameController.text.trim().isNotEmpty) {
        setState(() => _nameError = null);
      }
    });
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

  void _startReading() {
    final question = _questionController.text.trim();
    final name = _nameController.text.trim();
    final dob = _dobController.text.trim();
    final gender = _selectedGender;
    final sign = _selectedZodiacSign;

    setState(() {
      _questionError = question.isEmpty ? 'Please enter your question' : null;
      _nameError = name.isEmpty ? 'Please enter your full name' : null;
      _dobError = dob.isEmpty ? 'Please select date of birth' : null;
      _genderError = gender == null ? 'Please select gender' : null;
      _zodiacError = sign == null ? 'Please select zodiac sign' : null;
    });

    if (question.isEmpty ||
        name.isEmpty ||
        dob.isEmpty ||
        gender == null ||
        sign == null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 22),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Please fill in all required fields to continue.',
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

                  // Profile Icon Button
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/profile');
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Icon(
                      Icons.account_circle_outlined,
                      color: Color(0xFF006884),
                      size: 26,
                    ),
                  ),
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
                      widget.readingType.id == 'yes_or_no_tarot'
                          ? 'Yes OR No Tarot'
                          : widget.readingType.id,
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
                          // 1. Your Question
                          _buildFieldLabel('Your Question'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _questionController,
                            maxLines: 3,
                            style: const TextStyle(fontSize: 14, color: Color(0xFF101828)),
                            decoration: _buildInputDecoration(
                              'What do you seek clarity on?',
                              errorText: _questionError,
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
                              'Enter your full name',
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

import 'package:flutter/material.dart';

/// Settings screen matching the exact grouped UI design of the latest mockup.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

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
                  // Language Button
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/language');
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFEBF5FF),
                      ),
                      child: const Icon(
                        Icons.language_rounded,
                        color: Color(0xFF006884),
                        size: 20,
                      ),
                    ),
                  ),

                  // Header Title
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF006884),
                      letterSpacing: -0.3,
                    ),
                  ),

                  // User Avatar Button
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/profile');
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFFE0E0E0),
                      child: ClipOval(
                        child: Icon(
                          Icons.person,
                          size: 22,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Section 1: PREFERENCES
                    _buildSectionHeader('PREFERENCES'),
                    const SizedBox(height: 8),
                    _buildCardContainer(
                      children: [
                        _buildSettingsRow(
                          icon: Icons.language_rounded,
                          title: 'Language',
                          trailingText: 'English',
                          onTap: () {
                            Navigator.of(context).pushNamed('/language');
                          },
                        ),
                        const Divider(height: 1, color: Color(0xFFF2F4F7)),
                        _buildSettingsRow(
                          icon: Icons.notifications_none_rounded,
                          title: 'Notifications',
                          showChevron: false,
                          trailingWidget: Switch.adaptive(
                            value: _notificationsEnabled,
                            activeTrackColor: const Color(0xFF006884),
                            onChanged: (val) {
                              setState(() {
                                _notificationsEnabled = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Section 2: ACCOUNT & DATA
                    _buildSectionHeader('ACCOUNT & DATA'),
                    const SizedBox(height: 8),
                    _buildCardContainer(
                      children: [
                        _buildSettingsRow(
                          icon: Icons.bookmark_border_rounded,
                          title: 'Saved Readings',
                          onTap: () {
                            Navigator.of(context).pushNamed('/saved');
                          },
                        ),
                        const Divider(height: 1, color: Color(0xFFF2F4F7)),
                        _buildSettingsRow(
                          icon: Icons.person_outline_rounded,
                          title: 'User Profile',
                          onTap: () {
                            Navigator.of(context).pushNamed('/profile');
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Section 3: ABOUT & SUPPORT
                    _buildSectionHeader('ABOUT & SUPPORT'),
                    const SizedBox(height: 8),
                    _buildCardContainer(
                      children: [
                        _buildSettingsRow(
                          icon: Icons.star_border_rounded,
                          title: 'Rate App',
                          onTap: () {},
                        ),
                        const Divider(height: 1, color: Color(0xFFF2F4F7)),
                        _buildSettingsRow(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          onTap: () {},
                        ),
                        const Divider(height: 1, color: Color(0xFFF2F4F7)),
                        _buildSettingsRow(
                          icon: Icons.description_outlined,
                          title: 'Terms & Conditions',
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF475569),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildCardContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF2F4F7),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required String title,
    String? trailingText,
    Widget? trailingWidget,
    bool showChevron = true,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        child: Row(
          children: [
            // Soft Blue Icon Circle Badge
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEBF5FF),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF0088B2),
                size: 20,
              ),
            ),
            const SizedBox(width: 14),

            // Title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF101828),
                ),
              ),
            ),

            // Trailing Content
            if (trailingWidget != null)
              trailingWidget
            else ...[
              if (trailingText != null)
                Text(
                  trailingText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF667085),
                  ),
                ),
              if (trailingText != null && showChevron) const SizedBox(width: 6),
              if (showChevron)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFD0D5DD),
                  size: 20,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

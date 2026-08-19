import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Ably Tarot Card Reading'**
  String get appTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Seek cosmic wisdom & spiritual guidance'**
  String get homeSubtitle;

  /// No description provided for @categoryTarot.
  ///
  /// In en, this message translates to:
  /// **'Tarot Readings'**
  String get categoryTarot;

  /// No description provided for @categoryLove.
  ///
  /// In en, this message translates to:
  /// **'Love & Relationships'**
  String get categoryLove;

  /// No description provided for @categoryLife.
  ///
  /// In en, this message translates to:
  /// **'Life & Career'**
  String get categoryLife;

  /// No description provided for @categorySpirituality.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Wisdom'**
  String get categorySpirituality;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @selectCard.
  ///
  /// In en, this message translates to:
  /// **'Select a Card'**
  String get selectCard;

  /// No description provided for @selectCardDesc.
  ///
  /// In en, this message translates to:
  /// **'Focus on your question and choose a card from the Major Arcana'**
  String get selectCardDesc;

  /// No description provided for @revealReading.
  ///
  /// In en, this message translates to:
  /// **'Reveal Reading'**
  String get revealReading;

  /// No description provided for @selectSigns.
  ///
  /// In en, this message translates to:
  /// **'Select Zodiac Signs'**
  String get selectSigns;

  /// No description provided for @selectSignsDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose your sign and your partner\'s sign to reveal love compatibility'**
  String get selectSignsDesc;

  /// No description provided for @yourSign.
  ///
  /// In en, this message translates to:
  /// **'Your Sign'**
  String get yourSign;

  /// No description provided for @partnerSign.
  ///
  /// In en, this message translates to:
  /// **'Partner\'s Sign'**
  String get partnerSign;

  /// No description provided for @calculateCompatibility.
  ///
  /// In en, this message translates to:
  /// **'Calculate Compatibility'**
  String get calculateCompatibility;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Unable to fetch reading. Please try again.'**
  String get errorGeneric;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @readingYesOrNo.
  ///
  /// In en, this message translates to:
  /// **'Yes or No Tarot'**
  String get readingYesOrNo;

  /// No description provided for @readingYesOrNoDesc.
  ///
  /// In en, this message translates to:
  /// **'Get instant clarity with a direct Yes or No answer'**
  String get readingYesOrNoDesc;

  /// No description provided for @readingDailyTarot.
  ///
  /// In en, this message translates to:
  /// **'Daily Tarot'**
  String get readingDailyTarot;

  /// No description provided for @readingDailyTarotDesc.
  ///
  /// In en, this message translates to:
  /// **'Discover what the cards foretell for your day ahead'**
  String get readingDailyTarotDesc;

  /// No description provided for @readingFortuneCookie.
  ///
  /// In en, this message translates to:
  /// **'Fortune Cookie'**
  String get readingFortuneCookie;

  /// No description provided for @readingFortuneCookieDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive a daily nugget of spiritual wisdom'**
  String get readingFortuneCookieDesc;

  /// No description provided for @readingCoffeeCup.
  ///
  /// In en, this message translates to:
  /// **'Coffee Cup Reading'**
  String get readingCoffeeCup;

  /// No description provided for @readingCoffeeCupDesc.
  ///
  /// In en, this message translates to:
  /// **'Symbols revealed in the grounds of present and future'**
  String get readingCoffeeCupDesc;

  /// No description provided for @readingCareerDaily.
  ///
  /// In en, this message translates to:
  /// **'Career Daily Reading'**
  String get readingCareerDaily;

  /// No description provided for @readingCareerDailyDesc.
  ///
  /// In en, this message translates to:
  /// **'Insights into work, ambition, and financial paths'**
  String get readingCareerDailyDesc;

  /// No description provided for @readingDivineAngel.
  ///
  /// In en, this message translates to:
  /// **'Divine Angel Reading'**
  String get readingDivineAngel;

  /// No description provided for @readingDivineAngelDesc.
  ///
  /// In en, this message translates to:
  /// **'Angelic messages of comfort and celestial direction'**
  String get readingDivineAngelDesc;

  /// No description provided for @readingDivineMagic.
  ///
  /// In en, this message translates to:
  /// **'Divine Magic Reading'**
  String get readingDivineMagic;

  /// No description provided for @readingDivineMagicDesc.
  ///
  /// In en, this message translates to:
  /// **'Transformative energy, cause, and spiritual remedies'**
  String get readingDivineMagicDesc;

  /// No description provided for @readingDreamComeTrue.
  ///
  /// In en, this message translates to:
  /// **'Dream Come True'**
  String get readingDreamComeTrue;

  /// No description provided for @readingDreamComeTrueDesc.
  ///
  /// In en, this message translates to:
  /// **'Fulfill your heart\'s desires and deepest aspirations'**
  String get readingDreamComeTrueDesc;

  /// No description provided for @readingEgyptian.
  ///
  /// In en, this message translates to:
  /// **'Egyptian Prediction'**
  String get readingEgyptian;

  /// No description provided for @readingEgyptianDesc.
  ///
  /// In en, this message translates to:
  /// **'Ancient mystical guidance rooted in Nile traditions'**
  String get readingEgyptianDesc;

  /// No description provided for @readingEroticLove.
  ///
  /// In en, this message translates to:
  /// **'Erotic Love Reading'**
  String get readingEroticLove;

  /// No description provided for @readingEroticLoveDesc.
  ///
  /// In en, this message translates to:
  /// **'Sensual energies and passion in your intimacy'**
  String get readingEroticLoveDesc;

  /// No description provided for @readingExFlame.
  ///
  /// In en, this message translates to:
  /// **'Ex-Flame Reading'**
  String get readingExFlame;

  /// No description provided for @readingExFlameDesc.
  ///
  /// In en, this message translates to:
  /// **'Understand past lovers and heal old wounds'**
  String get readingExFlameDesc;

  /// No description provided for @readingFlirtLove.
  ///
  /// In en, this message translates to:
  /// **'Flirt Love Reading'**
  String get readingFlirtLove;

  /// No description provided for @readingFlirtLoveDesc.
  ///
  /// In en, this message translates to:
  /// **'Playful romance and magnetic attraction cues'**
  String get readingFlirtLoveDesc;

  /// No description provided for @readingHeartbreak.
  ///
  /// In en, this message translates to:
  /// **'Heartbreak Reading'**
  String get readingHeartbreak;

  /// No description provided for @readingHeartbreakDesc.
  ///
  /// In en, this message translates to:
  /// **'Healing guidance for a hurting heart'**
  String get readingHeartbreakDesc;

  /// No description provided for @readingInDepthLove.
  ///
  /// In en, this message translates to:
  /// **'In-Depth Love Reading'**
  String get readingInDepthLove;

  /// No description provided for @readingInDepthLoveDesc.
  ///
  /// In en, this message translates to:
  /// **'Deep relationship dynamics and emotional connection'**
  String get readingInDepthLoveDesc;

  /// No description provided for @readingKnowFriend.
  ///
  /// In en, this message translates to:
  /// **'Know Your Friend'**
  String get readingKnowFriend;

  /// No description provided for @readingKnowFriendDesc.
  ///
  /// In en, this message translates to:
  /// **'Uncover true intentions and friendship dynamics'**
  String get readingKnowFriendDesc;

  /// No description provided for @readingLoveCompat.
  ///
  /// In en, this message translates to:
  /// **'Love Compatibility'**
  String get readingLoveCompat;

  /// No description provided for @readingLoveCompatDesc.
  ///
  /// In en, this message translates to:
  /// **'Zodiac harmony score, strengths, and date ideas'**
  String get readingLoveCompatDesc;

  /// No description provided for @readingLoveTriangle.
  ///
  /// In en, this message translates to:
  /// **'Love Triangle Reading'**
  String get readingLoveTriangle;

  /// No description provided for @readingLoveTriangleDesc.
  ///
  /// In en, this message translates to:
  /// **'Navigate complex romantic decisions and 3 perspectives'**
  String get readingLoveTriangleDesc;

  /// No description provided for @readingMadeForEachOther.
  ///
  /// In en, this message translates to:
  /// **'Made For Each Other'**
  String get readingMadeForEachOther;

  /// No description provided for @readingMadeForEachOtherDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you true soulmates or temporary companions?'**
  String get readingMadeForEachOtherDesc;

  /// No description provided for @readingPowerLife.
  ///
  /// In en, this message translates to:
  /// **'Power Life Reading'**
  String get readingPowerLife;

  /// No description provided for @readingPowerLifeDesc.
  ///
  /// In en, this message translates to:
  /// **'Reclaim control and overcome life obstacles'**
  String get readingPowerLifeDesc;

  /// No description provided for @readingPastLives.
  ///
  /// In en, this message translates to:
  /// **'Past Lives Connection'**
  String get readingPastLives;

  /// No description provided for @readingPastLivesDesc.
  ///
  /// In en, this message translates to:
  /// **'Discover karmic bonds and previous incarnation ties'**
  String get readingPastLivesDesc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

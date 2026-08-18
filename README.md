# 🔮 Mystic Tarot & Spiritual Reading App

A modern, mystical Flutter application providing personalized Tarot, Astrology, Love Compatibility, and Spiritual Readings powered by **DivineAPI**. Designed with a breathtaking celestial glassmorphism UI, smooth micro-animations, and multi-language support.

---

## ✨ Features

- 🃏 **20 Unique Reading Modules**:
  - **Tarot**: *Daily Tarot*, *Yes/No Tarot*, *Fortune Cookie*, *Coffee Cup Reading*, *Career Daily*, *Divine Angel*.
  - **Love & Relationships**: *Love Compatibility (Zodiac)*, *In-Depth Love*, *Ex-Flame*, *Flirt Love*, *Erotic Love*, *Heartbreak*, *Love Triangle*, *Made For Each Other*.
  - **Spiritual & Life**: *Divine Magic*, *Past Lives Connection*, *Egyptian Prediction*, *Power Life*, *Dream Come True*, *Know Your Friend*.
- 🌐 **Multi-Language Support (i18n)**: Support for English, Hindi, Spanish, French, German, and Portuguese.
- 🎨 **Celestial Glassmorphism UI**: Beautiful cosmic themes featuring deep indigo gradients, glowing celestial orbs, glass cards, and interactive card flip animations.
- ⚡ **Riverpod State Management**: Reactive, robust, and clean state handling using `flutter_riverpod`.
- 💾 **Local Offline Storage**: Save your reading history and favorite predictions using `shared_preferences`.
- 🔑 **Environment Secured**: API credentials managed securely via `flutter_dotenv` (`.env`).

---

## 🛠️ Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev) (Dart SDK `^3.12.2`)
- **State Management**: [Flutter Riverpod](https://riverpod.dev) (`^2.6.1`)
- **API Provider**: [DivineAPI](https://divineapi.com) (`http ^1.4.0`)
- **UI & Animations**: `google_fonts`, `shimmer`, `cached_network_image`
- **Storage**: `shared_preferences`
- **Environment Management**: `flutter_dotenv`

### Directory Structure

```
lib/
├── app.dart                   # MaterialApp configuration & theme setup
├── main.dart                  # Entry point & dotenv initialization
├── core/
│   ├── constants/             # API endpoints, colors, reading types definition
│   ├── l10n/                  # Localization ARB files & generated localizations
│   └── theme/                 # App colors, text styles, dark celestial theme
├── data/
│   ├── models/                # Data models (ReadingResult, LoveCompatibility, etc.)
│   ├── repositories/          # Reading repository abstraction
│   └── services/              # DivineAPI HTTP service client
├── presentation/
│   ├── screens/               # Screens (Home, Daily Tarot, Card Select, Compatibility, Saved, Settings)
│   └── widgets/               # Reusable UI widgets (GlassCard, GlowOrb, LoadingShimmer, etc.)
└── state/
    └── providers/             # Riverpod providers for readings and locale
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.12.2`)
- [Dart SDK](https://dart.dev/get-dart)
- An active API key from [DivineAPI](https://divineapi.com)

### Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/rahulprasad5080/mystic_tarot.git
   cd mystic_tarot
   ```

2. **Setup Environment Variables**
   Create a `.env` file in the project root directory (you can copy `.env.example`):
   ```env
   DIVINE_API_KEY=your_api_key_here
   DIVINE_API_AUTH_TOKEN=your_auth_token_here
   DIVINE_API_BASE_URL=https://astroapi-5.divineapi.com
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the Application**
   ```bash
   flutter run
   ```

---

## 📱 Screens & User Flow

1. **Home Screen**: Explore reading categories (Tarot, Love, Life, Spiritual), daily insights, and quick actions.
2. **Interactive Card Selection**: Pick Major Arcana cards for interactive spreads with real-time feedback.
3. **Zodiac Compatibility**: Compare signs with intuitive dropdown selectors and detailed love reports.
4. **Reading Detail**: View full predictions, card images, guidance, and save readings for later reference.
5. **Saved Readings**: Revisit past predictions anytime offline.
6. **Settings & Language**: Switch app language and manage preferences effortlessly.

---

## 📜 License

This project is open-source under the MIT License.

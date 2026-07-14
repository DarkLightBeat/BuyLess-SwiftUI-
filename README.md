# BuyLess

BuyLess is an iOS app that helps people curb impulse spending by turning "no-spend" days into a trackable habit. Built with **SwiftUI**, **SwiftData**, and **Firebase**, it combines streak tracking, daily challenges, and impulse-urge journaling into a single, lightweight dashboard.

## Features

- **Authentication** — Email/password sign up and sign in via Firebase Auth, with user profiles stored in Firestore.
- **Dashboard** — At-a-glance view of your current streak, best streak, and day count in the no-spend challenge.
- **Daily Challenges** — A new mindfulness/anti-consumerism challenge and quote each day, paired with an estimated savings amount.
- **Calendar Tracker** — Visual calendar marking spend vs. no-spend days, with monthly stats and a legend.
- **Urge Journal** — Log impulse-buying urges (item, cost, trigger) and reflect on them later; view a running list of recent entries.
- **Settings** — Edit profile, change password, toggle preferences, and access the privacy policy and help center.

## Tech Stack

- **SwiftUI** for the entire UI layer
- **SwiftData** for local persistence
- **Firebase**
  - Firebase Auth — user authentication
  - Cloud Firestore — user profiles, daily challenges, and urge journal entries
- **Swift Package Manager** for dependency management

## Project Structure

```
Villabroza_Consumerism/
├── Villabroza_ConsumerismApp.swift   # App entry point, Firebase setup, environment objects
├── ContentView.swift                  # Root view: auth routing + sign in/up handlers
├── Models/
│   ├── UserProfile.swift
│   ├── SpendingTracker.swift          # Streaks, savings, daily challenge state
│   ├── UrgeEntry.swift                # Journal entry model
│   └── DailyMessage.swift             # Daily challenge/quote content
├── Views/
│   ├── Authentication/                # Landing, Sign In, Sign Up
│   ├── Dashboard/                     # Home view, streaks, stats, challenge cards
│   ├── Calendar/                      # Calendar tracker and stats components
│   ├── Journal/                       # Urge journal and entry components
│   └── Settings/                      # Profile, password, help, privacy policy
└── Services/
    ├── AuthenticationService.swift
    ├── AuthenticationStateManager.swift
    └── UserProfileManager.swift
```

## Getting Started

### Prerequisites

- Xcode 15+
- An iOS 17+ simulator or device
- A Firebase project with **Authentication** (Email/Password) and **Cloud Firestore** enabled

### Setup

1. Clone the repo:
   ```bash
   git clone https://github.com/<your-username>/BuyLess.git
   cd BuyLess
   ```
2. Open `Villabroza_Consumerism.xcodeproj` in Xcode.
3. Add your own `GoogleService-Info.plist` from the Firebase console to the `Villabroza_Consumerism/` folder (this file is git-ignored — see below).
4. Let Xcode resolve Swift Package dependencies (Firebase iOS SDK and its transitive dependencies).
5. Build and run on a simulator or device.

> **Note:** This repo does not include a live `GoogleService-Info.plist`. You'll need to connect your own Firebase project to run the app.

## Roadmap Ideas

- Push notifications for daily challenge reminders
- Widget support for streak tracking
- Social/accountability features (share streaks with friends)
- Export urge journal as CSV/PDF

## License

Add a license of your choice (MIT is a common default for personal/student projects).

## Author

Created by a student as a personal SwiftUI project.

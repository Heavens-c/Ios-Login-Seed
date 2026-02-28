# Ios-Login-Seed

A SwiftUI iOS login seed project — a starting template for building iOS apps with user authentication.

## Features

- Email / password login form
- Input validation (non-empty fields, basic email format check)
- Show / hide password toggle
- Simulated authentication with a mock service
- Clean MVVM architecture
- Unit-tested ViewModel

## Project Structure

```
LoginSeed/
├── LoginSeed/
│   ├── LoginSeedApp.swift          # App entry point
│   ├── Models/
│   │   └── User.swift              # User model
│   ├── ViewModels/
│   │   └── LoginViewModel.swift    # Login business logic
│   └── Views/
│       ├── ContentView.swift       # Root content view
│       └── LoginView.swift         # Login screen UI
└── LoginSeedTests/
    └── LoginViewModelTests.swift   # ViewModel unit tests
```

## Requirements

- Xcode 15+
- iOS 16+
- Swift 5.9+

## Getting Started

1. Clone the repository.
2. Open `LoginSeed/LoginSeed.xcodeproj` in Xcode.
3. Select a simulator or device and press **Run** (⌘R).

## Usage

The seed ships with two hard-coded demo accounts:

| Email | Password |
|-------|----------|
| `user@example.com` | `password123` |
| `admin@example.com` | `admin456` |

Replace `MockAuthService` with a real network call to integrate your own backend.

## Architecture

The project follows **MVVM**:

- **Model** – plain Swift structs/classes (`User`).
- **ViewModel** – `ObservableObject` that owns business logic and exposes `@Published` state.
- **View** – SwiftUI views that are entirely driven by the ViewModel.

## License

MIT

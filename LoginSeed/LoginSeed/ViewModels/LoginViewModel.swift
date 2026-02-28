import Foundation
import Combine

// MARK: - Auth Service Protocol

protocol AuthServiceProtocol {
    /// Returns the authenticated `User` on success, or throws on failure.
    func login(email: String, password: String) async throws -> User
}

// MARK: - Mock Auth Service

final class MockAuthService: AuthServiceProtocol {
    private let accounts: [String: (password: String, displayName: String)] = [
        "user@example.com":  (password: "password123", displayName: "Demo User"),
        "admin@example.com": (password: "admin456",    displayName: "Admin")
    ]

    func login(email: String, password: String) async throws -> User {
        // Simulate network latency.
        try await Task.sleep(nanoseconds: 500_000_000)

        guard let account = accounts[email.lowercased()],
              account.password == password else {
            throw AuthError.invalidCredentials
        }

        return User(email: email.lowercased(), displayName: account.displayName)
    }
}

// MARK: - Auth Error

enum AuthError: LocalizedError {
    case invalidCredentials
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password. Please try again."
        case .networkError(let underlying):
            return "Network error: \(underlying.localizedDescription)"
        }
    }
}

// MARK: - Login ViewModel

@MainActor
final class LoginViewModel: ObservableObject {

    // MARK: Inputs
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false

    // MARK: Outputs
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil
    @Published private(set) var loggedInUser: User? = nil

    // MARK: Derived
    var isLoginButtonEnabled: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.isEmpty &&
        isValidEmail(email)
    }

    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = MockAuthService()) {
        self.authService = authService
    }

    // MARK: Actions

    func login() {
        guard isLoginButtonEnabled else { return }
        errorMessage = nil
        isLoading = true

        Task {
            defer { isLoading = false }
            do {
                loggedInUser = try await authService.login(
                    email: email.trimmingCharacters(in: .whitespaces),
                    password: password
                )
            } catch let error as AuthError {
                errorMessage = error.errorDescription
            } catch {
                errorMessage = AuthError.networkError(error).errorDescription
            }
        }
    }

    func logout() {
        loggedInUser = nil
        email = ""
        password = ""
    }

    // MARK: Private helpers

    private func isValidEmail(_ value: String) -> Bool {
        let regex = #"^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
        return value.range(of: regex, options: .regularExpression) != nil
    }
}

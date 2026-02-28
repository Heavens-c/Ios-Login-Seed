import XCTest
@testable import LoginSeed

// MARK: - Mock Auth Service for tests

final class SucceedingAuthService: AuthServiceProtocol {
    let stubbedUser: User

    init(user: User = User(email: "test@example.com", displayName: "Test User")) {
        stubbedUser = user
    }

    func login(email: String, password: String) async throws -> User {
        return stubbedUser
    }
}

final class FailingAuthService: AuthServiceProtocol {
    func login(email: String, password: String) async throws -> User {
        throw AuthError.invalidCredentials
    }
}

// MARK: - LoginViewModel Tests

@MainActor
final class LoginViewModelTests: XCTestCase {

    // MARK: isLoginButtonEnabled

    func test_loginButtonDisabled_whenEmailEmpty() {
        let sut = LoginViewModel(authService: SucceedingAuthService())
        sut.email = ""
        sut.password = "password123"
        XCTAssertFalse(sut.isLoginButtonEnabled)
    }

    func test_loginButtonDisabled_whenPasswordEmpty() {
        let sut = LoginViewModel(authService: SucceedingAuthService())
        sut.email = "user@example.com"
        sut.password = ""
        XCTAssertFalse(sut.isLoginButtonEnabled)
    }

    func test_loginButtonDisabled_whenEmailInvalidFormat() {
        let sut = LoginViewModel(authService: SucceedingAuthService())
        sut.email = "not-an-email"
        sut.password = "password123"
        XCTAssertFalse(sut.isLoginButtonEnabled)
    }

    func test_loginButtonEnabled_whenValidEmailAndPassword() {
        let sut = LoginViewModel(authService: SucceedingAuthService())
        sut.email = "user@example.com"
        sut.password = "password123"
        XCTAssertTrue(sut.isLoginButtonEnabled)
    }

    // MARK: Successful login

    func test_login_setsLoggedInUser_onSuccess() async throws {
        let expectedUser = User(email: "test@example.com", displayName: "Test User")
        let sut = LoginViewModel(authService: SucceedingAuthService(user: expectedUser))
        sut.email = "test@example.com"
        sut.password = "anypassword"

        sut.login()

        // Wait for the async Task inside login() to complete.
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(sut.loggedInUser, expectedUser)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: Failed login

    func test_login_setsErrorMessage_onInvalidCredentials() async throws {
        let sut = LoginViewModel(authService: FailingAuthService())
        sut.email = "user@example.com"
        sut.password = "wrongpassword"

        sut.login()

        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNil(sut.loggedInUser)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: Logout

    func test_logout_clearsUserAndCredentials() async throws {
        let sut = LoginViewModel(authService: SucceedingAuthService())
        sut.email = "test@example.com"
        sut.password = "anypassword"

        sut.login()
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.loggedInUser)

        sut.logout()

        XCTAssertNil(sut.loggedInUser)
        XCTAssertTrue(sut.email.isEmpty)
        XCTAssertTrue(sut.password.isEmpty)
    }
}

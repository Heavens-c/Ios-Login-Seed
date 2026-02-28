import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        Group {
            if let user = viewModel.loggedInUser {
                HomeView(user: user, onLogout: viewModel.logout)
            } else {
                LoginView(viewModel: viewModel)
            }
        }
        .animation(.easeInOut, value: viewModel.loggedInUser)
    }
}

// MARK: - Simple Home View shown after successful login

private struct HomeView: View {
    let user: User
    let onLogout: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.green)

                Text("Hello, \(user.displayName)!")
                    .font(.title.bold())

                Text(user.email)
                    .foregroundStyle(.secondary)

                Button("Log Out", role: .destructive, action: onLogout)
                    .padding(.top, 32)
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    ContentView()
}

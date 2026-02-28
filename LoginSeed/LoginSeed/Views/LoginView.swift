import SwiftUI

struct LoginView: View {

    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                // MARK: Logo / Title
                VStack(spacing: 8) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.tint)

                    Text("Welcome Back")
                        .font(.largeTitle.bold())

                    Text("Sign in to continue")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                // MARK: Form
                VStack(spacing: 16) {
                    // Email field
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Email")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("you@example.com", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .padding(12)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    // Password field
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Password")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        HStack {
                            Group {
                                if viewModel.isPasswordVisible {
                                    TextField("••••••••", text: $viewModel.password)
                                } else {
                                    SecureField("••••••••", text: $viewModel.password)
                                }
                            }
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)

                            Button {
                                viewModel.isPasswordVisible.toggle()
                            } label: {
                                Image(systemName: viewModel.isPasswordVisible
                                      ? "eye.slash.fill" : "eye.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(12)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    // Error message
                    if let errorMessage = viewModel.errorMessage {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.circle.fill")
                            Text(errorMessage)
                                .font(.footnote)
                        }
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    // Login button
                    Button(action: viewModel.login) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                                    .padding(.trailing, 4)
                            }
                            Text("Sign In")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(14)
                        .background(viewModel.isLoginButtonEnabled
                                    ? Color.accentColor : Color.gray)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!viewModel.isLoginButtonEnabled || viewModel.isLoading)
                }
                .padding(.horizontal, 24)

                Spacer()
            }
            .navigationTitle("")
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
}

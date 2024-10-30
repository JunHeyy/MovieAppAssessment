import SwiftUI

struct WelcomeBackView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String? = nil
    
    // Create an instance of HashingService
    private let hashingService = HashingService()
    @StateObject private var authViewModel = AuthViewModel() // Use StateObject to manage auth state

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.blue)
                        .font(.title)
                }
                .padding(.leading)

                Spacer()
            }
            .padding(.top, 20)
            Spacer()

            Text("Welcome back! 👋")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
                .padding(.top, 50)

            Text("I am so happy to see you again. You can continue to login for more features.")
                .font(.body)
                .multilineTextAlignment(.center)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Spacer()

            Button(action: {
                signIn()
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            // Display error message if exists
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            HStack {
                Text("Don't have an account?")
                Button(action: {
                    print("Not implemented")
                }) {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .padding()
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $authViewModel.isLoggedIn) {
            MovieListView() // Navigate to MovieListView upon successful login
        }
    }

    private func signIn() {
        let hashedPassword = hashingService.hashPassword(password: password)

        authViewModel.signIn(email: email, password: hashedPassword) { result in
            switch result {
            case .success:
                authViewModel.isLoggedIn = true
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}

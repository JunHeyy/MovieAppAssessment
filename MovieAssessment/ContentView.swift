import SwiftUI
import Lottie

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel() // Create an instance of AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                LottieView(animation: .named("popcorn"))
                    .playbackMode(.playing(.toProgress(1, loopMode: .loop)))

                Text("Access more with an Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)

                Text("Login to an account so you could access more features")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 40)

                if authViewModel.isLoggedIn {
                    // User is logged in
                    Text("Welcome back, \(authViewModel.username)!")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding()

                    NavigationLink(destination: MovieListView()) {
                        Text("Go to Movies")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.headline)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                } else {
                    // User is not logged in
                    NavigationLink(destination: WelcomeBackView()) {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .font(.headline)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    Button(action: {
                        // Handle sign-up action here
                        // You can navigate to a Sign Up View here if needed
                    }) {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                            .font(.headline)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
    }
}

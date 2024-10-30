import Foundation
import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var username: String = ""
    private var authHandle: AuthStateDidChangeListenerHandle?
    let defaultUsername = "vvvbb"

    init() {
        // Add listener for authentication state changes
        authHandle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in
                self.isLoggedIn = true
                // Fetch the user's display name
                self.username = user.displayName ?? self.defaultUsername
            } else {
                self.isLoggedIn = false
                self.username = "" // Clear username when logged out
            }
        }
    }

    deinit {
        // Remove the listener when the view model is deallocated
        if let handle = authHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                // Update username after successful login
                if let user = result?.user {
                    self.username = user.displayName ?? self.defaultUsername
                }
                completion(.success(()))
            }
        }
    }
}

import SwiftUI
import FirebaseAuth

@MainActor
final class AuthenticationStateManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentView: AuthenticationView = .landing
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    private lazy var authService: AuthenticationService = {
        let service = AuthenticationService()
        setupAuthStateListener()
        return service
    }()
    
    enum AuthenticationView {
        case landing
        case signIn
        case signUp
        case main
    }
    
    init() {}
    
    deinit {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    private func setupAuthStateListener() {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            self.isAuthenticated = user != nil
            self.authService.user = user
            if user != nil {
                self.currentView = .main
            } else {
                self.currentView = .landing
            }
        }
    }
    
    func signOut() {
        do {
            try authService.signOut()
            isAuthenticated = false
            currentView = .landing
        } catch {
            print("Error signing out: \(error)")
        }
    }
    
    func checkAuthenticationState() {
        if let currentUser = Auth.auth().currentUser {
            self.authService.user = currentUser
            self.isAuthenticated = true
            self.currentView = .main
        } else {
            self.isAuthenticated = false
            self.currentView = .landing
        }
    }
    
    func getAuthService() -> AuthenticationService {
        return authService
    }
}

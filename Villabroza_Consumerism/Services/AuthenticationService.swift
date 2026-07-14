@preconcurrency import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthenticationService: ObservableObject, Sendable {
    @Published var user: User?
    @Published var errorMessage: String?
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    func signIn(username: String, password: String) async throws {
        do {
            // Convert username to the same email format used in signUp
            let email = "\(username.lowercased())@buyless.app"
            let authResult = try await auth.signIn(withEmail: email, password: password)
            self.user = authResult.user
        } catch {
            self.errorMessage = error.localizedDescription
            throw error
        }
    }
    
    func signUp(username: String, password: String) async throws {
        do {
            
            let email = "\(username.lowercased())@buyless.app"
            let authResult = try await auth.createUser(withEmail: email, password: password)
            let userId = authResult.user.uid
            
            // Store additional user information in Firestore
            try await db.collection("users").document(userId).setData([
                "name": username,
                "createdAt": Date()
            ])
            
            self.user = authResult.user
        } catch {
            self.errorMessage = error.localizedDescription
            throw error
        }
    }
    
    func signOut() throws {
        try auth.signOut()
        self.user = nil
    }
    
    func getCurrentUser() -> User? {
        return auth.currentUser
    }
    
    func getUserData(userId: String) async throws -> [String: Any]? {
        let document = try await db.collection("users").document(userId).getDocument()
        return document.data()
    }
}

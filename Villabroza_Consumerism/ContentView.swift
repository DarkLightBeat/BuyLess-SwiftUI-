//
//  ContentView.swift
//  Villabroza_Consumerism
//
//  Created by STUDENT on 10/28/25.
//

import SwiftData
import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    @EnvironmentObject var spendingTracker: SpendingTracker
    @EnvironmentObject private var authStateManager: AuthenticationStateManager
    @EnvironmentObject private var userProfileManager: UserProfileManager
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.87, green: 0.96, blue: 0.70),
                    Color(red: 0.66, green: 0.82, blue: 0.37)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                if authStateManager.isAuthenticated {
                    DashboardTabView(
                        onSignOut: {
                            authStateManager.signOut()
                            username = ""
                            password = ""
                            userProfileManager.userProfile.username = "" // Clear username on sign-out
                        }
                    )
                    .environmentObject(userProfileManager)
                } else {
                    switch authStateManager.currentView {
                    case .landing:
                        LandingView(
                            onSignInTapped: { authStateManager.currentView = .signIn },
                            onSignUpTapped: { authStateManager.currentView = .signUp }
                        )
                    case .signIn:
                        SignInView(
                            username: $username,
                            password: $password,
                            onSignIn: handleSignIn,
                            onBack: { authStateManager.currentView = .landing }
                        )
                    case .signUp:
                        SignUpView(
                            username: $username,
                            password: $password,
                            confirmPassword: $confirmPassword,
                            onSignUp: handleSignUp,
                            onBack: { authStateManager.currentView = .landing }
                        )
                    case .main:
                        EmptyView()
                    }
                }
            }
        }
        .alert("BuyLess", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    func handleSignIn() {
        if username.isEmpty || password.isEmpty {
            alertMessage = "Please fill in all fields"
            showAlert = true
            return
        }
        Task {
            do {
                let email = "\(username.lowercased())@buyless.app"
                let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
                authStateManager.isAuthenticated = true
                // Fetch username from Firestore using UID
                let uid = authResult.user.uid
                let db = Firestore.firestore()
                let doc = try await db.collection("users").document(uid).getDocument()
                if let data = doc.data(), let fetchedUsername = data["name"] as? String {
                    userProfileManager.userProfile.username = fetchedUsername
                } else {
                    // If missing or insufficient permission, fallback to Auth displayName or entered username
                    if let displayName = authResult.user.displayName, !displayName.isEmpty {
                        userProfileManager.userProfile.username = displayName
                    } else {
                        userProfileManager.userProfile.username = username
                    }
                }
            } catch {
                if let authError = error as NSError?,
                   let errorCode = AuthErrorCode(rawValue: authError.code),
                   errorCode == .userNotFound ||
                   errorCode == .wrongPassword ||
                   errorCode == .invalidEmail {
                    alertMessage = "Incorrect username or password. Please try again."
                } else if let authError = error as NSError?, authError.domain == "FirestoreErrorDomain" || authError.localizedDescription.contains("permission") {
                    alertMessage = "Missing or insufficient Firestore permission. Please check your Firestore rules."
                } else {
                    alertMessage = error.localizedDescription
                }
                showAlert = true
            }
        }
    }
    
    func handleSignUp() {
        if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            alertMessage = "Please fill in all fields"
            showAlert = true
        } else if password != confirmPassword {
            alertMessage = "Passwords do not match"
            showAlert = true
        } else if password.count < 8 {
            alertMessage = "Password must be at least 8 characters"
            showAlert = true
        } else {
            Task {
                do {
                    let authService = authStateManager.getAuthService()
                    try await authService.signUp(username: username, password: password)
                    authStateManager.isAuthenticated = true
                    // Save username to Firestore and set in UserProfileManager
                    if let user = Auth.auth().currentUser {
                        let db = Firestore.firestore()
                        do {
                            try await db.collection("users").document(user.uid).setData([
                                "name": username,
                                "createdAt": Date()
                            ], merge: true)
                            userProfileManager.userProfile.username = username
                        } catch {
                            // If missing or insufficient permission, fallback to Auth displayName or entered username
                            if let displayName = user.displayName, !displayName.isEmpty {
                                userProfileManager.userProfile.username = displayName
                            } else {
                                userProfileManager.userProfile.username = username
                            }
                            alertMessage = "Missing or insufficient Firestore permission. Please check your Firestore rules."
                            showAlert = true
                        }
                    }
                } catch {
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationStateManager())
        .environmentObject(UserProfileManager(username: "PreviewUser"))
}

//
//  Villabroza_ConsumerismApp.swift
//  Villabroza_Consumerism
//
//  Created by STUDENT on 10/28/25.
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct Villabroza_ConsumerismApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authStateManager = AuthenticationStateManager()
    @StateObject private var spendingTracker = SpendingTracker()
    @StateObject private var userProfileManager = UserProfileManager(username: "User") // Replace "User" with actual username if available
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            UserProfile.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(authStateManager)
                    .environmentObject(spendingTracker)
                    .environmentObject(userProfileManager)
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                spendingTracker.refreshDailyChallengeIfNeeded()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}

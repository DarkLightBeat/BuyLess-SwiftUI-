import SwiftUI

struct DashboardTabView: View {
    @State private var selectedTab = 1  // Home tab as default
    @State private var showingSettings = false
    let onSignOut: () -> Void
    @EnvironmentObject var userProfileManager: UserProfileManager
    @EnvironmentObject var spendingTracker: SpendingTracker
    
    var body: some View {
        TabView(selection: $selectedTab) {
            UrgeJournalView(onSignOut: onSignOut)
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Journal")
                }
                .tag(0)
            
            HomeView(
                showSettings: $showingSettings,
                onSignOut: onSignOut
            )
            .environmentObject(userProfileManager)
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(1)
            
            CalendarTrackerView(onSignOut: onSignOut)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(2)
        }
        .accentColor(Color(red: 0.30, green: 0.36, blue: 0.13))
        .sheet(isPresented: $showingSettings) {
            SettingsView(
                onSignOut: onSignOut
            )
            .environmentObject(userProfileManager)
        }
    }
}

struct DashboardTabView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardTabView(onSignOut: {})
            .environmentObject(UserProfileManager(username: "PreviewUser"))
    }
}

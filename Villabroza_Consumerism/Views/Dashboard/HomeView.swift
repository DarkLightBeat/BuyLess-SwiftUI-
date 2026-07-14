import SwiftUI

enum DayType {
    case noSpend, spend
}

struct HomeView: View {
    @EnvironmentObject var userProfileManager: UserProfileManager
    @Binding var showSettings: Bool
    @EnvironmentObject var spendingTracker: SpendingTracker
    let onSignOut: () -> Void
    @State private var challengeCompleted = false
    @State private var selectedDayType: DayType? = nil {
        didSet {
            if let type = selectedDayType {
                spendingTracker.markDay(Date(), as: type)
                spendingTracker.saveCalendarDataToFirestore()
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.87, green: 0.96, blue: 0.70)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header with profile
                    HomeHeaderView(showingSettings: $showSettings)
                        .environmentObject(userProfileManager)
                    
                    // Today's Challenge Card
                    ChallengeSectionView(challengeCompleted: $challengeCompleted)
                    
                    // Stats Cards
                    StatsSectionView()
                    
                    // How did today go section
                    DayTrackingSectionView(selectedDayType: $selectedDayType)
                    
                    // Challenge Progress Card
                    ChallengeProgressView()
                }
            }
        }
    }
}

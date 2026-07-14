import SwiftUI

struct CalendarTrackerView: View {
    let onSignOut: () -> Void
    @State private var selectedDate = Date()
    @EnvironmentObject var spendingTracker: SpendingTracker
    
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
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    CalendarHeaderView()
                    
                    // Stats Cards
                    CalendarStatsView()
                    
                    // Calendar Card
                    let monthSpendingData = spendingTracker.getDaysForMonth(selectedDate)
                    CalendarCardView(
                        selectedDate: $selectedDate,
                        spendDays: monthSpendingData.spend,
                        noSpendDays: monthSpendingData.noSpend
                    )
                    
                    // Legend
                    CalendarLegendView()
                    
                    // Money Saved
                    MoneySavedView(spendingTracker: spendingTracker)
                }
            }
        }
        .onAppear {
            spendingTracker.loadCalendarDataFromFirestore() {}
            spendingTracker.fetchMonthlySavings { _ in }
        }
    }
}

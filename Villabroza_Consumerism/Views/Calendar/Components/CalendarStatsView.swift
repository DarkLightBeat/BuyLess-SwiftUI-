import SwiftUI

struct CalendarStatsView: View {
    @EnvironmentObject var spendingTracker: SpendingTracker
    
    var body: some View {
        HStack(spacing: 12) {
            // No-spent days card
            statsCard(
                number: "\(spendingTracker.stats.noSpendCount)",
                label: "no-spent days",
                backgroundColor: Color(red: 0.05, green: 0.75, blue: 0.12)
            )
            
            // Spent days card
            statsCard(
                number: "\(spendingTracker.stats.spendCount)",
                label: "spent days",
                backgroundColor: Color(red: 1.0, green: 0.27, blue: 0.27)
            )
            
            // Best streak card
            statsCard(
                number: "\(spendingTracker.stats.bestStreak)",
                label: "best streak",
                backgroundColor: Color(red: 0.27, green: 0.30, blue: 1.0)
            )
        }
        .padding(.horizontal)
    }
    
    private func statsCard(number: String, label: String, backgroundColor: Color) -> some View {
        VStack(spacing: 4) {
            Text(number)
                .font(.custom("Poppins-Bold", size: 32))
                .foregroundColor(.white)
            Text(label)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 90)
        .padding(.vertical, 8)
        .background(backgroundColor)
        .cornerRadius(16)
        .shadow(radius: 2)
    }
}

import SwiftUI

struct StatsSectionView: View {
    @EnvironmentObject var spendingTracker: SpendingTracker
    
    var body: some View {
        HStack(spacing: 16) {
            // Current Streak Card
            VStack(spacing: 8) {
                Text("\(spendingTracker.currentStreak)")
                    .font(.custom("Poppins-Bold", size: 32))
                    .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                Text("Current Streak!")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.white)
            .cornerRadius(20)
            .shadow(radius: 2)
            
            // Daily Savings Card
            VStack(spacing: 8) {
                Text("₱\(spendingTracker.dailySavings)")
                    .font(.custom("Poppins-Bold", size: 32))
                    .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                Text("Today's Savings")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.white)
            .cornerRadius(20)
            .shadow(radius: 2)
        }
        .padding(.horizontal)
    }
}

import SwiftUI

struct ChallengeProgressView: View {
    @EnvironmentObject var spendingTracker: SpendingTracker
    
    private var progressData: (current: Int, total: Int, progress: Double) {
        let dayNumber = spendingTracker.getDayNumber(for: Date()) ?? 1
        let cycleDay = ((dayNumber - 1) % 30) + 1 // Convert to 1-30 range
        
        // Get the number of days in the current month
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: Date())
        let daysInMonth = range?.count ?? 30
        
        let progress = Double(cycleDay) / Double(daysInMonth)
        return (cycleDay, daysInMonth, progress)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Challenge Progress")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                Spacer()
                Text("\(progressData.current)/\(progressData.total) days")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 0.18, green: 0.65, blue: 0.15))
                        .frame(width: geometry.size.width * progressData.progress, height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(Color(red: 0.93, green: 0.98, blue: 0.90))
        .cornerRadius(16)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

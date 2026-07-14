import SwiftUI

struct MoneySavedView: View {
    @ObservedObject var spendingTracker: SpendingTracker
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Money Saved This Month")
                .font(.custom("Poppins-Regular", size: 16))
                .foregroundColor(.white)
            
            Text("₱\(String(format: "%.2f", spendingTracker.monthlySavings))")
                .font(.custom("Poppins-Bold", size: 32))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.39, green: 0.78, blue: 0.38),
                    Color(red: 0.27, green: 0.69, blue: 0.25)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(16)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

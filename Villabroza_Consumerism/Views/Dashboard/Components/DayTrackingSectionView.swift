import SwiftUI

struct DayTrackingSectionView: View {
    @Binding var selectedDayType: DayType?
    @EnvironmentObject var spendingTracker: SpendingTracker
    
    var body: some View {
        VStack(spacing: 16) {
            Text("How did today go?")
                .font(.custom("Poppins-Bold", size: 24))
                .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 12) {
                Button(action: {
                    if selectedDayType != .noSpend {
                        selectedDayType = .noSpend
                        spendingTracker.markDay(Date(), as: .noSpend)
                    }
                }) {
                    Text("No-spent day")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(selectedDayType == .noSpend ? .white : Color(red: 0.18, green: 0.65, blue: 0.15))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(selectedDayType == .noSpend ? Color(red: 0.18, green: 0.65, blue: 0.15) : .white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 0.18, green: 0.65, blue: 0.15), lineWidth: 1)
                        )
                }
                
                Button(action: {
                    if selectedDayType != .spend {
                        selectedDayType = .spend
                        spendingTracker.markDay(Date(), as: .spend)
                    }
                }) {
                    Text("I spent today")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(selectedDayType == .spend ? .white : Color(red: 1.0, green: 0.5, blue: 0.5))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(selectedDayType == .spend ? Color(red: 1.0, green: 0.5, blue: 0.5) : .white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 1.0, green: 0.5, blue: 0.5), lineWidth: 1)
                        )
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            // Initialize the selected day type from the spending tracker
            selectedDayType = spendingTracker.getDayType(for: Date())
        }
    }
}

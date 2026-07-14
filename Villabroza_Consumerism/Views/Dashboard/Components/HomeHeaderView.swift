import SwiftUI

struct HomeHeaderView: View {
    @EnvironmentObject var userProfileManager: UserProfileManager
    @Binding var showingSettings: Bool
    @State private var dayCount: Int = 1
    
    private func calculateDays() -> Int {
        let defaults = UserDefaults.standard
        if let startDate = defaults.object(forKey: "journeyStartDate") as? Date {
            let days = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
            return days + 1 // Add 1 to start from Day 1
        } else {
            // First time user logs in, set the start date
            defaults.set(Date(), forKey: "journeyStartDate")
            return 1
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    if let image = userProfileManager.loadProfileImage() {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    } else {
                        BuyLessLogoView(size: 48)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hello, \(userProfileManager.userProfile.username)!")
                            .font(.custom("Poppins-Bold", size: 32))
                            .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                        
                        Text("Day \(dayCount) of your journey")
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
                    }
                }
            }
            
            Spacer()
            
            Button(action: { showingSettings = true }) {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 48, height: 48)
                        .shadow(radius: 2)
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 16)
        .onAppear {
            dayCount = calculateDays()
        }
    }
}

import SwiftUI

struct CalendarHeaderView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            HStack {
                BuyLessLogoView(size: 48)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Calendar Tracker")
                        .font(.custom("Poppins-Bold", size: 32))
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                    
                    Text("track your no-spend journey")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top)
    }
}
import SwiftUI

struct ButtonSettingView: View {
    var title: String
    var icon: String
    
    var body: some View {
        Button(action: {
            // Handle button action
        }) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                
                Text(title)
                    .font(.custom("Poppins-Regular", size: 16))
                    .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
    }
}

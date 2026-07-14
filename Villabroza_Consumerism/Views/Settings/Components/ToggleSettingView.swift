import SwiftUI

struct ToggleSettingView: View {
    var title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("Poppins-Regular", size: 16))
                .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.30, green: 0.36, blue: 0.13)))
                .frame(width: 50, height: 30)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
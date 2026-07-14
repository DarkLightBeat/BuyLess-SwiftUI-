import SwiftUI

struct CalendarLegendView: View {
    var body: some View {
        HStack(spacing: 16) {
            legendItem(color: Color(red: 0.43, green: 1.0, blue: 0.51),
                      borderColor: Color(red: 0.18, green: 0.65, blue: 0.14),
                      text: "No-spend")
            
            legendItem(color: Color(red: 1.0, green: 0.5, blue: 0.5),
                      borderColor: Color(red: 0.99, green: 0.17, blue: 0.17),
                      text: "Spend Day")
            
            legendItem(color: Color(red: 0.91, green: 0.91, blue: 0.91),
                      text: "Future")
            
            Spacer()
        }
        .padding()
        .background(.white)
        .cornerRadius(16)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
    
    private func legendItem(color: Color, borderColor: Color? = nil, text: String) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 24, height: 24)
                .overlay(
                    Circle()
                        .stroke(borderColor ?? .clear, lineWidth: borderColor == nil ? 0 : 1)
                )
            
            Text(text)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
        }
    }
}
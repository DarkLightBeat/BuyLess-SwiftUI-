import SwiftUI

struct ReflectionCardView: View {
    @Binding var showingNewEntry: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Reflection")
                .font(.custom("Poppins-Bold", size: 20))
                .foregroundColor(.white)
            
            Text("\"What emotions am I trying to fill with shopping? What else could satisfy this feeling?\"")
                .font(.custom("Poppins-Regular", size: 16))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.66, green: 0.82, blue: 0.37))
                .cornerRadius(12)
            
            Button(action: { showingNewEntry = true }) {
                Text("Reflect Now")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.white)
                    .cornerRadius(12)
            }
        }
        .padding(20)
        .background(Color(red: 0.30, green: 0.36, blue: 0.13))
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
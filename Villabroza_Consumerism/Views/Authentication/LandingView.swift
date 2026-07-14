import SwiftUI

struct LandingView: View {
    var onSignInTapped: () -> Void
    var onSignUpTapped: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.87, green: 0.96, blue: 0.70),
                    Color(red: 0.66, green: 0.82, blue: 0.37)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                BuyLessLogoView(size: 120)
                
                Text("BuyLess")
                    .font(.custom("Poppins-Bold", size: 40))
                    .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                
                Text("A simpler life is one tap away")
                    .font(.custom("Poppins-Regular", size: 20))
                    .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                
                Spacer()
                
                VStack(spacing: 15) {
                    Button(action: onSignInTapped) {
                        Text("SIGN IN")
                            .font(.custom("Poppins-Bold", size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color(red: 0.30, green: 0.36, blue: 0.13))
                            .cornerRadius(10)
                    }
                    
                    Button(action: onSignUpTapped) {
                        Text("SIGN UP")
                            .font(.custom("Poppins-Bold", size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color(red: 0.30, green: 0.36, blue: 0.13))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            }
        }
    }
}
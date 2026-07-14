import SwiftUI

struct SignInView: View {
    @Binding var username: String
    @Binding var password: String
    var onSignIn: () -> Void
    var onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            BuyLessLogoView(size: 80)
            
            Text("BuyLess")
                .font(.custom("Poppins-Bold", size: 32))
                .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
            
            Text("A simpler life is one tap away")
                .font(.custom("Poppins-Regular", size: 20))
                .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
            
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Username")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                    TextField("", text: $username)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                    SecureField("", text: $password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            VStack(spacing: 15) {
                Button(action: onSignIn) {
                    Text("SIGN IN")
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color(red: 0.30, green: 0.36, blue: 0.13))
                        .cornerRadius(10)
                }
                
                Button(action: onBack) {
                    Text("Back")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 50)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.87, green: 0.96, blue: 0.70),
                    Color(red: 0.66, green: 0.82, blue: 0.37)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

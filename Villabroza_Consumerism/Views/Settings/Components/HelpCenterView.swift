import SwiftUI

struct HelpCenterView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 24))
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Help Center")
                        .font(.custom("Poppins-Bold", size: 28))
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                    
                    Text("Get answers and support")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            // FAQ Section
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Frequently Ask Questions")
                        .font(.custom("Poppins-Bold", size: 20))
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                    
                    VStack(spacing: 16) {
                        FaqItem(
                            question: "How do I start my first no-spend challenge?",
                            answer: "Go to your dashboard and tap 'Start Challenge'. Choose your duration and set your goals."
                        )
                        
                        FaqItem(
                            question: "What counts as breaking a spending streak?",
                            answer: "Any non-essential purchase breaks your streak. Essential items like groceries and bills don't count."
                        )
                        
                        FaqItem(
                            question: "How do I track my savings?",
                            answer: "Use the calendar tracker to log avoided purchases and see your total savings grow."
                        )
                        
                        FaqItem(
                            question: "Can I customize my daily challenges?",
                            answer: "Yes! Go to settings > App Settings to adjust challenge difficulty and frequency."
                        )
                    }
                }
                .padding(24)
                .background(.white)
                .cornerRadius(32)
                .padding(.horizontal)
            }
        }
        .background(Color(red: 0.87, green: 0.96, blue: 0.70))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct FaqItem: View {
    let question: String
    let answer: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(question)
                .font(.custom("Poppins-Bold", size: 16))
                .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
            Text(answer)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.95, green: 0.98, blue: 0.90))
        .cornerRadius(16)
    }
}

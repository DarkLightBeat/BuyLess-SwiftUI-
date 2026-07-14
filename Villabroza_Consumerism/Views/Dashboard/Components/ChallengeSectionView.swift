import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ChallengeSectionView: View {
    @EnvironmentObject var spendingTracker: SpendingTracker
    @Binding var challengeCompleted: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Today's Challenge")
                .font(.custom("Poppins-Bold", size: 24))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(spendingTracker.currentDailyMessage.challenge)
                .font(.custom("Poppins-Regular", size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 4) {
                Text("\"\(spendingTracker.currentDailyMessage.quote)\"")
                    .font(.custom("Poppins-Regular", size: 16))
                    .foregroundColor(.white)
                Text("- \(spendingTracker.currentDailyMessage.author)")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(red: 0.66, green: 0.82, blue: 0.37))
            .cornerRadius(12)
            
            Button(action: {
                challengeCompleted.toggle()
                // Save daily challenge savings to Firestore
                if let user = Auth.auth().currentUser {
                    let db = Firestore.firestore()
                    let savingsAmount = spendingTracker.dailySavings // Use today's savings from SpendingTracker
                    let savingsData: [String: Any] = [
                        "amount": savingsAmount,
                        "date": Timestamp(date: Date())
                    ]
                    db.collection("users").document(user.uid)
                        .collection("dailySavings").addDocument(data: savingsData) { error in
                            if let error = error {
                                print("Error saving daily savings: \(error.localizedDescription)")
                            } else {
                                print("Daily savings saved successfully.")
                            }
                        }
                    }
                }) {
                    Text("Mark As Complete")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.white.opacity(0.2))
                        .cornerRadius(12)
                }
            }
            .padding(24)
            .background(Color(red: 0.30, green: 0.36, blue: 0.13))
            .cornerRadius(24)
            .shadow(radius: 5)
            .padding(.horizontal)
        }
    }


import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct NewUrgeEntryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var itemName = ""
    @State private var cost = ""
    @State private var trigger = ""
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    let onSave: (UrgeEntry) -> Void
    let onCancel: () -> Void
    
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
            .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 24) {
                Text("New Urge Entries")
                    .font(.custom("Poppins-Bold", size: 24))
                    .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                
                VStack(alignment: .leading, spacing: 20) {
                    // Item field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What did you buy today?")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                        TextField("", text: $itemName)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Color.white)
                            .cornerRadius(24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color(red: 0.43, green: 0.55, blue: 0.17), lineWidth: 1)
                            )
                    }
                    
                    // Cost field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How much would it cost?")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                        TextField("", text: $cost)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Color.white)
                            .cornerRadius(24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color(red: 0.43, green: 0.55, blue: 0.17), lineWidth: 1)
                            )
                    }
                    
                    // Trigger field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What trigger this urge?")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                        TextField("", text: $trigger)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Color.white)
                            .cornerRadius(24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color(red: 0.43, green: 0.55, blue: 0.17), lineWidth: 1)
                            )
                    }
                }
                
                // Action Buttons
                HStack(spacing: 12) {
                    Button(action: onCancel) {
                        Text("Cancel")
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(.white)
                            .cornerRadius(24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color(red: 0.43, green: 0.55, blue: 0.17), lineWidth: 1)
                            )
                    }
                    
                    Button(action: {
                        guard let user = Auth.auth().currentUser else {
                            errorMessage = "You must be signed in to save entries."
                            showErrorAlert = true
                            return
                        }
                        let entry = UrgeEntry(
                            title: itemName,
                            cost: cost,
                            trigger: trigger,
                            date: Date()
                        )
                        // Save to Firestore
                        let db = Firestore.firestore()
                        let entryData: [String: Any] = [
                            "title": entry.title,
                            "cost": entry.cost,
                            "trigger": entry.trigger,
                            "date": Timestamp(date: entry.date)
                        ]
                        db.collection("users").document(user.uid).collection("urgeEntries").addDocument(data: entryData) { error in
                            if let error = error {
                                errorMessage = "Error saving urge entry: \(error.localizedDescription)"
                                showErrorAlert = true
                            } else {
                                onSave(entry)
                            }
                        }
                    }) {
                        Text("Save Entry")
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(red: 0.18, green: 0.65, blue: 0.15))
                            .cornerRadius(24)
                    }
                }
            }
            .padding(24)
            .background(.white)
            .cornerRadius(32)
            .frame(maxWidth: min(UIScreen.main.bounds.width * 0.9, 400))
            .fixedSize(horizontal: false, vertical: true)
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Save Failed"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

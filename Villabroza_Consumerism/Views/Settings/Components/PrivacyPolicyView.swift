import SwiftUI

struct PrivacyPolicyView: View {
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
                    Text("Privacy Policy")
                        .font(.custom("Poppins-Bold", size: 28))
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                    
                    Text("How we protect your data")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            ScrollView {
                VStack(spacing: 24) {
                    PolicySection(
                        title: "Information We Collect",
                        content: [
                            "Personal information you provide",
                            "Usage data and analytics",
                            "Device information",
                            "App interaction history"
                        ]
                    )
                    
                    PolicySection(
                        title: "How we use your information",
                        content: [
                            "Provide and improve our services",
                            "Send you notifications and reminders",
                            "Analyze app usage to enhance user experience",
                            "Provide customer support"
                        ]
                    )
                    
                    PolicySection(
                        title: "Data Security",
                        description: "We use industry-standard encryption to protect your data. Your personal information is stored securely and never shared with third parties without your consent."
                    )
                    
                    PolicySection(
                        title: "Your Rights",
                        content: [
                            "Access your personal data",
                            "Correct inaccurate information",
                            "Delete your account and data",
                            "Export your data"
                        ]
                    )
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

struct PolicySection: View {
    let title: String
    var content: [String]? = nil
    var description: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.custom("Poppins-Bold", size: 20))
                .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
            
            if let content = content {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(content, id: \.self) { item in
                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                            Text(item)
                        }
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
                    }
                }
            }
            
            if let description = description {
                Text(description)
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.95, green: 0.98, blue: 0.90))
        .cornerRadius(16)
    }
}

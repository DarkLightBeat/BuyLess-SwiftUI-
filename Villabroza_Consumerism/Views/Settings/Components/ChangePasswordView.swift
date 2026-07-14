import SwiftUI
import FirebaseAuth

struct ChangePasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showCurrentPassword = false
    @State private var showNewPassword = false
    @State private var showConfirmPassword = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
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
                    Text("Change Password")
                        .font(.custom("Poppins-Bold", size: 28))
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                    
                    Text("Update your account security")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            VStack(spacing: 20) {
                // Current Password
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Password")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                    
                    HStack {
                        if showCurrentPassword {
                            TextField("", text: $currentPassword)
                                .textContentType(.password)
                        } else {
                            SecureField("", text: $currentPassword)
                                .textContentType(.password)
                        }
                        
                        Button(action: { showCurrentPassword.toggle() }) {
                            Image(systemName: showCurrentPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color(red: 0.43, green: 0.55, blue: 0.17), lineWidth: 1)
                    )
                }
                
                // New Password
                VStack(alignment: .leading, spacing: 8) {
                    Text("New Password")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                    
                    HStack {
                        if showNewPassword {
                            TextField("", text: $newPassword)
                                .textContentType(.newPassword)
                        } else {
                            SecureField("", text: $newPassword)
                                .textContentType(.newPassword)
                        }
                        
                        Button(action: { showNewPassword.toggle() }) {
                            Image(systemName: showNewPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color(red: 0.43, green: 0.55, blue: 0.17), lineWidth: 1)
                    )
                }
                
                // Confirm New Password
                VStack(alignment: .leading, spacing: 8) {
                    Text("Confirm New Password")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                    
                    HStack {
                        if showConfirmPassword {
                            TextField("", text: $confirmPassword)
                                .textContentType(.newPassword)
                        } else {
                            SecureField("", text: $confirmPassword)
                                .textContentType(.newPassword)
                        }
                        
                        Button(action: { showConfirmPassword.toggle() }) {
                            Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color(red: 0.43, green: 0.55, blue: 0.17), lineWidth: 1)
                    )
                }
            }
            .padding(24)
            .background(.white)
            .cornerRadius(32)
            .padding(.horizontal)
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 12) {
                Button(action: validateAndChangePassword) {
                    Text("Save Changes")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.43, green: 0.55, blue: 0.17))
                        .cornerRadius(24)
                }
                
                Button(action: { dismiss() }) {
                    Text("Cancel")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.white)
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(red: 0.43, green: 0.55, blue: 0.17), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .background(Color(red: 0.87, green: 0.96, blue: 0.70))
        .edgesIgnoringSafeArea(.bottom)
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func validateAndChangePassword() {
        guard !currentPassword.isEmpty, !newPassword.isEmpty, !confirmPassword.isEmpty else {
            alertTitle = "Error"
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }
        guard newPassword == confirmPassword else {
            alertTitle = "Error"
            alertMessage = "New passwords do not match."
            showAlert = true
            return
        }
        guard newPassword.count >= 8 else {
            alertTitle = "Error"
            alertMessage = "Password must be at least 8 characters."
            showAlert = true
            return
        }
        guard let user = Auth.auth().currentUser, let email = user.email else {
            alertTitle = "Error"
            alertMessage = "No user is currently signed in."
            showAlert = true
            return
        }

        // Re-authenticate user
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        user.reauthenticate(with: credential) { result, error in
            if error != nil {
                alertTitle = "Error"
                alertMessage = "Current password is incorrect."
                showAlert = true
                return
            }
            // Change password
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    alertTitle = "Error"
                    alertMessage = error.localizedDescription
                    showAlert = true
                } else {
                    alertTitle = "Success"
                    alertMessage = "Password changed successfully."
                    showAlert = true
                    // Optionally dismiss after a short delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        dismiss()
                    }
                }
            }
        }
    }
}

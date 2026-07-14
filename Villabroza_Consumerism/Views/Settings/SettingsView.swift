import PhotosUI
import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userProfileManager: UserProfileManager
    @State private var showingEditProfile = false
    @State private var showingSignOutAlert = false
    @State private var showingHelpCenter = false
    @State private var showingPrivacyPolicy = false
    @State private var showingChangePassword = false
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var isLoadingProfile = false
    let onSignOut: () -> Void
    
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
                    Text("Settings")
                        .font(.custom("Poppins-Bold", size: 28))
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                    
                    Text("Customize your experience")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Profile Card
            VStack(spacing: 16) {
                if let image = userProfileManager.loadProfileImage() {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                } else {
                    Circle()
                        .fill(.white)
                        .frame(width: 80, height: 80)
                        .shadow(radius: 2)
                }
                
                VStack(spacing: 4) {
                    Text(userProfileManager.userProfile.username)
                        .font(.custom("Poppins-Bold", size: 20))
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                }
                
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Text("Change Profile Image")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(.white)
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(red: 0.43, green: 0.55, blue: 0.17), lineWidth: 1)
                        )
                }
                .onChange(of: selectedPhoto) { newItem in
                    guard let newItem else { return }
                    Task {
                        if let data = try? await newItem.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            userProfileManager.updateProfileImage(with: uiImage)
                        }
                    }
                }
                
                // Only Sign Out button remains
                Button(action: { showingSignOutAlert = true }) {
                    Text("Sign Out")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(.white)
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.red, lineWidth: 1)
                        )
                }
            }
            .padding(24)
            .background(.white)
            .cornerRadius(32)
            .padding(.horizontal)
            
            // Privacy & Security Section
            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy & Security")
                    .font(.custom("Poppins-Bold", size: 20))
                    .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                
                VStack(spacing: 16) {
                    // Help Center
                    Button(action: { showingHelpCenter = true }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Help Center")
                                    .font(.custom("Poppins-Bold", size: 16))
                                    .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                                Text("Get answers to common questions")
                                    .font(.custom("Poppins-Regular", size: 14))
                                    .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
                            }
                            Spacer()
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(16)
                    }
                    
                    // Privacy Policy
                    Button(action: { showingPrivacyPolicy = true }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Privacy Policy")
                                    .font(.custom("Poppins-Bold", size: 16))
                                    .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                                Text("View our privacy policy")
                                    .font(.custom("Poppins-Regular", size: 14))
                                    .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
                            }
                            Spacer()
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(16)
                    }
                    
                    // Change Password
                    Button(action: { showingChangePassword = true }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Change Password")
                                    .font(.custom("Poppins-Bold", size: 16))
                                    .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                                Text("Update your password")
                                    .font(.custom("Poppins-Regular", size: 14))
                                    .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
                            }
                            Spacer()
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(16)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color(red: 0.87, green: 0.96, blue: 0.70))
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(
                name: userProfileManager.userProfile.username,
                userID: "user_id_here",
                onSaveChanges: { newName, _ in
                    userProfileManager.userProfile.username = newName
                    showingEditProfile = false
                }
            )
        }
        .sheet(isPresented: $showingHelpCenter) {
            HelpCenterView()
        }
        .sheet(isPresented: $showingPrivacyPolicy) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showingChangePassword) {
            ChangePasswordView()
        }
        .alert("Sign Out", isPresented: $showingSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                dismiss()
                onSignOut()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
}

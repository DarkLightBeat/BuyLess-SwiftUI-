import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var username: String
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var profileImage: UIImage? = nil
    @State private var isUploading: Bool = false
    @State private var showConfirmation = false
    let userID: String
    let onSaveChanges: (String, String?) -> Void
    
    init(name: String, userID: String, onSaveChanges: @escaping (String, String?) -> Void) {
        _username = State(initialValue: name)
        self.userID = userID
        self.onSaveChanges = onSaveChanges
    }
    
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
                    Text("Edit Profile")
                        .font(.custom("Poppins-Bold", size: 28))
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                    
                    Text("Update your information")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Profile Image Section
            VStack(spacing: 16) {
                if let profileImage = profileImage {
                    Image(uiImage: profileImage)
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
                PhotosPicker(selection: $selectedItem, matching: .images) {
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
                .onChange(of: selectedItem) { newItem in
                    guard let newItem else { return }
                    Task {
                        if let data = try? await newItem.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            profileImage = uiImage
                        }
                    }
                }
            }
            // Username Field
            TextField("Username", text: $username)
                .font(.custom("Poppins-Regular", size: 18))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
            // Save Changes Button
            Button(action: { showConfirmation = true }) {
                Text("Save Changes")
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(red: 0.30, green: 0.36, blue: 0.13))
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            // Confirmation Dialog
            .confirmationDialog("Save changes to your profile?", isPresented: $showConfirmation, titleVisibility: .visible) {
                Button("Save", role: .none) {
                    onSaveChanges(username, nil)
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            }
            Spacer()
        }
        .padding(.top)
    }
    
    func uploadProfileImage(image: UIImage, completion: @escaping (String?) -> Void) {
        isUploading = true
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            isUploading = false
            completion(nil)
            return
        }
        let storageRef = Storage.storage().reference().child("profile_images/\(userID).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Upload error: \(error.localizedDescription)")
                isUploading = false
                completion(nil)
                return
            }
            storageRef.downloadURL { url, error in
                isUploading = false
                completion(url?.absoluteString)
            }
        }
    }
    
    func saveProfileToFirestore(username: String, imageURL: String?, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let data: [String: Any] = [
            "username": username,
            "profileImageURL": imageURL ?? ""
        ]
        db.collection("users").document(userID).setData(data, merge: true) { error in
            completion(error == nil)
        }
    }
}

import Foundation
import SwiftUI
import SwiftData

class UserProfileManager: ObservableObject {
    @Published var userProfile: UserProfile
    
    init(username: String) {
        // Load from SwiftData or create new
        // For demo, create new
        self.userProfile = UserProfile(username: username)
    }
    
    func updateProfileImage(with image: UIImage) {
        // Save image to local storage
        guard let data = image.pngData() else { return }
        let filename = UUID().uuidString + ".png"
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            try data.write(to: url)
            userProfile.profileImagePath = url.path
            objectWillChange.send()
        } catch {
            print("Error saving image: \(error)")
        }
    }
    
    func loadProfileImage() -> UIImage? {
        guard let path = userProfile.profileImagePath else { return nil }
        return UIImage(contentsOfFile: path)
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

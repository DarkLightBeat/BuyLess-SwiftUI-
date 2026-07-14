import Foundation
import SwiftData

@Model
class UserProfile {
    var id: UUID = UUID()
    var username: String
    var profileImagePath: String?
    
    init(username: String, profileImagePath: String? = nil) {
        self.username = username
        self.profileImagePath = profileImagePath
    }
}

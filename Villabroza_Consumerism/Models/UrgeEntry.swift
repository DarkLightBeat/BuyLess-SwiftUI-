import SwiftUI
import FirebaseFirestore

struct UrgeEntry: Identifiable, Codable {
    @DocumentID var id: String?
    var uid: String? // Firebase Auth UID
    var title: String
    var cost: String
    var trigger: String
    var date: Date
    var timeAgo: String {
        let interval = Date().timeIntervalSince(date)
        let seconds = Int(interval)
        let minutes = seconds / 60
        let hours = minutes / 60
        let days = hours / 24
        if seconds < 60 {
            return "Just now"
        } else if minutes < 60 {
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        } else if hours < 24 {
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        } else {
            return "\(days) day\(days == 1 ? "" : "s") ago"
        }
    }
}

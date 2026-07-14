import Foundation
import FirebaseFirestore
import FirebaseAuth

class SpendingTracker: ObservableObject {
    @Published var spendDays: Set<Date> = []
    @Published var noSpendDays: Set<Date> = []
    @Published var currentStreak: Int = 0
    @Published var bestStreak: Int = 0
    @Published var startDate: Date?
    @Published var dayNumber: Int = 1
    @Published var dailySavings: Int = 50  // Default value
    @Published var currentDailyMessage: DailyMessage
    @Published var monthlySavings: Double = 0.0 // Add published property for UI binding
    
    private let db = Firestore.firestore()
    private var userId: String? {
        // Replace with your actual user ID retrieval logic
        return UserDefaults.standard.string(forKey: "userId")
    }
    
    init() {
        currentDailyMessage = dailyMessages[0]  // Default message
        startDate = Date()
        // Only fetch today's challenge and savings from Firestore
        fetchOrCreateDailyChallengeAndSavings()
        startDayCounter()
    }
    
    private func startDayCounter() {
        // Calculate initial day number
        if let start = startDate {
            let calendar = Calendar.current
            let daysSinceStart = calendar.dateComponents([.day], from: calendar.startOfDay(for: start), to: calendar.startOfDay(for: Date()))
            dayNumber = (daysSinceStart.day ?? 0) + 1
        }
        // Set up timer for midnight updates
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            let calendar = Calendar.current
            let now = Date()
            if calendar.component(.hour, from: now) == 0 && calendar.component(.minute, from: now) == 0 {
                self?.dayNumber += 1
                // Only refresh daily challenge and savings after midnight
                self?.fetchOrCreateDailyChallengeAndSavings()
            }
        }
    }
    
    // Remove direct calls to generateDailySavings and generateDailyMessage for today's values
    func generateDailySavings() {
        // Deprecated: Do not use for today's savings, only for generating new daily entry in Firestore
        let steps = Int.random(in: 10...40)
        dailySavings = steps * 5
        UserDefaults.standard.set(dailySavings, forKey: "lastDailySavings")
    }
    
    func generateDailyMessage() {
        // Deprecated: Do not use for today's challenge, only for generating new daily entry in Firestore
        let randomIndex = Int.random(in: 0..<dailyMessages.count)
        currentDailyMessage = dailyMessages[randomIndex]
        UserDefaults.standard.set(randomIndex, forKey: "lastDailyMessageIndex")
    }
    
    func markDay(_ date: Date, as type: DayType) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        // Initialize start date if not set
        if startDate == nil {
            startDate = startOfDay
            dayNumber = 1
        }
        
        switch type {
        case .spend:
            spendDays.insert(startOfDay)
            noSpendDays.remove(startOfDay)
            currentStreak = 0
        case .noSpend:
            noSpendDays.insert(startOfDay)
            spendDays.remove(startOfDay)
            updateStreak()
        }
    }
    
    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Check if there's any spend day that would break the streak
        let hasSpendDayInStreak = spendDays.contains { date in
            date <= today
        }
        
        if hasSpendDayInStreak {
            currentStreak = 1
        } else {
            currentStreak += 1
            if currentStreak > bestStreak {
                bestStreak = currentStreak
            }
        }
    }
    
    var stats: (noSpendCount: Int, spendCount: Int, bestStreak: Int) {
        return (noSpendDays.count, spendDays.count, bestStreak)
    }
    
    func getDayType(for date: Date) -> DayType? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        if spendDays.contains(startOfDay) {
            return .spend
        } else if noSpendDays.contains(startOfDay) {
            return .noSpend
        }
        return nil
    }
    
    func getDayNumber(for date: Date) -> Int? {
        guard let startDate = startDate else { return nil }
        let calendar = Calendar.current
        let daysSinceStart = calendar.dateComponents([.day], from: calendar.startOfDay(for: startDate), to: calendar.startOfDay(for: date))
        return daysSinceStart.day.map { $0 + 1 }  // Add 1 to make it 1-based
    }
    
    func getDaysForMonth(_ date: Date) -> (spend: Set<Int>, noSpend: Set<Int>) {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else {
            return ([], [])
        }
        
        var spendDaysInMonth: Set<Int> = []
        var noSpendDaysInMonth: Set<Int> = []
        
        let startOfMonth = monthInterval.start
        let endOfMonth = monthInterval.end
        
        var currentDate = startOfMonth
        while currentDate < endOfMonth {
            let day = calendar.component(.day, from: currentDate)
            
            if spendDays.contains(currentDate) {
                spendDaysInMonth.insert(day)
            } else if noSpendDays.contains(currentDate) {
                noSpendDaysInMonth.insert(day)
            }
            
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            } else {
                break
            }
        }
        
        return (spendDaysInMonth, noSpendDaysInMonth)
    }
    
    func saveCalendarDataToFirestore() {
        guard let userId = userId else {
            print("[SpendingTracker] No userId found in UserDefaults. Calendar data not saved.")
            return
        }
        print("[SpendingTracker] Saving calendar data for userId: \(userId)")
        let spendDaysArray = spendDays.map { $0.timeIntervalSince1970 }
        let noSpendDaysArray = noSpendDays.map { $0.timeIntervalSince1970 }
        let data: [String: Any] = [
            "spendDays": spendDaysArray,
            "noSpendDays": noSpendDaysArray,
            "currentStreak": currentStreak,
            "bestStreak": bestStreak
        ]
        db.collection("calendarData").document(userId).setData(data) { error in
            if let error = error {
                print("[SpendingTracker] Error saving calendar data: \(error)")
            } else {
                print("[SpendingTracker] Calendar data saved successfully.")
            }
        }
    }
    
    func loadCalendarDataFromFirestore(completion: @escaping () -> Void) {
        guard let userId = userId else { completion(); return }
        db.collection("calendarData").document(userId).getDocument { [weak self] (document, error) in
            guard let self = self else { completion(); return }
            if let document = document, document.exists, let data = document.data() {
                if let spendDaysArray = data["spendDays"] as? [Double] {
                    self.spendDays = Set(spendDaysArray.map { Date(timeIntervalSince1970: $0) })
                }
                if let noSpendDaysArray = data["noSpendDays"] as? [Double] {
                    self.noSpendDays = Set(noSpendDaysArray.map { Date(timeIntervalSince1970: $0) })
                }
                self.currentStreak = data["currentStreak"] as? Int ?? 0
                self.bestStreak = data["bestStreak"] as? Int ?? 0
            }
            completion()
        }
    }
    
    // MARK: - Firestore-based daily challenge and savings
    func fetchOrCreateDailyChallengeAndSavings(completion: (() -> Void)? = nil) {
        // Use UTC date string as document ID
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let todayUTC = formatter.string(from: Date())
        let docRef = db.collection("dailyChallenges").document(todayUTC)
        docRef.getDocument { [weak self] (document, error) in
            guard let self = self else { completion?(); return }
            if let error = error {
                print("[Firestore] Error fetching daily challenge: \(error)")
                completion?()
                return
            }
            if let document = document, document.exists, let data = document.data() {
                if let savings = data["savings"] as? Int, let messageIndex = data["messageIndex"] as? Int, messageIndex < dailyMessages.count {
                    self.dailySavings = savings
                    self.currentDailyMessage = dailyMessages[messageIndex]
                    completion?()
                    return
                }
            }
            // Not present, generate and store
            let steps = Int.random(in: 10...40)
            let savings = steps * 5
            let messageIndex = Int.random(in: 0..<dailyMessages.count)
            let data: [String: Any] = [
                "savings": savings,
                "messageIndex": messageIndex
            ]
            docRef.setData(data) { err in
                if let err = err {
                    print("[Firestore] Error writing daily challenge: \(err)")
                } else {
                    print("[Firestore] Daily challenge saved successfully.")
                }
                self.dailySavings = savings
                self.currentDailyMessage = dailyMessages[messageIndex]
                completion?()
            }
        }
    }

    // Call this on app launch and on app foreground
    func refreshDailyChallengeIfNeeded() {
        fetchOrCreateDailyChallengeAndSavings()
    }
    
    func fetchMonthlySavings(completion: @escaping (Double) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(0.0)
            return
        }
        let db = Firestore.firestore()
        let calendar = Calendar.current
        let now = Date()
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)
        db.collection("users").document(user.uid)
            .collection("dailySavings")
            .getDocuments { snapshot, error in
                var total: Double = 0.0
                if let documents = snapshot?.documents {
                    for doc in documents {
                        if let amount = doc.data()["amount"] as? Double,
                           let timestamp = doc.data()["date"] as? Timestamp {
                            let date = timestamp.dateValue()
                            let month = calendar.component(.month, from: date)
                            let year = calendar.component(.year, from: date)
                            if month == currentMonth && year == currentYear {
                                total += amount
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.monthlySavings = total
                    completion(total)
                }
            }
    }
}

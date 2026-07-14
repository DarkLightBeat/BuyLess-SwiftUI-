import SwiftUI

struct CalendarCardView: View {
    @Binding var selectedDate: Date
    let spendDays: Set<Int>
    let noSpendDays: Set<Int>
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    private var monthInterval: DateInterval? {
        calendar.dateInterval(of: .month, for: selectedDate)
    }
    
    private var monthDays: [Date] {
        guard let monthInterval = monthInterval else { return [] }
        
        let startOfMonth = monthInterval.start
        let endOfMonth = monthInterval.end
        
        // Find first day of the week containing the start of month
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let offsetToStartOfWeek = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        guard let startDate = calendar.date(byAdding: .day, value: -offsetToStartOfWeek, to: startOfMonth) else {
            return []
        }
        
        var dates: [Date] = []
        var currentDate = startDate
        
        // Generate dates until we've included all days of the target month
        while currentDate < endOfMonth || calendar.component(.weekday, from: currentDate) != calendar.firstWeekday {
            dates.append(currentDate)
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            } else {
                break
            }
        }
        
        return dates
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Month navigation
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                }
                
                Text(dateFormatter.string(from: selectedDate))
                    .font(.custom("Poppins-Bold", size: 24))
                    .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                }
            }
            
            // Weekday headers
            HStack {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                    Text(day)
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
                ForEach(monthDays, id: \.self) { date in
                    if let interval = monthInterval,
                       calendar.isDate(date, equalTo: interval.start, toGranularity: .month) {
                        let day = calendar.component(.day, from: date)
                        Text("\(day)")
                            .font(.custom("Poppins-Regular", size: 16))
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(getDayColor(day: day))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(getDayBorderColor(day: day), lineWidth: 1)
                            )
                    } else {
                        Text("")
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                    }
                }
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(20)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
    
    private func previousMonth() {
        if let newDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func getDayColor(day: Int) -> Color {
        if noSpendDays.contains(day) {
            return Color(red: 0.43, green: 1.0, blue: 0.51)
        } else if spendDays.contains(day) {
            return Color(red: 1.0, green: 0.5, blue: 0.5)
        }
        return Color(red: 0.91, green: 0.91, blue: 0.91)
    }
    
    private func getDayBorderColor(day: Int) -> Color {
        if noSpendDays.contains(day) {
            return Color(red: 0.18, green: 0.65, blue: 0.14)
        } else if spendDays.contains(day) {
            return Color(red: 0.99, green: 0.17, blue: 0.17)
        }
        return .clear
    }
}

// Calendar extension to generate days
extension Calendar {
    func generateDays(for dateInterval: DateInterval) -> [Date] {
        var dates = [Date]()
        dates.reserveCapacity(42)
        
        enumerateDates(
            startingAfter: dateInterval.start - 1,
            matching: DateComponents(hour: 0, minute: 0, second: 0),
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date <= dateInterval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        return dates
    }
}

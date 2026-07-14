import SwiftUI
import Combine

struct UrgeEntryView: View {
    @State private var now = Date()
    let entry: UrgeEntry
    @State private var timerCancellable: AnyCancellable?

    var body: some View {
        VStack {
            Text(entry.title)
            Text(entry.timeAgo)
        }
        .onAppear {
            timerCancellable = Timer.publish(every: timerInterval(), on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    now = Date()
                }
        }
        .onDisappear {
            timerCancellable?.cancel()
        }
    }

    private func timerInterval() -> TimeInterval {
        let secondsAgo = Int(Date().timeIntervalSince(entry.date))
        return secondsAgo < 60 ? 1 : 60
    }
}

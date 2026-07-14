import SwiftUI

struct UrgeJournalView: View {
    let onSignOut: () -> Void
    @State private var showingNewEntry = false
    @State private var urgeEntries: [UrgeEntry] = []
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.87, green: 0.96, blue: 0.70),
                    Color(red: 0.66, green: 0.82, blue: 0.37)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    JournalHeaderView()
                    
                    // Today's Reflection Card
                    ReflectionCardView(showingNewEntry: $showingNewEntry)
                    
                    // Recent Urges List
                    RecentUrgesListView(urgeEntries: urgeEntries)
                }
                .padding(.bottom, 32)
            }
        }
        .sheet(isPresented: $showingNewEntry) {
            NewUrgeEntryView(onSave: { entry in
                urgeEntries.insert(entry, at: 0)
                showingNewEntry = false
            }, onCancel: {
                showingNewEntry = false
            })
        }
    }
}

struct UrgeJournalView_Previews: PreviewProvider {
    static var previews: some View {
        UrgeJournalView(onSignOut: {})
    }
}

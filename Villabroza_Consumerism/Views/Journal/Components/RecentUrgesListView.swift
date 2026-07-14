import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct RecentUrgesListView: View {
    let urgeEntries: [UrgeEntry]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Urges")
                .font(.custom("Poppins-Bold", size: 24))
                .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
            
            ForEach(urgeEntries.indices, id: \.self) { index in
                UrgeEntryCard(entry: urgeEntries[index])
            }
        }
        .padding(.horizontal)
    }
}

struct UrgeEntryCard: View {
    let entry: UrgeEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.title)
                    .font(.custom("Poppins-Bold", size: 17))
                    .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
                
                Spacer()
                
                Text(entry.cost)
                    .font(.custom("Poppins-Bold", size: 20))
                    .foregroundColor(Color(red: 0.30, green: 0.36, blue: 0.13))
            }
            
            Text("Trigger: \(entry.trigger)")
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(Color(red: 0.43, green: 0.55, blue: 0.17))
            
            Text(entry.timeAgo)
                .font(.custom("Poppins-Regular", size: 10))
                .foregroundColor(Color(red: 0.51, green: 0.51, blue: 0.51))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 4)
    }
}

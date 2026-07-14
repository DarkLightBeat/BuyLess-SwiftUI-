import SwiftUI

struct BuyLessLogoView: View {
    let size: CGFloat
    var body: some View {
        Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
    }
}
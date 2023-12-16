import SwiftUI

struct CompassHome: View {
    var body: some View {
        NavigationView {
            ZStack{
                Color("bg")
                    .ignoresSafeArea()
                Image("CompassArrow").rotationEffect(.degrees(0))
                    .foregroundColor(.white)
            }
        }
    }
}


#Preview {
    CompassHome()
}

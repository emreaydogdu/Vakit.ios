import SwiftUI

struct TabBar: View {
    @State private var selectedTab = 1

       var body: some View {
           TabView(selection: $selectedTab) {
               // Tab 1
               AthanHome()
                   .tabItem {
                       Image(systemName: "clock.badge.fill")
                       Text("Athan Time")
                   }
                   .tag(0)

               // Tab 2
               Finding()
                   .tabItem {
                       Image(systemName: "magnifyingglass")
                       Text("Search")
                   }
                   .tag(1)

               // Tab 3
               CompasTest()
                   .tabItem {
                       Image(systemName: "person")
                       Text("Profile")
                   }
                   .tag(2)
           }
           .accentColor(Color("color"))
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}

import SwiftUI

@main
struct BeatsTestApp: App {
    @AppStorage("showOnboarding") private var showOnboarding = true
    
    var body: some Scene {
        WindowGroup {
            if showOnboarding{
                NewUserView(showOnboarding: $showOnboarding)
            }else{
                CompassView()
            }
        }
    }
}

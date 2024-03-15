import SwiftUI


enum page: String {
    case menu = "menu"
    case game = "game"
}

@main
struct HarmonicFlightApp: App {
    
    @State var visiblePage: page = .menu
    @State var frequencyRange: (Double, Double) = (80, 200)
    @State var amplitudeRange: (Double, Double) = (0.05, 0.25)
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if visiblePage == .menu {
                    MenuView(visiblePage: self.$visiblePage, frequencyRange: self.$frequencyRange, amplitudeRange: self.$amplitudeRange)
                } else if visiblePage == .game {
                    GameView(visiblePage: self.$visiblePage, frequencyRange: self.$frequencyRange, amplitudeRange: self.$amplitudeRange)
                }
            }
        }
    }
}


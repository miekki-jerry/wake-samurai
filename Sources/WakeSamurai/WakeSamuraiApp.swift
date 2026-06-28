import SwiftUI

@main
struct WakeSamuraiApp: App {
    @StateObject private var model = AppModel()

    var body: some Scene {
        MenuBarExtra("Wake Samurai", systemImage: model.statusSymbol) {
            StatusMenuView(model: model)
                .task {
                    model.start()
                }
        }
        .menuBarExtraStyle(.window)
    }
}

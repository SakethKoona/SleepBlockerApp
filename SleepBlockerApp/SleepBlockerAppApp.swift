import SwiftUI
import FamilyControls
import DeviceActivity
import SwiftData


@main
struct SleepBlockerApp: App {
    @StateObject var ac = AuthorizationCenter.shared
    
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .onAppear { requestAuth() }
                .background(Color.blue.ignoresSafeArea())
        }.modelContainer(for: SleepSchedule.self)
    }
    
    private func requestAuth() {
        Task {
            do {
                try await ac.requestAuthorization(for: .individual)
            } catch(let error) {
                print("Denied: \(error.localizedDescription)")
            }
        }
    }
}

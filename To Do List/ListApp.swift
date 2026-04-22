import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
	) -> Bool {
		FirebaseApp.configure()
		return true
	}
}

@main
struct ListApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	@StateObject var authViewModel = AuthViewModel()
	@StateObject var todoViewModel = TodoViewModel()
	
	var body: some Scene {
		WindowGroup {
			ContentView(authViewModel: authViewModel, viewModel: todoViewModel)
		}
	}
}

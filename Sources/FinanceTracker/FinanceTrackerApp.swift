import Foundation
import OSLog
import SwiftUI

/// A logger for the FinanceTracker module.
let logger: Logger = Logger(subsystem: "fyi.savio.finance", category: "FinanceTracker")

/// The shared top-level view for the app, loaded from the platform-specific App delegates below.
///
/// The default implementation merely loads the `ContentView` for the app and logs a message.
public struct FinanceTrackerRootView : View {
    public init() {
    }

    static func getDB() -> SQLDatabase {
        do {
            return try SQLDatabase(name: "finance.db")
        } catch let error {
            return SQLDatabase()
        }
    }
    
    @State var database: SQLDatabase = getDB()
    
    public var body: some View {
        ContentView()
            .environment(database)
//        SQLPlayground()
            .task {
                logger.info("Skip app logs are viewable in the Xcode console for iOS; Android logs can be viewed in Studio or using adb logcat")
                
//                do {
//                    try await DatabaseManager.shared.safeInit()
//                } catch {
//                    print("[~][db] Database initialization failed: \(error)")
//                }
            }
    }
}

/// Global application delegate functions.
///
/// These functions can update a shared observable object to communicate app state changes to interested views.
public final class FinanceTrackerAppDelegate : Sendable {
    public static let shared = FinanceTrackerAppDelegate()

    private init() {
    }

    public func onInit() {
        logger.debug("onInit")
    }

    public func onLaunch() {
        logger.debug("onLaunch")
    }

    public func onResume() {
        logger.debug("onResume")
    }

    public func onPause() {
        logger.debug("onPause")
    }

    public func onStop() {
        logger.debug("onStop")
    }

    public func onDestroy() {
        logger.debug("onDestroy")
    }

    public func onLowMemory() {
        logger.debug("onLowMemory")
    }
}

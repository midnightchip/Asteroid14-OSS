import os 
import Foundation

struct MCLogger {
    static let logger = Logger(subsystem: "Asteroid", category: "Tweak");
    static func log(_ args: String...) {
        logger.log("[Asteroid] \(timeStamp(), privacy: .public) Info: \(args, privacy: .public)")
    }

    static func error(_ args: String...) {
        logger.error("[Asteroid] \(timeStamp(), privacy: .public) Error: \(args, privacy: .public)")
    }

    static func info(_ args: String...) {
        logger.info("[Asteroid] \(timeStamp(), privacy: .public) Error: \(args, privacy: .public)")
    }

    static func timeStamp() -> String {
        return Date().currentTimeMillis()
    }
}

extension Date {
    func currentTimeMillis() -> String {
        return String(self.timeIntervalSince1970 * 1000)
    }
}
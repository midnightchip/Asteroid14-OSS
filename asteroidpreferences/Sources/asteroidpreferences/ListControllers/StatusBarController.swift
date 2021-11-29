import asteroidpreferencesC
import Cephei
import CepheiPrefs
import Preferences
import UIKit

@objc(StatusBarController) @objcMembers final class StatusBarController: HBListController {
    let prefs = HBPreferences(identifier: "me.midnightchips.asteroidpreferences")
    override static var specifierPlist: String {
        return "StatusBar"
    }
}

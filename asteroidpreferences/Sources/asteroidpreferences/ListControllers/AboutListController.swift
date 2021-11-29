import asteroidpreferencesC
import Cephei
import CepheiPrefs
import Preferences
import UIKit

@objc(AboutController) @objcMembers final class AboutController: HBAboutListController {
    let prefs = HBPreferences(identifier: "me.midnightchips.asteroidpreferences")
    override static var specifierPlist: String {
        return "About"
    }

    override static func hb_supportEmailAddress() -> String? {
        return "asteroid-support@midnightchips.me"
    }

    func rerunSetup(_: PSSpecifier) {
        let prefs = HBPreferences(identifier: "me.midnightchips.asteroidpreferences")
        prefs.set(false, forKey: "completedAsteroidSetup")
        HBRespringController.respring()
    }
}

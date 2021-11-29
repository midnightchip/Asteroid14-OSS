import asteroidpreferencesC
import Cephei
import CepheiPrefs
import Preferences
import UIKit

let LOCK_SCREEN_LOCATION_INDEX = "LockScreenLocationIndex"
let LOCK_SCREEN_CONDITION_INDEX = "LockScreenCustomConditionIndex"

@objc(LockScreenController) @objcMembers final class LockScreenController: HBListController, PassWeatherData, PassConditionData {
    let prefs = HBPreferences(identifier: "me.midnightchips.asteroidpreferences")
    private let EnableCustomLocationLockScreen = "EnableCustomLocationLockScreen"
    private let EnableCustomLockScreenCondition = "EnableCustomLockScreenCondition"
    
    override static var specifierPlist: String {
        return "LockScreen"
    }

    var customCondition: [PSSpecifier] = []
    var customLocation: [PSSpecifier] = []
    override var specifiers: NSMutableArray? {
        get {
            if let specifiers = value(forKey: "_specifiers") as? NSMutableArray {
                return specifiers
            } else {
                let specifiers = loadSpecifiers(fromPlistName: "LockScreen", target: self)
                setValue(specifiers, forKey: "_specifiers")
                customCondition = self.specifiers(forIDs: ["enableNightAnimation", "selectCustomAnimation"]) as? [PSSpecifier] ?? []
                customLocation = self.specifiers(forIDs: ["selectWeatherLocation"]) as? [PSSpecifier] ?? []
                return specifiers
            }
        }
        set {
            super.specifiers = newValue
        }
    }

    func presentWeatherPicker(_: PSSpecifier) {
        let sheetViewController = WeatherPicker(cityIndex: prefs.integer(forKey: LOCK_SCREEN_LOCATION_INDEX, default: 0), delegate: self)
        present(sheetViewController, animated: true, completion: nil)
    }

    func updateSpecifiersVisibility(id: String, prefsName: String, targetSpecs: [PSSpecifier], animated: Bool) {
        let switchVal = prefs.bool(forKey: prefsName, default: false)

        if !switchVal {
            removeContiguousSpecifiers(targetSpecs, animated: animated)
        } else if !containsSpecifier(targetSpecs[0]) {
            insertContiguousSpecifiers(targetSpecs, afterSpecifierID: id, animated: animated)
        }
        prefs.setValue("CHANGED \(Date().timeIntervalSince1970)", forKey: "UPDATESHIM")
    }

    override func setPreferenceValue(_ value: Any!, specifier: PSSpecifier!) {
        super.setPreferenceValue(value, specifier: specifier)

        updateSpecifiersVisibility(id: "enableCustomAnimation", prefsName: EnableCustomLockScreenCondition, targetSpecs: customCondition, animated: true)

        updateSpecifiersVisibility(id: "enableCustomLocation", prefsName: EnableCustomLocationLockScreen, targetSpecs: customLocation, animated: true)
    }

    override func reloadSpecifiers() {
        super.reloadSpecifiers()
        updateSpecifiersVisibility(id: "enableCustomAnimation", prefsName: EnableCustomLockScreenCondition, targetSpecs: customCondition, animated: true)
        updateSpecifiersVisibility(id: "enableCustomLocation", prefsName: EnableCustomLocationLockScreen, targetSpecs: customLocation, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addHeader()
        updateSpecifiersVisibility(id: "enableCustomAnimation", prefsName: EnableCustomLockScreenCondition, targetSpecs: customCondition, animated: false)
        updateSpecifiersVisibility(id: "enableCustomLocation", prefsName: EnableCustomLocationLockScreen, targetSpecs: customLocation, animated: false)

        prefs.registerPreferenceChange {
            self.forceHeaderUpdate()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }

    private func addHeader() {
        let deviceView = DeviceView(frame: CGRect(x: 0, y: 0, width: table.frame.size.width, height: table.frame.size.width))
        table.tableHeaderView = deviceView
        sizeHeaderToFit()
    }

    private func sizeHeaderToFit() {
        let headerView = table.tableHeaderView!

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        var frame = headerView.frame
        frame.size.height = table.frame.size.width
        headerView.frame = frame

        table.tableHeaderView = headerView
    }

    func forceHeaderUpdate() {
        table.tableHeaderView?.setNeedsLayout()
        table.tableHeaderView?.layoutIfNeeded()
    }

    func presentConditionPicker(_: PSSpecifier) {
        let sheetViewController = ConditionPicker(weatherCondition: 0, delegate: self, nightCondition: "LockCustomLocationNight")
        present(sheetViewController, animated: true, completion: nil)
    }

    func pass(locationIndex: Int) {
        prefs.setValue(locationIndex, forKey: LOCK_SCREEN_LOCATION_INDEX)
    }

    func pass(conditionIndex: Int) {
        prefs.setValue(conditionIndex, forKey: LOCK_SCREEN_CONDITION_INDEX)
    }
}

import asteroidpreferencesC
import Cephei
import CepheiPrefs
import Preferences
import UIKit

let HomeScreenLocationIndex = "HomeScreenLocationIndex"
let HomeScreenConditionIndex = "HomeScreenCustomConditionIndex"

protocol PassWeatherData {
    func pass(locationIndex: Int)
}

protocol PassConditionData {
    func pass(conditionIndex: Int)
}

@objc(HomeScreenController) @objcMembers final class HomeScreenController: HBListController, PassWeatherData, PassConditionData {
    let prefs = HBPreferences(identifier: "me.midnightchips.asteroidpreferences")
    override static var specifierPlist: String {
        return "HomeScreen"
    }

    var customCondition: [PSSpecifier] = []
    var customLocation: [PSSpecifier] = []
    override var specifiers: NSMutableArray? {
        get {
            if let specifiers = value(forKey: "_specifiers") as? NSMutableArray {
                return specifiers
            } else {
                let specifiers = loadSpecifiers(fromPlistName: "HomeScreen", target: self)
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

    //: (PSSpecifier*)specifier
    func presentWeatherPicker(_: PSSpecifier) {
        let sheetViewController = WeatherPicker(cityIndex: prefs.integer(forKey: HomeScreenLocationIndex, default: 0), delegate: self)
        present(sheetViewController, animated: true, completion: nil)
    }

    func updateSpecifiersVisibility(id: String, prefsName: String, targetSpecs: [PSSpecifier], animated: Bool) {
        // let switchSpec = specifier(forID: id) as PSSpecifier

        // let switchVal = readPreferenceValue(switchSpec)
        let switchVal = prefs.bool(forKey: prefsName, default: false)

        if !switchVal {
            removeContiguousSpecifiers(targetSpecs, animated: animated)
            // removeSpecifier(savedSpecs[0], animated: animated)
        } else if !containsSpecifier(targetSpecs[0]) {
            insertContiguousSpecifiers(targetSpecs, afterSpecifierID: id, animated: animated)
            // insertSpecifier(savedSpecs[0], afterSpecifierID: id, animated: animated)
        }

        // reload()
        prefs.setValue("CHANGED \(Date().timeIntervalSince1970)", forKey: "UPDATESHIM")
        // forceHeaderUpdate()
    }

    override func setPreferenceValue(_ value: Any!, specifier: PSSpecifier!) {
        super.setPreferenceValue(value, specifier: specifier)

        updateSpecifiersVisibility(id: "enableCustomAnimation", prefsName: "EnableCustomHomeCondition", targetSpecs: customCondition, animated: true)

        updateSpecifiersVisibility(id: "enableCustomLocation", prefsName: "EnableCustomLocationHome", targetSpecs: customLocation, animated: true)
    }

    override func reloadSpecifiers() {
        super.reloadSpecifiers()
        updateSpecifiersVisibility(id: "enableCustomAnimation", prefsName: "EnableCustomHomeCondition", targetSpecs: customCondition, animated: true)
        updateSpecifiersVisibility(id: "enableCustomLocation", prefsName: "EnableCustomLocationHome", targetSpecs: customLocation, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addHeader()
        updateSpecifiersVisibility(id: "enableCustomAnimation", prefsName: "EnableCustomHomeCondition", targetSpecs: customCondition, animated: false)
        updateSpecifiersVisibility(id: "enableCustomLocation", prefsName: "EnableCustomLocationHome", targetSpecs: customLocation, animated: false)

        prefs.registerPreferenceChange {
            self.forceHeaderUpdate()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        table.tableHeaderView = nil
    }

    private func addHeader() {
        let deviceView = DeviceView(frame: CGRect(x: 0, y: 0, width: table.frame.size.width, height: table.frame.size.width), enableHomeScreen: true)
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
        let sheetViewController = ConditionPicker(weatherCondition: 0, delegate: self, nightCondition: "HomeCustomLocationNight")
        present(sheetViewController, animated: true, completion: nil)
    }

    func pass(locationIndex: Int) {
        prefs.setValue(locationIndex, forKey: HomeScreenLocationIndex)
    }

    func pass(conditionIndex: Int) {
        prefs.setValue(conditionIndex, forKey: HomeScreenConditionIndex)
    }
}

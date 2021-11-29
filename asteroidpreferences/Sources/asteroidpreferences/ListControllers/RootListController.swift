import asteroidpreferencesC
import Cephei
import CepheiPrefs
import Preferences
import UIKit

final class RootListController: HBListController {
    private var banner: PSSpecifier?
    private var buy: PSSpecifier?
    private var retry: PSSpecifier?
    private let prefs = HBPreferences(identifier: "me.midnightchips.asteroidpreferences")
    override var specifiers: NSMutableArray? {
        get {
            if let specifiers = value(forKey: "_specifiers") as? NSMutableArray {
                return specifiers
            } else {
                let specifiers = loadSpecifiers(fromPlistName: "Root", target: self)
                setValue(specifiers, forKey: "_specifiers")
                banner = self.specifier(forID: "banner")
                buy = self.specifier(forID: "buy")
                retry = self.specifier(forID: "retry")
                return specifiers
            }
        }
        set {
            super.specifiers = newValue
        }
    }

    override func loadView() {
        super.loadView()
        if #available(iOS 13.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slowmo"), style: .plain, target: self, action: #selector(respring))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if buy != nil {
            removeSpecifier(buy)
            removeSpecifier(retry)
        }
    }

    @objc func respring() {
        HBRespringController.respring()
    }

    @objc func retry(_: PSSpecifier) {
        throw Error("Not Implemented")
    }
}

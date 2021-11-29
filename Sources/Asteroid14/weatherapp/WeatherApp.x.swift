import Asteroid14C
import Cephei
import Orion

struct WeatherApp: HookGroup {}

class SBLiveWeatherIcon: ClassHook<NSObject> {
    typealias Group = WeatherApp

    static var targetName: String = "SBApplicationIcon"
    static var subclassMode = SubclassMode.createSubclassNamed("SBLiveWeatherIcon")
    func iconImageViewClassForLocation(_: Int) -> AnyClass {
        return NSClassFromString("SBLiveWeatherIconImageView")!
    }
}

class SBLiveWeatherIconImageView: ClassHook<UIView> {
    @Property(.nonatomic) var prefs = HBPreferences(identifier: "me.midnightchips.asteroidpreferences")
    typealias Group = WeatherApp
    static var targetName: String = "SBIconImageView"
    static var subclassMode = SubclassMode.createSubclassNamed("SBLiveWeatherIconImageView")
    @Property(.nonatomic) var liveWeatherView: LiveWeatherIconView? = nil

    func initWithFrame(_ frame: CGRect) -> Target {
        let target = orig.initWithFrame(frame)
        if target.viewWithTag(55668) == nil {
            if liveWeatherView != nil {
                liveWeatherView!.removeFromSuperview()
            }

            liveWeatherView = LiveWeatherIconView(frame: frame)
            liveWeatherView?.tag = 55668
            liveWeatherView?.translatesAutoresizingMaskIntoConstraints = false
            target.addSubview(liveWeatherView!)
            liveWeatherView?.clipsToBounds = true

            liveWeatherView!.leftAnchor.constraint(equalTo: target.leftAnchor).isActive = true
            liveWeatherView!.rightAnchor.constraint(equalTo: target.rightAnchor).isActive = true
            liveWeatherView!.topAnchor.constraint(equalTo: target.topAnchor).isActive = true
            liveWeatherView!.bottomAnchor.constraint(equalTo: target.bottomAnchor).isActive = true

            liveWeatherView?.updateWeatherDisplay()

            updateMask()
        }
        return target
    }

    func sizeThatFits(_ size: CGSize) -> CGSize {
        let fitSize = orig.sizeThatFits(size)
        liveWeatherView?.updateSize(size)

        return fitSize
    }

    // orion:new
    func updateMask() {
        // TODO: Add Snowboard support

        let bundle = Bundle(path: "/System/Library/PrivateFrameworks/MobileIcons.framework")

        let maskImage = UIImage(named: "AppIconMask", in: bundle)
        let mask = CALayer()
        mask.contents = maskImage?.cgImage
        mask.frame = CGRect(x: 0, y: 0, width: maskImage!.size.width, height: maskImage!.size.height)
        liveWeatherView?.layer.mask = mask

        liveWeatherView?.layer.masksToBounds = true
    }
}

class SBApplicationInfoHook: ClassHook<SBApplicationInfo> {
    @Property(.nonatomic) var prefs = HBPreferences(identifier: "me.midnightchips.asteroidpreferences")
    typealias Group = WeatherApp
    func iconClass() -> AnyClass {
        if (prefs.object(forKey: "SelectedLiveWeatherApps", default: []) as! [String]).contains(target.bundleIdentifier) {
            return NSClassFromString("SBLiveWeatherIcon")!
        } else {
            return orig.iconClass()
        }
    }
}

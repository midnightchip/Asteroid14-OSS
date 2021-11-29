import Asteroid14C
import Cephei
import Orion
import SwiftUI

struct OnBoardSetup: HookGroup {}

class OnBoardHook: ClassHook<CSCoverSheetViewController> {
    @Property(.nonatomic) var targetWindow: OnBoardWindow? = nil
    typealias Group = OnBoardSetup
    func viewDidLoad() {
        orig.viewDidLoad()
        MCLogger.log("BUILDING WINDOW")
        targetWindow = OnBoardWindow(frame: UIScreen.main.bounds)

        let onboardVc = UIHostingController(rootView: WelcomeView())
        targetWindow?.rootViewController = onboardVc
        targetWindow?.makeKeyAndVisible()
        Validate().verify()
    }
}

@objc class OnBoardWindow: UIWindow {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        windowLevel = .statusBar
        _setSecure(true)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

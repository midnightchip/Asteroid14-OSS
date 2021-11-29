
import asteroidpreferencesC
import Cephei
import Foundation
import UIKit



class ConditionPicker: UIViewController {
    var conditionCollectionView: UICollectionView?
    let totalConditions = 47
    let currentWeatherCondition: Int
    var targetDelegate: PassConditionData
    let prefs = HBPreferences(identifier: "me.midnightchips.asteroidpreferences")
    let NIGHT_CONDITION: String

    required init(weatherCondition: Int, delegate: PassConditionData, nightCondition: String) {
        currentWeatherCondition = weatherCondition
        NIGHT_CONDITION = nightCondition
        targetDelegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let view = UIView()
        view.backgroundColor = .white

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        conditionCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)

        conditionCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ConditionCell")
        // myCollectionView?.backgroundColor = UIColor.white

        conditionCollectionView?.dataSource = self
        conditionCollectionView?.delegate = self

        view.addSubview(conditionCollectionView ?? UICollectionView())

        self.view = view
    }
}

extension ConditionPicker: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return totalConditions
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConditionCell", for: indexPath)
        let currentCity = WeatherPreferences.shared().loadSavedCities()[0]

        currentCity.conditionCode = Int64(indexPath.row)
        if prefs.bool(forKey: NIGHT_CONDITION, default: false) && currentCity.isDay || !prefs.bool(forKey: NIGHT_CONDITION, default: false) && !currentCity.isDay {
            let currentDiff = currentCity.timeZone.secondsFromGMT()
            currentCity.timeZone = TimeZone(secondsFromGMT: currentDiff + 43200)
        }

        let referenceView = WUIWeatherConditionBackgroundView(frame: myCell.contentView.frame)
        referenceView?.background()?.setCity(currentCity)
        if prefs.bool(forKey: NIGHT_CONDITION, default: false) {
            referenceView?.background().condition().forcesNight = 1
        }

        referenceView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        referenceView?.clipsToBounds = true

        if referenceView != nil {
            myCell.contentView.addSubview(referenceView!)
        }

        return myCell
    }
}

extension ConditionPicker: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        targetDelegate.pass(conditionIndex: indexPath.row)
        dismiss(animated: true, completion: nil)
    }
}

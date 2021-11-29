
import asteroidpreferencesC
import Cephei
import CepheiPrefs
import Foundation
import UIKit

class WeatherAppPreview: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    let prefs = HBPreferences(identifier: "me.midnightchips.asteroidpreferences")
    var weatherAppIcon: UIImageView?
    var appCollectionView: UICollectionView?
    var allApps: AnyObject?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPrefs()
        addCollectionView(frame: frame)

        prefs.registerPreferenceChange {
            self.appCollectionView?.reloadData()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getWeatherIcon(bundle: String) -> UIImage? {
        return UIImage._applicationIconImage(forBundleIdentifier: bundle, format: 1, scale: 4.0).resize(toHeight: 60)
    }

    func setupPrefs() {
        prefs.register(object: &allApps, default: [], forKey: "SelectedLiveWeatherApps")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        appCollectionView?.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }

    func addCollectionView(frame: CGRect) {
        let margin: CGFloat = 10
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        layout.itemSize = CGSize(width: 60, height: 60)

        appCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        appCollectionView?.register(AppCell.self, forCellWithReuseIdentifier: "AppCell")
        appCollectionView?.dataSource = self
        appCollectionView?.delegate = self

        appCollectionView?.backgroundView = DeviceView(frame: frame, enableHomeScreen: true)

        addSubview(appCollectionView ?? UICollectionView())
        appCollectionView?.topAnchor.constraint(equalTo: topAnchor).isActive = true
        appCollectionView?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        appCollectionView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        appCollectionView?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return allApps?.count ?? 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppCell", for: indexPath) as! AppCell

        if (allApps as? [String])?.isEmpty ?? true || allApps == nil {
            cell.setAppImage(bundleID: "com.apple.weather")
        } else {
            let appId = (allApps as? [String])?[indexPath.row] ?? "com.apple.weather"
            cell.setAppImage(bundleID: appId)
        }
        cell.addLiveWeatherView()
        cell.liveWeatherView?.updateWeatherDisplay()
        return cell
    }
}

class AppCell: UICollectionViewCell {
    var liveWeatherView: LiveWeatherIconPreview?

    let imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)

        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        let bundle = Bundle(path: "/System/Library/PrivateFrameworks/MobileIcons.framework")
        let maskImage = UIImage(named: "AppIconMask", in: bundle)
        let mask = CALayer()
        mask.contents = maskImage?.cgImage
        mask.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        contentView.layer.mask = mask
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // liveWeatherView.frame = contentView.bounds
        // liveWeatherView.updateWeatherDisplay()
        imageView.frame = contentView.bounds
    }

    func setAppImage(bundleID: String) {
        imageView.image = UIImage._applicationIconImage(forBundleIdentifier: bundleID, format: 1, scale: 4.0).resize(toHeight: 60)
        imageView.setNeedsLayout()
        imageView.layoutIfNeeded()
    }

    func addLiveWeatherView() {
        if liveWeatherView != nil {
            liveWeatherView?.removeFromSuperview()
            liveWeatherView = nil
        }
        liveWeatherView = LiveWeatherIconPreview(frame: .zero)
        liveWeatherView?.translatesAutoresizingMaskIntoConstraints = false
        liveWeatherView?.layer.masksToBounds = true
        liveWeatherView?.frame = frame
        contentView.addSubview(liveWeatherView!)

        liveWeatherView?.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        liveWeatherView?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        liveWeatherView?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        liveWeatherView?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


import Foundation
import UIKit
import asteroidpreferencesC

class WeatherPicker : UIViewController {
    var myCollectionView:UICollectionView?
    let allCities: [City] = WeatherPreferences.shared().loadSavedCities()
    let selectedCityIndex: Int
    var targetDelegate: PassWeatherData
    
    required init(cityIndex: Int, delegate: PassWeatherData) {
        selectedCityIndex = cityIndex
        targetDelegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView()
        view.backgroundColor = .white
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        myCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        //myCollectionView?.backgroundColor = UIColor.white
        
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        
        view.addSubview(myCollectionView ?? UICollectionView())
        
        self.view = view
    }
}

extension WeatherPicker: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        let currentCity = allCities[indexPath.row]
        let referenceView = WUIWeatherConditionBackgroundView(frame: myCell.contentView.frame)
        referenceView?.background()?.setCity(currentCity)
        referenceView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        referenceView?.clipsToBounds = true
        
        let locationName = UILabel()
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 3
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.1)
        shadow.shadowOffset = CGSize(width: 0, height: 2)
        let attributes = [NSAttributedString.Key.shadow: shadow, NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1)]
        let fullString = NSMutableAttributedString(string: currentCity.name + " ", attributes: attributes)
        
        if selectedCityIndex == indexPath.row {
            let checkImage = NSTextAttachment()
            checkImage.image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.green)
            let image1String = NSAttributedString(attachment: checkImage)
            fullString.append(image1String)
        }
        
        locationName.attributedText = fullString
        locationName.translatesAutoresizingMaskIntoConstraints = false
        locationName.sizeToFit()
        
        referenceView?.addSubview(locationName)
        
        if referenceView != nil {
            myCell.contentView.addSubview(referenceView!)
        }
        
        locationName.topAnchor.constraint(equalTo: myCell.contentView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        locationName.bottomAnchor.constraint(equalTo: myCell.contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        locationName.leftAnchor.constraint(equalTo: myCell.contentView.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        
        return myCell
    }
}

extension WeatherPicker: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        targetDelegate.pass(locationIndex: indexPath.row)
        dismiss(animated: true, completion: nil)
    }
}

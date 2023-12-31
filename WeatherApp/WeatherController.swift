//
//  ViewController.swift
//  WeatherApp
//
//  Created by Мурат Кудухов on 22.07.2023.
//

import UIKit
import MapKit
import CoreLocation
import WidgetKit


final class WeatherController: UIViewController, CLLocationManagerDelegate, UIScrollViewDelegate {
    
    private let minConstraintConstant: CGFloat = 72
    private let maxConstraintConstant: CGFloat = 300
    private var previousContentOffsetY: CGFloat = 0
    
    private var degreesHeightConstraint: NSLayoutConstraint?
    private var scrollHeightConstraint: NSLayoutConstraint?
    private var tableCityName: String? = nil
    
    private var location: CLLocation?
    private var longitude = 0.0
    private var latitude = 0.0
    private var userLatitude = "0"
    private var userLongitude = "0"
    
    private let geoCoder = CLGeocoder()
    static let shared = WeatherController()
    private let locationManager = CLLocationManager()
    private let hourlyCollection = HourlyViewCollection()
    private let dailyCollection = DailyViewCollection()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.isDirectionalLockEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let middleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open", for: .normal)
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = R.Colors.darkBg
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let windLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Wind"
        label.font = R.Fonts.Bold(with: 16)
        label.textColor = R.Colors.darkBg
        label.textAlignment = .center
        return label
    }()
    
    private let speedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "4m/s"
        label.font = R.Fonts.Bold(with: 14)
        label.textColor = R.Colors.darkBg
        label.textAlignment = .center
        return label
    }()
    
    private let windImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName:"wind")
        view.contentMode = .scaleAspectFit
        view.tintColor = R.Colors.darkBg
        return view
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 22)
        label.text = "Москва"
        label.textColor = R.Colors.darkBg
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сейчас"
        label.font = R.Fonts.avenirBook(with: 16)
        label.textColor = R.Colors.darkBg
        label.textAlignment = .center
        return label
    }()
    
    private let degrees: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 172)
        label.text = "00˚"
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.textColor = R.Colors.darkBg
        label.textAlignment = .center
        return label
    }()
    
    private let titleDegrees: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 16)
        label.text = "00˚"
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.textColor = R.Colors.darkBg
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named:"fog")
        view.contentMode = .scaleAspectFill
        view.tintColor = R.Colors.darkBg
        return view
    }()
    
    private let backgroundImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named:"gradientBG")
        return view
    }()
    
    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mostly cloudy"
        label.font = R.Fonts.avenirBook(with: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = R.Colors.darkBg
        return label
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "7-Дневный прогноз"
        label.font = R.Fonts.avenirBook(with: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = R.Colors.darkBg
        return label
    }()
    
    private let stackViewV: UIStackView = {
        let view = UIStackView()
        view.spacing = 16
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var userLocation: CLLocation?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getUserLocation()
        view.addSubview(backgroundImage)
        view.addSubview(scrollView)
        view.addSubview(degrees)
        view.addSubview(locationLabel)
        view.addSubview(searchButton)
        view.addSubview(timeLabel)
        view.addSubview(titleDegrees)
        
        scrollView.delegate = self
        
        middleView.addSubview(hourlyCollection)
        middleView.addSubview(imageView)
        middleView.addSubview(weatherLabel)
        middleView.addSubview(dailyCollection)
        middleView.addSubview(headerLabel)
//        view.addSubview(windLabel)
//        view.addSubview(windImageView)
//        view.addSubview(speedLabel)
       // view.addSubview(stackViewV)
//        middleView.addSubview(searchButton)
        contentView.addSubview(middleView)
        scrollView.addSubview(contentView)
        
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        constraints()
        setupCollectionView()
        
        
    }
    
    func dataSetup() {
        APIWeatherManager.shared.getweather { [weak self] weatherData in
            DispatchQueue.main.sync {
                guard let self else {return}
                
                print("DataSetup")
                self.removeAllArrangedSubviews(from: self.stackViewV)
                self.degrees.text = "\(Int(weatherData.currentWeather.temperature))˚"
                self.titleDegrees.text = "\(Int(weatherData.currentWeather.temperature))˚"
                self.speedLabel.text = "\(weatherData.currentWeather.windspeed)m/s"
                self.weatherLabel.text = weatherCodes["\(weatherData.currentWeather.weathercode)"]
                self.imageView.image = UIImage(named: weatherImages["\(weatherData.currentWeather.weathercode)"]!)
//                self.backgroundImage.image = UIImage(named: backgroundImg["\(weatherData.currentWeather.weathercode)"]!)
                
                //self.changeTheme()
                self.hourlyCollection.updateTable()
                self.dailyCollection.updateTable()
                
                let imageData = self.imageView.image?.pngData()
                let mySharedDefaults = UserDefaults(suiteName: "group.com.MK.WeatherApp")
                mySharedDefaults?.setValue(self.locationLabel.text, forKey: "cityName")
                mySharedDefaults?.setValue(self.degrees.text, forKey: "cityTemp")
                mySharedDefaults?.set(imageData, forKey: "weatherImage")
                WidgetCenter.shared.reloadTimelines(ofKind: "com.yourapp.examplewidget")
                //self.weatherImageAnimation()
            }
        }
    }
    
    func weatherImageAnimation() {
        let x = view.frame.height/2 - degrees.bounds.height*2 - locationLabel.bounds.height
        let startY = self.imageView.frame.origin.y + x
        let endY = startY + 10
        func animateImageView() {
            UIView.animate(withDuration: 1.0, animations: {
                self.imageView.frame.origin.y = endY
            }, completion: { _ in
                UIView.animate(withDuration: 1.0, animations: {
                    self.imageView.frame.origin.y = startY
                }, completion: { _ in
                    animateImageView()
                })
            })
        }
        animateImageView()
    }
    
    
    func removeAllArrangedSubviews(from stackView: UIStackView) {
        for arrangedSubview in stackView.arrangedSubviews {
            // Удалить представление из UIStackView
            stackView.removeArrangedSubview(arrangedSubview)
            // Удалить представление из иерархии представлений
            arrangedSubview.removeFromSuperview()
        }
    }
    
    
    public func getCoordinates() {
        print("GetCoordinates")
        self.geoCoder.geocodeAddressString(self.locationLabel.text ?? "Oslo") { (placemarks, error) in
            if error != nil {
                self.showAlert(title: "Oops", message: "This city doesn't exist")
                self.locationLabel.text = "Vladikavkaz"
                return
            }
            
            if let placemarks = placemarks, let location = placemarks.first?.location {
                let coordinates = location.coordinate
                print("Координаты города \(self.locationLabel.text ?? "") - Широта: \(coordinates.latitude), Долгота: \(coordinates.longitude)")
                self.latitude = coordinates.latitude
                self.longitude = coordinates.longitude
                APIWeatherManager.shared.coordinates(latitude: self.latitude, longitude: self.longitude)
                
                self.dataSetup()
            } else {
                print("ERROR")
            }
        }
    }
    
    //MARK: - User location
    
    func getUserLocation() {
        print("GetUserLocation")
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        let authStatus = self.locationManager.authorizationStatus
        
        if authStatus == .denied || authStatus == .restricted { self.showLocationServicesDeniedAlert()
            return
        } else if authStatus == .notDetermined { self.locationManager.requestWhenInUseAuthorization()
            return
        }
    }
    
    func getCity(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first {
                // Получение информации о местоположении
                let address = "\(placemark.postalCode ?? ""), \(placemark.locality ?? ""), \(placemark.country ?? "")"
                print("GET-CITY")
                print(address)
                self.locationLabel.text = placemark.locality
                self.getCoordinates()
            }
        }
    }
    
    @objc
    func searchButtonTapped() {
        //showSearchAlert(title: "City" , message: "Please enter the city")
        
       // let vc = UINavigationController(rootViewController:SearchController())
        let vc = SearchTableView {city in
            self.locationLabel.text = city
            self.getCoordinates()
        }
        
        present(vc, animated: true)
        
    }
    
    func setLocationLabel(city: String) {
        print("SetLocationLabel")
        locationLabel.text = city
        getCoordinates()
        
    }

   
    //MARK: - AnimatedCollection
    
    private func setupCollectionView() {
        
        scrollHeightConstraint = scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: maxConstraintConstant)
        
        degreesHeightConstraint = degrees.heightAnchor.constraint(equalToConstant: maxConstraintConstant)
        
        NSLayoutConstraint.activate([
            scrollHeightConstraint!,
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            degreesHeightConstraint!,
            degrees.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 16),
            degrees.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 24),
            degrees.widthAnchor.constraint(equalTo: degrees.heightAnchor),
//            degrees.heightAnchor.constraint(equalToConstant: 200),
//            degrees.widthAnchor.constraint(equalToConstant: 400),
        ])
    }
    
    
    //MARK: - Constraints
    func constraints() {
        hourlyCollection.translatesAutoresizingMaskIntoConstraints = false
        dailyCollection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            titleDegrees.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleDegrees.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 832),//1128
            
            middleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -50),
            middleView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            middleView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            middleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//
//            stackViewV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -64),
//            stackViewV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            //stackViewV.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 32),
            
            hourlyCollection.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            hourlyCollection.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 24),
            hourlyCollection.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -24),
            hourlyCollection.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 32),
            hourlyCollection.heightAnchor.constraint(equalToConstant: 100),
            
            dailyCollection.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            dailyCollection.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 24),
            dailyCollection.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -24),
            dailyCollection.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            dailyCollection.heightAnchor.constraint(equalToConstant: 350),
            
            headerLabel.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 24),
            headerLabel.topAnchor.constraint(equalTo: hourlyCollection.bottomAnchor, constant: 16),
            
//            windLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            windLabel.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 16),
//
//            windImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
//            windImageView.topAnchor.constraint(equalTo: windLabel.bottomAnchor, constant: 8),
//
//            //speedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            speedLabel.leadingAnchor.constraint(equalTo: windImageView.trailingAnchor, constant: 8),
//            speedLabel.centerYAnchor.constraint(equalTo: windImageView.centerYAnchor),
            
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 64),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            
            weatherLabel.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            weatherLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            weatherLabel.heightAnchor.constraint(equalToConstant: 50),
            weatherLabel.widthAnchor.constraint(equalToConstant: 150),
        ])
        
    }
}


extension WeatherController {
    func showSearchAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { tf in
            let cities = ["San Francisco", "Vladikavkaz", "Boston", "Moscow", "Viena", "Stambul", "San Jose"]
            tf.placeholder = cities.randomElement()
        }
        
        let search = UIAlertAction(title:"Search", style: .default) { action in
            let textField = alert.textFields?.first
            guard let cityName = textField?.text else {return}
            if cityName != "" {
                print("Search info for the \(cityName)")
                self.locationLabel.text = cityName
                self.getCoordinates()
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(search)
        alert.addAction(cancel)
        self.present(alert,animated: true)
        
    }
    
    func locationManager( _ manager: CLLocationManager, didFailWithError error: Error) {
      print("didFailWithError \(error.localizedDescription)")
    }
    
    func locationManager( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        location = newLocation
        updateLabels()
      
        
    }
    
    func updateLabels() {
        if let location = location {
            userLatitude = String( format: "%.8f", location.coordinate.latitude)
            userLongitude = String( format: "%.8f", location.coordinate.longitude)
            let userLocation = CLLocation(latitude: Double(userLatitude) ?? 55.7586642, longitude: Double(userLongitude) ?? 37.6192919)
            getCity(location: userLocation)
            
        
        } else {
            userLatitude = ""
            userLongitude = ""
        }
    }
    
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)

    present(alert, animated: true, completion: nil)
    }
    
    func changeTheme() {
        if traitCollection.userInterfaceStyle == .dark {
            searchButton.tintColor = R.Colors.background
            locationLabel.textColor = R.Colors.background
            degrees.textColor = R.Colors.background
            imageView.tintColor = R.Colors.background
            timeLabel.textColor = R.Colors.background
            speedLabel.textColor = R.Colors.background
            weatherLabel.textColor = R.Colors.background
            windImageView.tintColor = R.Colors.background
            windLabel.textColor = R.Colors.background
            headerLabel.textColor = R.Colors.background
            titleDegrees.textColor = R.Colors.background
            backgroundImage.image = UIImage(named:"rainyBg")
        } else {
            searchButton.tintColor = R.Colors.darkBg
            locationLabel.textColor = R.Colors.darkBg
            degrees.textColor = R.Colors.darkBg
            imageView.tintColor = R.Colors.darkBg
            timeLabel.textColor = R.Colors.darkBg
            speedLabel.textColor = R.Colors.darkBg
            weatherLabel.textColor = R.Colors.darkBg
            windImageView.tintColor = R.Colors.darkBg
            headerLabel.textColor = R.Colors.darkBg
            titleDegrees.textColor = R.Colors.background
            backgroundImage.image = UIImage(named:"gradientBG")
        }
    }
    
}

extension WeatherController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //Узнаем направление движения скролла
        let currentContentOffsetY = scrollView.contentOffset.y
       // print("CurrentContent - \(currentContentOffsetY)")
        let scrollDiff = currentContentOffsetY - previousContentOffsetY
        let bounceBorderContentOffsetY = -scrollView.contentInset.top
        
        let contentMovesUp = scrollDiff > 0 && currentContentOffsetY > bounceBorderContentOffsetY
        let contentMovesDown = scrollDiff < 0 && currentContentOffsetY < bounceBorderContentOffsetY
        
        let currentConstraintConstant = scrollHeightConstraint!.constant
        var newConstraintConstant = currentConstraintConstant
        
        if contentMovesUp {
            // Уменьшаем константу констрэйнта
            newConstraintConstant = max(currentConstraintConstant - scrollDiff, minConstraintConstant)
        } else if contentMovesDown {
            // Увеличиваем константу констрэйнта
            newConstraintConstant = min(currentConstraintConstant - scrollDiff, maxConstraintConstant)
        }
        
        if newConstraintConstant != currentConstraintConstant {
            scrollHeightConstraint?.constant = newConstraintConstant
            scrollView.contentOffset.y = previousContentOffsetY
           
        }
        
        let animationCompletionPercent = (maxConstraintConstant - currentConstraintConstant) / (maxConstraintConstant - minConstraintConstant)
        
        if newConstraintConstant != degreesHeightConstraint!.constant {
            degreesHeightConstraint?.constant = currentConstraintConstant
        }
        
        degrees.alpha = 1 - animationCompletionPercent*3
        timeLabel.alpha = 1 - animationCompletionPercent*2
        titleDegrees.alpha = animationCompletionPercent
  
    }
}


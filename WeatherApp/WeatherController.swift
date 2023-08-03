//
//  ViewController.swift
//  WeatherApp
//
//  Created by Мурат Кудухов on 22.07.2023.
//

import UIKit
import MapKit
import CoreLocation


final class WeatherController: UIViewController, CLLocationManagerDelegate {
    
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
        view.showsVerticalScrollIndicator = false
        view.isDirectionalLockEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let middleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.Bold(with: 22)
        label.text = "Boston"
        label.textColor = R.Colors.darkBg
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Now"
        label.font = R.Fonts.Bold(with: 16)
        label.textColor = R.Colors.darkBg
        label.textAlignment = .center
        return label
    }()
    
    private let degrees: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = R.Fonts.avenirBook(with: 176)
        label.text = "00˚"
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.textColor = R.Colors.darkBg
        label.textAlignment = .center
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
        label.font = R.Fonts.avenir(with: 18)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserLocation()
  
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        
        middleView.addSubview(backgroundImage)
        middleView.backgroundColor = .white
        middleView.addSubview(hourlyCollection)
        middleView.addSubview(imageView)
        middleView.addSubview(degrees)
        middleView.addSubview(weatherLabel)
        middleView.addSubview(locationLabel)
        middleView.addSubview(timeLabel)
        middleView.addSubview(dailyCollection)
//        view.addSubview(windLabel)
//        view.addSubview(windImageView)
//        view.addSubview(speedLabel)
       // view.addSubview(stackViewV)
        middleView.addSubview(searchButton)
        contentView.addSubview(middleView)
        scrollView.addSubview(contentView)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        constraints()
        
        
    }
    
    func settings() {
        APIManager.shared.getweather { [weak self] weatherData in
            DispatchQueue.main.sync {
                guard let self else {return}
                
//let rainWeatherCodes: [Int] = [61,63,65,81,82,95,96,99]
                
                
                self.removeAllArrangedSubviews(from: self.stackViewV)
                self.degrees.text = "\(Int(weatherData.currentWeather.temperature))˚"
                self.speedLabel.text = "\(weatherData.currentWeather.windspeed)m/s"
                self.weatherLabel.text = weatherCodes["\(weatherData.currentWeather.weathercode)"]
                self.imageView.image = UIImage(named: weatherImages["\(weatherData.currentWeather.weathercode)"]!)
                self.backgroundImage.image = UIImage(named: backgroundImg["\(weatherData.currentWeather.weathercode)"]!)
                
//                if rainWeatherCodes.contains(weatherData.currentWeather.weathercode) {
//                    self.degrees.textColor = R.Colors.background
//                    self.timeLabel.textColor = R.Colors.background
//                    self.locationLabel.textColor = R.Colors.background
//                    self.weatherLabel.textColor = R.Colors.background
//                    self.searchButton.tintColor = R.Colors.background
//                } else {
//                    self.degrees.textColor = R.Colors.darkBg
//                    self.timeLabel.textColor = R.Colors.darkBg
//                    self.locationLabel.textColor = R.Colors.darkBg
//                    self.weatherLabel.textColor = R.Colors.darkBg
//                    self.searchButton.tintColor = R.Colors.darkBg
//                }
                
                self.changeTheme()
                self.hourlyCollection.updateTable()
                self.dailyCollection.updateTable()
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
    
    //название - координаты
    func getCoordinates() {
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
                APIManager.shared.coordinates(latitude: self.latitude, longitude: self.longitude)
                self.settings()
            } else {
                print("ERROR")
            }
        }
    }
    
    //MARK: - User location
    
    func getUserLocation() {
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
                //let address = "\(placemark.postalCode ?? ""), \(placemark.locality ?? ""), \(placemark.country ?? "")"
                self.locationLabel.text = placemark.locality
                self.getCoordinates()
            }
        }
    }
    
    
    
    func searchTheCity() {
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
    }
    
    @objc
    func searchButtonTapped() {
        showSearchAlert(title: "City" , message: "Please enter the city")
    }
    
    func constraints() {
        hourlyCollection.translatesAutoresizingMaskIntoConstraints = false
        dailyCollection.translatesAutoresizingMaskIntoConstraints = false
        
        print("Const")
        
        NSLayoutConstraint.activate([
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1024),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
            dailyCollection.topAnchor.constraint(equalTo: hourlyCollection.bottomAnchor, constant: 8),
            dailyCollection.heightAnchor.constraint(equalToConstant: 300),
            
//            windLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            windLabel.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 16),
//
//            windImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
//            windImageView.topAnchor.constraint(equalTo: windLabel.bottomAnchor, constant: 8),
//
//            //speedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            speedLabel.leadingAnchor.constraint(equalTo: windImageView.trailingAnchor, constant: 8),
//            speedLabel.centerYAnchor.constraint(equalTo: windImageView.centerYAnchor),
            
            locationLabel.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 64),
            
            searchButton.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 64),
            searchButton.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -32),
            
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            timeLabel.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            
            imageView.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: degrees.bottomAnchor, constant: -24),
            imageView.heightAnchor.constraint(equalToConstant: 220),
            imageView.widthAnchor.constraint(equalToConstant: 220),
            
            degrees.centerXAnchor.constraint(equalTo: middleView.centerXAnchor, constant: 8),
            degrees.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 32),
            degrees.heightAnchor.constraint(equalToConstant: 200),
            degrees.widthAnchor.constraint(equalToConstant: 400),
            
            weatherLabel.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            weatherLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            weatherLabel.heightAnchor.constraint(equalToConstant: 50),
            weatherLabel.widthAnchor.constraint(equalToConstant: 150),
            //            menuButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 128),
            //            menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            
            
        ])
        
    }
}


extension WeatherController {
    func showSearchAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { tf in
            let cities = ["San Francisco", "Vladikavkaz", "Boston", "Moscow", "Viena", "Stambul", "San Jose", ""]
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
            //view.backgroundColor = R.Colors.darkBg
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
            //windLabel.textColor = R.Colors.darkBg
            backgroundImage.image = UIImage(named:"gradientBG")
        }
    }
    
    func locationManager( _ manager: CLLocationManager, didFailWithError error: Error) {
      print("didFailWithError \(error.localizedDescription)")
    }
    
    func locationManager( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        //print("didUpdateLocations \(newLocation)")
        location = newLocation
//        print(location as Any)
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
}


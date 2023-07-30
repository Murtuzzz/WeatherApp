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
    
    private var longitude = 0.0
    private var latitude = 0.0
    private var userLatitude = "0"
    private var userLongitude = "0"
    private let geoCoder = CLGeocoder()
    static let shared = WeatherController()
    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    
    
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
        label.text = "--˚"
        label.textColor = R.Colors.darkBg
        label.textAlignment = .center
        return label
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.image = UIImage(systemName:"cloud.sun")
        view.contentMode = .scaleAspectFill
        view.tintColor = R.Colors.darkBg
        //view.backgroundColor = .cyan
//        view.layer.shadowColor = UIColor.gray.cgColor
//        view.layer.shadowOpacity = 0.5;
//        view.layer.shadowRadius = 0.5;
//        view.layer.shadowOffset = CG
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
        view.addSubview(backgroundImage)
        view.backgroundColor = .white
        //getCity()
        //view.addSubview(menuButton)
        view.addSubview(imageView)
        view.addSubview(degrees)
        view.addSubview(weatherLabel)
        view.addSubview(locationLabel)
        view.addSubview(timeLabel)
        view.addSubview(windLabel)
        view.addSubview(windImageView)
        view.addSubview(speedLabel)
       // view.addSubview(stackViewV)
        view.addSubview(searchButton)
        // menuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        constraints()
        weatherImageAnimation()
        
    }
    
    func settings() {
        APIManager.shared.getweather { [weak self] weatherData in
            DispatchQueue.main.sync {
                guard let self else {return}
                
                self.changeTheme()
                
                self.removeAllArrangedSubviews(from: self.stackViewV)
                self.degrees.text = "\(Int(weatherData.currentWeather.temperature))˚"
                self.speedLabel.text = "\(weatherData.currentWeather.windspeed)m/s"
                self.weatherLabel.text = weatherCodes["\(weatherData.currentWeather.weathercode)"]
                self.imageView.image = UIImage(named: weatherImages["\(weatherData.currentWeather.weathercode)"]!)
                
                
                
                //let dateStr = weatherData.daily.time[3]
                //let weather = weatherData.daily.weathercode[3]
                //let weatherImage = weatherImages["\(weather)"] ?? ""
                //let tuesdayInfo = StackView(dateStr, weatherCodes["\(weather)"] ?? "error", with:weatherImage)
                //self.stackViewV.addArrangedSubview(tuesdayInfo)
                
                //let dateStr2 = weatherData.daily.time[4]
                //let weather2 = weatherData.daily.weathercode[4]
                //let weatherImage2 = weatherImages["\(weather2)"] ?? ""
                //let wednesdayInfo = StackView(dateStr2, weatherCodes["\(weather2)"] ?? "error", with:weatherImage2)
                //self.stackViewV.addArrangedSubview(wednesdayInfo)
                
                //let dateStr3 = weatherData.daily.time[5]
                //let weather3 = weatherData.daily.weathercode[5]
                //let weatherImage3 = weatherImages["\(weather3)"] ?? ""
                //let thursdayInfo = StackView(dateStr3, weatherCodes["\(weather3)"] ?? "error", with:weatherImage3)
                //self.stackViewV.addArrangedSubview(thursdayInfo)
                
                //let dateStr4 = weatherData.daily.time[6]
             //   let weather4 = weatherData.daily.weathercode[6]
                //let weatherImage4 = weatherImages["\(weather4)"] ?? ""
                //let fridayInfo = StackView(dateStr4, weatherCodes["\(weather4)"] ?? "error", with:weatherImage4)
                //self.stackViewV.addArrangedSubview(fridayInfo)
                
                
            }
        }
    }
    
    func weatherImageAnimation() {
        let x = view.frame.height/2 - 110
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
        // Запустите анимацию
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
    
    func locationManager( _ manager: CLLocationManager, didFailWithError error: Error) {
      print("didFailWithError \(error.localizedDescription)")
    }
    
    func locationManager( _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations \(newLocation)")
        location = newLocation
        print(location as Any)
        updateLabels()
      
        
    }
    
    func updateLabels() {
        if let location = location {
            userLatitude = String( format: "%.8f", location.coordinate.latitude)
            userLongitude = String( format: "%.8f", location.coordinate.longitude)
            print(userLongitude)
            print(userLatitude)
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
    
    
    
    func getCity(location: CLLocation) {
        print("GETCITY")
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first {
                print("GETCITY2")
                // Получение информации о местоположении
                let address = "\(placemark.postalCode ?? ""), \(placemark.locality ?? ""), \(placemark.country ?? "")"
                print(address)
                self.locationLabel.text = placemark.locality
                self.getCoordinates()
                print(placemark.locality as Any)
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
        
        NSLayoutConstraint.activate([
//
//            stackViewV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -64),
//            stackViewV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            //stackViewV.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 32),
            
            windLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            windLabel.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 16),
            
            windImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
            windImageView.topAnchor.constraint(equalTo: windLabel.bottomAnchor, constant: 8),
            
            //speedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            speedLabel.leadingAnchor.constraint(equalTo: windImageView.trailingAnchor, constant: 8),
            speedLabel.centerYAnchor.constraint(equalTo: windImageView.centerYAnchor),
            
            locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            
            searchButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: degrees.bottomAnchor, constant: -24),
            imageView.heightAnchor.constraint(equalToConstant: 220),
            imageView.widthAnchor.constraint(equalToConstant: 220),
            
            degrees.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            degrees.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 32),
            degrees.heightAnchor.constraint(equalToConstant: 200),
            degrees.widthAnchor.constraint(equalToConstant: 400),
            
            weatherLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
            view.backgroundColor = R.Colors.darkBg
        } else {
            searchButton.tintColor = R.Colors.darkBg
            locationLabel.textColor = R.Colors.darkBg
            degrees.textColor = R.Colors.darkBg
            imageView.tintColor = R.Colors.darkBg
            timeLabel.textColor = R.Colors.darkBg
            speedLabel.textColor = R.Colors.darkBg
            weatherLabel.textColor = R.Colors.darkBg
            windImageView.tintColor = R.Colors.darkBg
            windLabel.textColor = R.Colors.darkBg
            view.backgroundColor = .white
        }
    }
}


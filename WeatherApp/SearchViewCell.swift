//
//  SearchViewCell.swift
//  WeatherApp
//
//  Created by Мурат Кудухов on 14.08.2023.
//

import UIKit
import CoreLocation

final class SearchViewCell: UITableViewCell {
    static let id = "SearchViewCell"
    private var longitude = 0.0
    private var latitude = 0.0
    
    private let geoCoder = CLGeocoder()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = R.Fonts.avenirBook(with: 20)
        label.textColor = R.Colors.darkBg
        return label
    }()
    
    private let degrees: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = R.Fonts.avenirBook(with: 22)
        return label
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.1
        view.layer.borderColor = R.Colors.blue.cgColor
        view.backgroundColor = R.Colors.lightBlue.withAlphaComponent(0.4)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(container)
        addSubview(cityLabel)
        addSubview(degrees)
        //getCoordinates()
        backgroundColor = .clear
        constraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(cityName: String) {
        cityLabel.text = cityName
    }
    
    private func constraints() {
        
        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            cityLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            container.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            degrees.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            degrees.centerYAnchor.constraint(equalTo: cityLabel.centerYAnchor),
            
        ])
    }
    
}

extension SearchViewCell {
    
    func dataSetup() {
        APIWeatherManager.shared.getweather { [weak self] weatherData in
            DispatchQueue.main.sync {
                guard let self else {return}
                
                print("DataSetup")
                self.degrees.text = "\(Int(weatherData.currentWeather.temperature))˚"
            }
        }
    }
                
    
    func getCoordinates() {
        print("GetCoordinates")
        self.geoCoder.geocodeAddressString(self.cityLabel.text ?? "Oslo") { (placemarks, error) in
            if error != nil {
                self.cityLabel.text = ""
                return
            }
            
            if let placemarks = placemarks, let location = placemarks.first?.location {
                let coordinates = location.coordinate
                self.latitude = coordinates.latitude
                self.longitude = coordinates.longitude
                APIWeatherManager.shared.coordinates(latitude: self.latitude, longitude: self.longitude)
                
                self.dataSetup()
            } else {
                print("ERROR")
            }
        }
    }
    
    
}

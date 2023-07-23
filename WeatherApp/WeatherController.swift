//
//  ViewController.swift
//  WeatherApp
//
//  Created by Мурат Кудухов on 22.07.2023.
//

import UIKit
import UIKit

class WeatherController: UIViewController {
    
    private var isMenuActivate = false
    
    private let tuesdayInfo = StackView("Tue,Apr,14", "11º 0º", with:"cloud")
    private let wednesdayInfo = StackView("Wed,Apr,15", "16º 2º", with:"sun.max")
    private let thursdayInfo = StackView("Thu,Apr,16 ", "23º 8º", with:"cloud.sun")
    private let fridayInfo = StackView("Fir,Apr,17   ", "26º 8º", with:"cloud.sun")
    
    private let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open", for: .normal)
        return button
    }()
    
    private let sideMenu: CitiesView = {
        let view = CitiesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: -UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height)
        return view
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
        label.text = "Vladikavkaz, Russia"
        label.font = R.Fonts.Bold(with: 18)
        label.textColor = R.Colors.darkBg
        label.textAlignment = .center
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Now"
        label.font = R.Fonts.Bold(with: 14)
        label.textColor = R.Colors.darkBg
        label.textAlignment = .center
        return label
    }()
    
    private let degrees: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "23º"
        label.font = R.Fonts.Bold(with: 72)
        label.textColor = R.Colors.darkBg
        label.textAlignment = .center
        return label
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName:"cloud.sun")
        view.contentMode = .scaleAspectFit
        view.tintColor = R.Colors.darkBg
        return view
    }()
    
    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mostly cloudy"
        label.font = R.Fonts.avenir(with: 18)
        label.textAlignment = .center
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


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.Colors.background
        view.addSubview(sideMenu)
        //view.addSubview(menuButton)
        view.addSubview(imageView)
        view.addSubview(degrees)
        view.addSubview(weatherLabel)
        view.addSubview(locationLabel)
        view.addSubview(timeLabel)
        view.addSubview(windLabel)
        view.addSubview(windImageView)
        view.addSubview(speedLabel)
        view.addSubview(stackViewV)
        stackViewV.addArrangedSubview(tuesdayInfo)
        stackViewV.addArrangedSubview(wednesdayInfo)
        stackViewV.addArrangedSubview(thursdayInfo)
        stackViewV.addArrangedSubview(fridayInfo)
       // menuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        constraints()
    }

    // Функция для открытия бокового меню
    @objc func openMenu() {
        if !isMenuActivate {
            UIView.animate(withDuration: 0.3) {
                self.sideMenu.frame.origin.x = -80
                self.isMenuActivate.toggle()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.sideMenu.frame.origin.x = -UIScreen.main.bounds.width
                self.isMenuActivate.toggle()
            }
        }
    }
    
    func constraints() {
        
        NSLayoutConstraint.activate([
            
            stackViewV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -64),
            stackViewV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //stackViewV.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 32),
            
            windLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            windLabel.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 64),
            
            windImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -16),
            windImageView.topAnchor.constraint(equalTo: windLabel.bottomAnchor, constant: 8),
            
            //speedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            speedLabel.leadingAnchor.constraint(equalTo: windImageView.trailingAnchor, constant: 8),
            speedLabel.centerYAnchor.constraint(equalTo: windImageView.centerYAnchor),
            
            locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -168),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            
            degrees.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            degrees.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            degrees.heightAnchor.constraint(equalToConstant: 60),
            degrees.widthAnchor.constraint(equalToConstant: 110),
            
            weatherLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherLabel.topAnchor.constraint(equalTo: degrees.bottomAnchor, constant: 32),
            weatherLabel.heightAnchor.constraint(equalToConstant: 50),
            weatherLabel.widthAnchor.constraint(equalToConstant: 150),
//            menuButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 128),
//            menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            
        
        ])
        
    }
}


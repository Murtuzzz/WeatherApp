//
//  WeekdayViewCell.swift
//  WeatherApp
//
//  Created by Мурат Кудухов on 01.08.2023.
//

import UIKit

final class DailyCell: UICollectionViewCell {
    static let id = "DailyViewCell"
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        return view
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = R.Fonts.avenirBook(with: 16)
        return label
    }()
    
    private let weatherImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private let maxTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = R.Fonts.avenirBook(with: 16)
        return label
    }()
    
    private let minTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = R.Fonts.avenirBook(with: 16)
        return label
    }()
    
    private let minMaxView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.image = UIImage(named: "minMax")
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(weatherImage)
        stackView.addArrangedSubview(minTempLabel)
//        stackView.addArrangedSubview(minMaxView)
        stackView.addArrangedSubview(maxTempLabel)
        addSubview(stackView)
        addSubview(minMaxView)
        //backgroundColor = .white
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configurate(maxTemp: String, image: String, date: String, minTemp: String) {
        maxTempLabel.text = maxTemp
        minTempLabel.text = minTemp
        weatherImage.image = UIImage(named: image)
        dayLabel.text = date
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            weatherImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 64),
            weatherImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -200),
            
            maxTempLabel.leadingAnchor.constraint(equalTo: minTempLabel.trailingAnchor),
       
            
            minMaxView.leadingAnchor.constraint(equalTo: minTempLabel.trailingAnchor, constant: 16),
            minMaxView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            minMaxView.heightAnchor.constraint(equalToConstant: 10),
            minMaxView.widthAnchor.constraint(equalToConstant: 88)
            
            
        ])
    }
}

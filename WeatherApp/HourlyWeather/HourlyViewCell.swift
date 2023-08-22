//
//  WeekdayViewCell.swift
//  WeatherApp
//
//  Created by Мурат Кудухов on 01.08.2023.
//

import UIKit

final class HourlyViewCell: UICollectionViewCell {
    static let id = "HourlyViewCell"
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
//        view.spacing = 5
        return view
    }()
    
    private let dateLabel: UILabel = {
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
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = R.Colors.darkBg
        label.font = R.Fonts.avenirBook(with: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(weatherImage)
        stackView.addArrangedSubview(tempLabel)
        addSubview(stackView)
        backgroundColor = .clear
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configurate(temp: String, image: String, date: String) {
        tempLabel.text = temp
        weatherImage.image = UIImage(named: image)
        dateLabel.text = date
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            weatherImage.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 35),
            weatherImage.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -35),
            
            
        ])
    }
}

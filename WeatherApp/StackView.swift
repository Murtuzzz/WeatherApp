//
//  StackView.swift
//  WeatherApp
//
//  Created by Мурат Кудухов on 23.07.2023.
//

import UIKit

final class StackView: UIView {
    
    private let stackViewH: UIStackView = {
        let view = UIStackView()
        view.spacing = 64
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Wind"
        label.font = R.Fonts.Bold(with: 16)
        label.textColor = R.Colors.darkBg
        label.textAlignment = .center
        return label
    }()
    
    private let degreeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Wind"
        label.font = R.Fonts.Bold(with: 16)
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
    
    init(_ date: String, _ degree: String, with image: String) {
        super.init(frame: .zero)
        dateLabel.text = date
        degreeLabel.text = degree
        windImageView.image = UIImage(systemName: image)
        addSubview(stackViewH)
        stackViewH.addArrangedSubview(dateLabel)
        stackViewH.addArrangedSubview(windImageView)
        stackViewH.addArrangedSubview(degreeLabel)
        
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            stackViewH.topAnchor.constraint(equalTo: topAnchor),
            stackViewH.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackViewH.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackViewH.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
}

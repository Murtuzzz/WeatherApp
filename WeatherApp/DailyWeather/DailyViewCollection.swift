//
//  DailyWeatherCollection.swift
//  WeatherApp
//
//  Created by Мурат Кудухов on 03.08.2023.
//
//

import UIKit

struct DaysItems {
    let day: String
    let weatherIcon: String
    let temp: String
}

final class DailyViewCollection: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var collectionView: UICollectionView?
    private var dataSource: [DaysItems] = []
    private var blurEffect = UIBlurEffect(style: .light)
    private var blurEffectView = UIVisualEffectView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        collectionApperance()


    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionApperance() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)


        APIManager.shared.getweather { [weak self] weatherData in

            DispatchQueue.main.sync {

//                print(weatherData.daily.time)
//                print(weatherData.hourly.temperature2M)
//                print(weatherData.hourly.time)
//                print(weatherData.hourly.weathercode)

                print("Day \(weatherData.daily.weathercode)")
                
                let week:[String] = weatherData.daily.time
                let weekDays:[String] = self!.dateFormatter(week: week)
                let dailyWc = weatherData.daily.weathercode

                self?.dataSource = [.init(day: weekDays[0], weatherIcon: weatherImages["\(dailyWc[0])"]!, temp: "00"),
                                    .init(day: weekDays[1], weatherIcon: weatherImages["\(dailyWc[1])"]!, temp: "00"),
                                    .init(day: weekDays[2], weatherIcon: weatherImages["\(dailyWc[2])"]!, temp: "00"),
                                    .init(day: weekDays[3], weatherIcon: weatherImages["\(dailyWc[3])"]!, temp: "00"),
                                    .init(day: weekDays[4], weatherIcon: weatherImages["\(dailyWc[4])"]!, temp: "00"),
                                    .init(day: weekDays[5], weatherIcon: weatherImages["\(dailyWc[5])"]!, temp: "00"),
                                    .init(day: weekDays[6], weatherIcon: weatherImages["\(dailyWc[6])"]!, temp: "00")]
                
                self?.collectionView!.reloadData()
            }
        }

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.frame = bounds
        blurEffectView.layer.cornerRadius = 10
        blurEffectView.layer.masksToBounds = true
        blurEffectView.layer.borderWidth = 1
        blurEffectView.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.5).cgColor
        blurEffectView.alpha = 0.2
        addSubview(blurEffectView)

        guard let collectionView = collectionView else {return}

        collectionView.register(DailyCell.self, forCellWithReuseIdentifier: DailyCell.id)

        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.layer.cornerRadius = 15
        collectionView.showsHorizontalScrollIndicator = false


        addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),

            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor)

        ])
    }

    public func updateTable() {
        collectionView?.removeFromSuperview()
        blurEffectView.removeFromSuperview()
        collectionApperance()
        print("Update")
    }

}

extension DailyViewCollection {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCell.id, for: indexPath) as! DailyCell

        let daysArray = dataSource[indexPath.row]

        cell.configurate(temp: daysArray.temp, image: daysArray.weatherIcon, date: daysArray.day)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 40)
    }
}

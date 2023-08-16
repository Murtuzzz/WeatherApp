//
//  WeekView.swift
//  WeatherApp
//
//  Created by Мурат Кудухов on 31.07.2023.
//

import UIKit

struct HourItems {
    let time: String
    let weatherIcon: String
    let temp: String
}

final class HourlyViewCollection: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//    private let container: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    private var collectionView: UICollectionView?
    private var dataSource: [HourItems] = []
    private var blurEffect = UIBlurEffect(style: .light)
    private var blurEffectView = UIVisualEffectView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        collectionApperance()
        //addSubview(container)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionApperance() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)

        
        APIWeatherManager.shared.getweather { [weak self] weatherData in
            
            DispatchQueue.main.sync {
                
                let weekHourlyTemp = self?.getWeekHourlyTemp(weatherData.hourly.temperature2M)
                let wc = weatherData.hourly.weathercode
                                
                self?.dataSource = [
                    .init(time: "00", weatherIcon: weatherImages["\(wc[0])"] ?? "", temp: "\(Int(weekHourlyTemp![0][0] ))˚"),
                    .init(time: "01", weatherIcon: weatherImages["\(wc[1])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][1] ?? 00))˚"),
                    .init(time: "02", weatherIcon: weatherImages["\(wc[2])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][2] ?? 00))˚"),
                    .init(time: "03", weatherIcon: weatherImages["\(wc[3])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][3] ?? 00))˚"),
                    .init(time: "04", weatherIcon: weatherImages["\(wc[4])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][4] ?? 00))˚"),
                    .init(time: "05", weatherIcon: weatherImages["\(wc[5])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][5] ?? 00))˚"),
                    .init(time: "06", weatherIcon: weatherImages["\(wc[6])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][6] ?? 00))˚"),
                    .init(time: "07", weatherIcon: weatherImages["\(wc[7])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][7] ?? 00))˚"),
                    .init(time: "08", weatherIcon: weatherImages["\(wc[8])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][8] ?? 00))˚"),
                    .init(time: "09", weatherIcon: weatherImages["\(wc[9])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][9] ?? 00))˚"),
                    .init(time: "10", weatherIcon: weatherImages["\(wc[10])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][10] ?? 00))˚"),
                    .init(time: "11", weatherIcon: weatherImages["\(wc[11])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][11] ?? 00))˚"),
                    .init(time: "12", weatherIcon: weatherImages["\(wc[12])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][12] ?? 00))˚"),
                    .init(time: "13", weatherIcon: weatherImages["\(wc[13])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][13] ?? 00))˚"),
                    .init(time: "14", weatherIcon: weatherImages["\(wc[14])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][14] ?? 00))˚"),
                    .init(time: "15", weatherIcon: weatherImages["\(wc[15])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][15] ?? 00))˚"),
                    .init(time: "16", weatherIcon: weatherImages["\(wc[16])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][16] ?? 00))˚"),
                    .init(time: "17", weatherIcon: weatherImages["\(wc[17])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][17] ?? 00))˚"),
                    .init(time: "18", weatherIcon: weatherImages["\(wc[18])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][18] ?? 00))˚"),
                    .init(time: "19", weatherIcon: weatherImages["\(wc[19])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][19] ?? 00))˚"),
                    .init(time: "20", weatherIcon: weatherImages["\(wc[20])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][20] ?? 00))˚"),
                    .init(time: "21", weatherIcon: weatherImages["\(wc[21])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][21] ?? 00))˚"),
                    .init(time: "22", weatherIcon: weatherImages["\(wc[22])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][22] ?? 00))˚"),
                    .init(time: "23", weatherIcon: weatherImages["\(wc[23])"] ?? "", temp: "\(Int(weekHourlyTemp?[0][23] ?? 00))˚"),
                ]
                self?.collectionView!.reloadData()
            }
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.frame = bounds
        blurEffectView.layer.cornerRadius = 10
        blurEffectView.layer.masksToBounds = true
        blurEffectView.layer.borderWidth = 1
        blurEffectView.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.6).cgColor
        blurEffectView.alpha = 0.2
        addSubview(blurEffectView)
        
        guard let collectionView = collectionView else {return}
        
        collectionView.register(HourlyViewCell.self, forCellWithReuseIdentifier: HourlyViewCell.id)
        
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
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
        print("TableHourlyUpdate")
    }
    
}

extension HourlyViewCollection {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyViewCell.id, for: indexPath) as! HourlyViewCell
        
        let daysArray = dataSource[indexPath.row]
        
        cell.configurate(temp: daysArray.temp, image: daysArray.weatherIcon, date: daysArray.time)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 50, height: collectionView.frame.height)
    }
}

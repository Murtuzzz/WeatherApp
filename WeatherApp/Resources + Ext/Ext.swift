//
//  Ext.swift
//  WeatherApp
//
//  Created by Мурат Кудухов on 23.07.2023.
//

import UIKit

extension UIViewController {
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        ac.addTextField { tf in
            let cities = ["Vladikavkaz","Moscow","New-York","Stambul","Viewna"]
            tf.placeholder = cities.randomElement()
        }
        
        let search = UIAlertAction(title: "Search", style: .default) { action in
            let textField = ac.textFields?.first
            guard let cityName = textField?.text else {return}
            if cityName != "" {
                print("search info for the \(cityName)")
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(search)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
    
    func darkTheme() -> UIColor {
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(hexString: "#e2eaf2")
        } else {
            return UIColor(hexString: "#2f3543")
        }
    }
    
    public func lightTheme() -> UIColor {
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor(hexString: "#2f3543")
        } else {
            return UIColor(hexString: "#e2eaf2")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title:"Ok", style: .default)
        alert.addAction(okAction)
        present(alert,animated: true)
    }
}
  
extension UIView {
    
    func dateFormatter(week: [String]) -> [String] {
        var weekDays: [String] = []
        for day in week {
            let dateString = day
            var formattedDate = ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyy-MM-dd"
            
            if let date = dateFormatter.date(from: dateString) {
                let newDayFormatter = DateFormatter()
                newDayFormatter.dateFormat = "EEE,d"
                
                formattedDate = newDayFormatter.string(from: date)
                weekDays.append(formattedDate)
            }
        }
        return weekDays
    }
    
    func getWeekHourlyTemp(_ list: [Double]) -> [[Double]] {
        var list = list
        var weekHourlyTemp: [[Double]] = []
        var array: [Double] = []
        let index = 0

        for _ in 0...7 {
            for el in list {
                if array.count != 24 {
                    array.append(el)
                    list.remove(at: index)
                } else {
                    weekHourlyTemp.append(array)
                    array = []
                }
            }
        }
        return weekHourlyTemp
    }
    
    func getAvgDayTemp(_ list: [[Double]]) -> [Int] {
        var averageDayTemp: [Int] = []
        
        for ind in 0...6 {
            var sum = 0.0
            for el in list[ind] {
                sum += el
            }
            let avgTemp = sum/24
            averageDayTemp.append(Int(avgTemp))
        }
        return averageDayTemp
    }
}

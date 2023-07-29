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
  

//
//  R.swift
//  WeatherApp
//
//  Created by Мурат Кудухов on 22.07.2023.
//

import UIKit

enum R {
    enum Colors {
        
        static var background = UIColor(hexString: "#e2eaf2")
        static var darkBg = UIColor(hexString: "#2f3543")
        
    }
    
    enum Fonts {
        static func Italic(with size: CGFloat) -> UIFont {
            UIFont(name: "GillSans-SemiBoldItalic", size: size) ?? UIFont()
            
        }
        static func nonItalic(with size: CGFloat) -> UIFont {
            UIFont(name: "ArialMT", size: size) ?? UIFont()
        }
        
        static func avenir(with size: CGFloat) -> UIFont {
            UIFont(name: "AvenirNext-Bold", size: size) ?? UIFont()
        }
        
        static func Bold(with size: CGFloat) -> UIFont {
            UIFont(name: "HelveticaNeue-CondensedBold", size: size) ?? UIFont()
        }
        
        static func avenirItalic(with size: CGFloat) -> UIFont {
            UIFont(name: "AvenirNext-MediumItalic", size: size) ?? UIFont()
        }
    }
}

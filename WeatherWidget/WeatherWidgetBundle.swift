//
//  WeatherWidgetBundle.swift
//  WeatherWidget
//
//  Created by Мурат Кудухов on 06.08.2023.
//

import WidgetKit
import SwiftUI

@main
struct WeatherWidgetBundle: WidgetBundle {
    var body: some Widget {
        WeatherWidget()
        WeatherWidgetLiveActivity()
    }
}

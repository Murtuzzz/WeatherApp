//
//  APIManager.swift
//  WeatherApp
//
//  Created by Мурат Кудухов on 23.07.2023.
//

import UIKit


class APIWeatherManager {
    static let shared = APIWeatherManager()

    var urlString = "https://api.open-meteo.com/v1/forecast?latitude=43.01926&longitude=44.6746016&current_weather=true&hourly=temperature_2m,relativehumidity_2m,windspeed_10m,weathercode&daily=weathercode,temperature_2m_max,temperature_2m_min&windspeed_unit=ms&timezone=Europe%2FMoscow"
    
    func coordinates(latitude: Double, longitude: Double) {
        self.urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current_weather=true&hourly=temperature_2m,relativehumidity_2m,windspeed_10m,weathercode&daily=weathercode,temperature_2m_max,temperature_2m_min&windspeed_unit=ms&timezone=Europe%2FMoscow"
        print("API coordinates Sting set")
    }
    
    func getweather(completion: @escaping (WeatherData) -> Void) {
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data else {return}
            if let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) {
                completion(weatherData)
                
            } else {
                print("FAIL")
            }
        }
        task.resume()
    }
    
}

//
//  APICitiesManager.swift
//  WeatherApp
//
//  Created by Мурат Кудухов on 15.08.2023.
//

import Foundation

class APICitiesManager {
    
    static let shared = APICitiesManager()
    
    func parseJSONFromFile(completion: @escaping (CitiesData) -> Void) {
       
        guard let fileURL = Bundle.main.url(forResource: "cities", withExtension: "json") else {
            print("Файл не найден")
            return
        }
        let request = URLRequest(url: fileURL)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in guard let data else {return}
            if let citiesData = try? JSONDecoder().decode(CitiesData.self, from: data) {
                completion(citiesData)
            } else {
                print("CitiesData FAIL")
            }
        }
        task.resume()
    }
}



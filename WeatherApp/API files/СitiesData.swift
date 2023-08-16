// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let cities = try? JSONDecoder().decode(Cities.self, from: jsonData)

import Foundation

// MARK: - Cities
struct CitiesData: Codable {
    let city: [City]
}

// MARK: - City
struct City: Codable {
    let cityID, countryID, regionID, name: String

    enum CodingKeys: String, CodingKey {
        case cityID = "city_id"
        case countryID = "country_id"
        case regionID = "region_id"
        case name
    }
}

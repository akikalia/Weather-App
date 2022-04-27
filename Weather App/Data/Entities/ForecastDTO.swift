//
//  Forecast.swift
//  Weather App
//
//  Created by Alex Kikalia on 23.04.22.
//

import Foundation

struct ForecastDTO: Codable {
    let coord: CoordDTO
    let weather: [WeatherDTO]
    let base: String
    let main: MainDTO
    let visibility: Int
    let wind: WindDTO
    let clouds: CloudsDTO
    let dt: Int
    let sys: SysDTO
    let timezone, id: Int
    let name: String
    let cod: Int
}

struct CloudsDTO: Codable {
    let all: Int
}

struct CoordDTO: Codable {
    let lon, lat: Double
}

struct MainDTO: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

struct SysDTO: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

struct WeatherDTO: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

struct WindDTO: Codable {
    let speed: Double
    let deg: Int
}

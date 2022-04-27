//
//  Config.swift
//  Weather App
//
//  Created by Alex Kikalia on 23.04.22.
//

import Foundation

enum Config {
    static let weatherAPIBaseURL = "api.openweathermap.org"
    static let weatherAPIAccesstoken = "5bea068f287ea513788d00f99b61720a"
    static let weatherImageURLFormat = "https://openweathermap.org/img/wn/%@@2x.png"

    // Endpoints
    static let weatherAPIForecastPath = "/data/2.5/weather"
}

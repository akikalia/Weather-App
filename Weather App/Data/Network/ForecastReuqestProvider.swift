//
//  ForecastReuqestProvider.swift
//  Weather App
//
//  Created by Alex Kikalia on 26.04.22.
//

import Foundation

final class ForecastRequestProvider {
    private let components: URLComponents

    init() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Config.weatherAPIBaseURL
        components.path = Config.weatherAPIForecastPath
        let parameters = ["appid": Config.weatherAPIAccesstoken,
                          "units": "metric"]
        components.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        self.components = components
    }

    func getRequest(for city: String) -> URLRequest {
        var componentsCopy = components
        componentsCopy.queryItems?.append(URLQueryItem(name: "q", value: city))
        let url = componentsCopy.url!
        return URLRequest(url: url)
    }
}

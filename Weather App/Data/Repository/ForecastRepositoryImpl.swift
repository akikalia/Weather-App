//
//  ForecastRepositoryImpl.swift
//  Weather App
//
//  Created by Alex Kikalia on 23.04.22.
//

import Foundation
import Combine

final class ForecastRepositoryImpl: ForecastRepository {

    private let networkService: NetworkService
    private let forecastRequestProvider: ForecastRequestProvider

    init(networkService: NetworkService,
         forecastRequestProvider: ForecastRequestProvider) {
        self.networkService = networkService
        self.forecastRequestProvider = forecastRequestProvider
    }

    func getForecastPublisher(for city: String) -> AnyPublisher<Forecast, Error> {
        let request = forecastRequestProvider.getRequest(for: city)
        return networkService
            .call(request: request)
            .map(mapToForecast)
            .eraseToAnyPublisher()
    }
}

// MARK: - Private Methods

extension ForecastRepositoryImpl {
    private func mapToForecast(forecastDTO: ForecastDTO) -> Forecast {
        var imageURL: URL?
        var description: String?
        if let firstEntry = forecastDTO.weather.first {
            let url = String(format: Config.weatherImageURLFormat, firstEntry.icon)
            imageURL = URL(string: url)
            description = firstEntry.weatherDescription
        }
        return Forecast(city: forecastDTO.name,
                        country: getCountry(code: forecastDTO.sys.country),
                        description: description,
                        temperature: forecastDTO.main.temp,
                        image: imageURL)
    }

    private func getCountry(code: String) -> String {
        let locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let name = locale.displayName(forKey: .countryCode, value: code)
        guard let name = name else { return code }
        return name
    }
}

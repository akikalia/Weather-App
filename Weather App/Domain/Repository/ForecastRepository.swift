//
//  ForecastRepository.swift
//  Weather App
//
//  Created by Alex Kikalia on 23.04.22.
//

import Combine

enum ForecastRepositoryError: Error {
    case networkProblem
    case requestProblem
}

protocol ForecastRepository {
    func getForecastPublisher(for city: String) -> AnyPublisher<Forecast, Error>
}

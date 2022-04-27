//
//  GetCurrentLocationForecastUseCase.swift
//  Weather App
//
//  Created by Alex Kikalia on 23.04.22.
//

import Foundation
import Combine

enum ForecastUseCaseError: Error {
    case locationError
    case networkError
}

final class GetCurrentLocationForecastUseCase {

    private let forecastRepository: ForecastRepository
    private let locationManager: LocationManager

    private var subscriptions = Set<AnyCancellable>()

    private var forecastSubject = PassthroughSubject<Forecast, ForecastUseCaseError>()

    init(forecastRepository: ForecastRepository,
         locationManager: LocationManager) {
        self.forecastRepository = forecastRepository
        self.locationManager = locationManager
    }

    func execute() -> AnyPublisher<Forecast, ForecastUseCaseError> {
        subscribeToLocationUpdates()
        return forecastSubject.eraseToAnyPublisher()
    }
}

// MARK: - Private Methods
extension GetCurrentLocationForecastUseCase {
    private func subscribeToLocationUpdates() {
        locationManager.getCurrentCityPublisher()
            .sink(receiveCompletion: { [weak self] error in
                self?.forecastSubject.send(completion: .failure(ForecastUseCaseError.locationError))
            },
                  receiveValue: { [weak self] currentCity in
                self?.fetchForecast(for: currentCity)
            }).store(in: &subscriptions)
    }

    private func fetchForecast(for city: String) {
        self.forecastRepository.getForecastPublisher(for: city)
            .sink(receiveCompletion: { [weak self] error in
                switch error {
                case .finished:
                    return
                default:
                    self?.forecastSubject.send(completion: .failure(ForecastUseCaseError.networkError))
                }
            },
                  receiveValue: { [weak self] forecast in
                self?.forecastSubject.send(forecast)
            }).store(in: &self.subscriptions)
    }
}

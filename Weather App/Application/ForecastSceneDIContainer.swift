//
//  ForecastSceneDIContainer.swift
//  Weather App
//
//  Created by Alex Kikalia on 27.04.22.
//

import Foundation

final class ForecastSceneDIContainer {

    private let networkService: NetworkService
    private let locationManager: LocationManager

    private lazy var forecastRequestProvider = ForecastRequestProvider()
    private lazy var forecastRepository: ForecastRepository = ForecastRepositoryImpl(networkService: networkService,
                                                                                     forecastRequestProvider: forecastRequestProvider)
    private lazy var forecastUseCase = GetCurrentLocationForecastUseCase(forecastRepository: forecastRepository,
                                                                         locationManager: locationManager)
    private lazy var forecastVC = ForecastViewController(viewModel: ForecastViewModel(useCase: forecastUseCase))

    init(networkService: NetworkService, locationManager: LocationManager) {
        self.networkService = networkService
        self.locationManager = locationManager
    }

    func makeForecastViewController() -> ForecastViewController { forecastVC }

}

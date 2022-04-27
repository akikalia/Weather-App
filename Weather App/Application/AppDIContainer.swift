//
//  AppDIContainer.swift
//  Weather App
//
//  Created by Alex Kikalia on 27.04.22.
//

import Foundation

final class AppDIContainer {

    private lazy var networkService: NetworkService = NetworkServiceImpl()
    private lazy var authentificationManager: AuthentificationManager = AuthentificationManagerDummy()
    private lazy var locationManager: LocationManager = LocationManagerImpl()

    func makeLoginSceneDIContainer() -> LoginSceneDIContainer {
        return LoginSceneDIContainer(authentificationManager: authentificationManager)
    }

    func makeForecastSceneDIContainer() -> ForecastSceneDIContainer {
        return ForecastSceneDIContainer(networkService: networkService,
                                        locationManager: locationManager)

    }
}

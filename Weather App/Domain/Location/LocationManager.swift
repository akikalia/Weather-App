//
//  LocationManager.swift
//  Weather App
//
//  Created by Alex Kikalia on 23.04.22.
//

import Combine

enum LocationError: Error {
    case permissionDenied
    case invalidLocation
}

protocol LocationManager {
    func getCurrentCityPublisher() -> AnyPublisher<String, LocationError>
}

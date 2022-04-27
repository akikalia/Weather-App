//
//  LocationManagerImpl.swift
//  Weather App
//
//  Created by Alex Kikalia on 23.04.22.
//

import CoreLocation
import Combine

final class LocationManagerImpl: NSObject, LocationManager {

    private let locationSubject = PassthroughSubject<String, LocationError>()
    private var subscriptions = Set<AnyCancellable>()

    private let geocoder = CLGeocoder()

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()

    func getCurrentCityPublisher() -> AnyPublisher<String, LocationError> {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.requestWhenInUseAuthorization()
        }
        return locationSubject.eraseToAnyPublisher()
    }
}

extension LocationManagerImpl: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            locationSubject.send(completion: .failure(.invalidLocation))
        case .denied:
            locationSubject.send(completion: .failure(.permissionDenied))
        case .notDetermined:
            return
        default:
            manager.distanceFilter = 2000
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self,
                  let city = placemarks?.first?.locality else { return }
            self.locationSubject.send(city)
        }
    }
}

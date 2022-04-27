//
//  AuthentificationManagerDummy.swift
//  Weather App
//
//  Created by Alex Kikalia on 25.04.22.
//

import Combine
import Foundation

final class AuthentificationManagerDummy: AuthentificationManager {
    func authentificateUser(username: String, password: String) -> AnyPublisher<Bool, Never> {
        // insecure dummy storage
        UserDefaults.standard.set(password, forKey: username)
        return Just(true).eraseToAnyPublisher()
    }
}

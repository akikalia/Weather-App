//
//  AuthentificationManager.swift
//  Weather App
//
//  Created by Alex Kikalia on 25.04.22.
//

import Combine

protocol AuthentificationManager {
    func authentificateUser(username: String, password: String) -> AnyPublisher<Bool, Never>
}

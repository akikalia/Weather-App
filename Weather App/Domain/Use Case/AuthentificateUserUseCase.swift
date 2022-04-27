//
//  AuthentificateUserUseCase.swift
//  Weather App
//
//  Created by Alex Kikalia on 25.04.22.
//

import Combine

final class AuthentificateUserUseCase {

    private let authManager: AuthentificationManager

    private var subscriptions = Set<AnyCancellable>()

    init(authManager: AuthentificationManager) {
        self.authManager = authManager
    }

    func execute(username: String, password: String) -> AnyPublisher<Bool, Never> {
        authManager.authentificateUser(username: username,
                                       password: password)
            .eraseToAnyPublisher()
    }
}

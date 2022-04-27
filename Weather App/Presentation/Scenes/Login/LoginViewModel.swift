//
//  LoginViewModel.swift
//  Weather App
//
//  Created by Alex Kikalia on 23.04.22.
//

import Combine

final class LoginViewModel {

    private enum Constants {
        static let incorrectCredentials = "Username or Password incorrect"
        static let insufficientData = "Please fill out all fields"
    }

    @Published var errorMessage: String?

    var username: String?
    var password: String?

    private let authUserUseCase: AuthentificateUserUseCase

    private var subscriptions = Set<AnyCancellable>()

    private let router: LoginRouter

    init(authUserUseCase: AuthentificateUserUseCase,
         loginRouter: LoginRouter) {
        self.authUserUseCase = authUserUseCase
        router = loginRouter
    }

    func onSubmit() {
        errorMessage = nil
        guard let username = username,
              let password = password else {
                  errorMessage = Constants.insufficientData
                  return
              }
        authUserUseCase.execute(username: username, password: password)
            .sink { [weak self] isValid in
                if isValid {
                    self?.router.navigate()
                } else {
                    self?.errorMessage = Constants.incorrectCredentials
                }
            }.store(in: &subscriptions)
    }
}

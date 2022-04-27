//
//  LoginSceneDIContainer.swift
//  Weather App
//
//  Created by Alex Kikalia on 27.04.22.
//

import Foundation
import UIKit

final class LoginSceneDIContainer {

    private let authentificationManager: AuthentificationManager

    private lazy var loginRouter: LoginRouter = LoginRouter()
    private lazy var authUserUseCase = AuthentificateUserUseCase(authManager: authentificationManager)
    private lazy var loginViewModel = LoginViewModel(authUserUseCase: authUserUseCase,
                                                     loginRouter: loginRouter)
    private lazy var loginVC = LoginViewController(viewModel: loginViewModel)

    init(authentificationManager: AuthentificationManager) {
        self.authentificationManager = authentificationManager
    }

    func makeLoginViewController(destinationVC: UIViewController) -> LoginViewController {
        loginRouter.setSource(loginVC)
        loginRouter.setDestination(destinationVC)
        return loginVC
    }
}

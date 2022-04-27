//
//  LoginRouter.swift
//  Weather App
//
//  Created by Alex Kikalia on 27.04.22.
//

import Foundation
import UIKit

final class LoginRouter {

    private weak var source: UIViewController?
    private var destination: UIViewController?

    func setSource(_ source: UIViewController) {
        self.source = source
    }
    
    func setDestination(_ destination: UIViewController) {
        self.destination = destination
    }

    func navigate() {
        guard let destination = destination else { return }
        source?.show(destination, sender: source)
    }
}

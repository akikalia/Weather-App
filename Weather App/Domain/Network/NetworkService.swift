//
//  NetworkService.swift
//  Weather App
//
//  Created by Alex Kikalia on 27.04.22.
//

import Foundation
import Combine

protocol NetworkService {
    func call<T: Decodable>(request: URLRequest) -> AnyPublisher<T, Error>
}

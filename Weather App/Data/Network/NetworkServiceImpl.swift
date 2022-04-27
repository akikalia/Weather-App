//
//  NetworkServiceImpl.swift
//  Weather App
//
//  Created by Alex Kikalia on 25.04.22.
//

import Foundation
import Combine

final class NetworkServiceImpl: NetworkService {

    private enum HTTPCodes {
        static let success = 200 ..< 300
        static let redirection = 300 ..< 400
        static let clientError = 400 ..< 500
        static let serverError = 500 ..< 600
    }

    private let decoder: JSONDecoder

    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    func call<T>(request: URLRequest) -> AnyPublisher<T, Error> where T : Decodable {
        URLSession
            .shared
            .dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse else { throw NetworkError.unexpectedResponse }
                switch response.statusCode {
                case HTTPCodes.success:
                    return data
                case HTTPCodes.redirection:
                    throw NetworkError.redirection
                case HTTPCodes.clientError:
                    throw NetworkError.clientError
                case HTTPCodes.serverError:
                    throw NetworkError.serverError
                default:
                    return data
                }
            }
            .decode(type: T.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum NetworkError: Error {
    case unexpectedResponse
    case redirection
    case clientError
    case serverError
}

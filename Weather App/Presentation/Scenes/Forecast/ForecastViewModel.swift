//
//  ForecastViewModel.swift
//  Weather App
//
//  Created by Alex Kikalia on 23.04.22.
//

import Foundation
import Combine

final class ForecastViewModel {

    private let currentForecastUseCase: GetCurrentLocationForecastUseCase

    private var subscriptions = Set<AnyCancellable>()

    @Published var imageURL: URL?
    @Published var description: String?
    @Published var location: String?

    @Published var shouldShowLoader: Bool = true
    @Published var shouldShowForecast: Bool = false
    @Published var shouldShowError: Bool = false
    @Published var shouldShowLocationPopup: Void?

    init(useCase: GetCurrentLocationForecastUseCase) {
        currentForecastUseCase = useCase
    }

    func onLoad() {
        bindData()
    }
}

// MARK: - Private Methods

extension ForecastViewModel {
    private func bindData() {
        currentForecastUseCase.execute()
            .sink(receiveCompletion: { [weak self] error in
                switch error {
                case .failure(.networkError):
                    self?.showError()
                case .failure(.locationError):
                    self?.showError()
                    self?.shouldShowLocationPopup = ()
                default:
                    return
                }
            },
                  receiveValue: { [weak self] forecast in
                guard let self = self else { return }
                self.imageURL = forecast.image
                self.description = String(format: "%.0f\u{00B0}C | %@",
                                          forecast.temperature,
                                          (forecast.description ?? ""))
                self.location = String(format: "%@, %@",
                                       forecast.city,
                                       forecast.country)
                self.showForecast()
            }).store(in: &subscriptions)
    }

    private func showError() {
        shouldShowLoader = false
        shouldShowForecast = false
        shouldShowError = true
    }

    private func showLoader() {
        shouldShowLoader = true
        shouldShowForecast = false
        shouldShowError = false
    }

    private func showForecast() {
        shouldShowLoader = false
        shouldShowForecast = true
        shouldShowError = false
    }
}

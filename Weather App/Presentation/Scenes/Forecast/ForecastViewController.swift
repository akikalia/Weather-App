//
//  ForecastViewController.swift
//  Weather App
//
//  Created by Alex Kikalia on 23.04.22.
//

import UIKit
import SDWebImage
import Combine

final class ForecastViewController: UIViewController {

    private enum Constants {
        static let containerSpacing: CGFloat = 10.0
        static let forecastContainerSize: CGFloat = 300.0
        static let forecastImageSize: CGFloat = 50.0
        static let errorViewSize: CGFloat = 50.0
    }

    private var subscriptions = Set<AnyCancellable>()

    private let loader = UIActivityIndicatorView(style: .large)

    private lazy var errorView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "data_load_error"))
        imageView.isHidden = true
        return imageView
    }()

    private lazy var forecastContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var forecastImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    private let viewModel: ForecastViewModel

    init(viewModel: ForecastViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onLoad()
        bindWeatherData()
        bindFlow()
        setupAppearance()
        setupViewHierarchy()
        setupLayout()
    }
}

// MARK: - Private Methods

extension ForecastViewController {

    private func showLocationUnavailableAlert() {
        let alertController = UIAlertController(title: "Location Permissions",
                                                message: "Give us location permissions",
                                                preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Go to settings",
                                           style: .default) { _ in
            guard let settingsURl = URL(string:UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURl)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }

    private func setupAppearance() {
        view.backgroundColor = UIColor(named: "background")
    }

    private func setupViewHierarchy() {
        view.addSubview(forecastContainerView)
        view.addSubview(errorView)
        view.addSubview(loader)
        forecastContainerView.addSubview(forecastImageView)
        forecastContainerView.addSubview(descriptionLabel)
        forecastContainerView.addSubview(locationLabel)
    }

    private func setupLayout() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.widthAnchor.constraint(equalToConstant: Constants.errorViewSize),
            errorView.heightAnchor.constraint(equalToConstant: Constants.errorViewSize)
        ])

        loader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        forecastContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            forecastContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forecastContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            forecastContainerView.widthAnchor.constraint(equalToConstant: Constants.forecastContainerSize),
            forecastContainerView.heightAnchor.constraint(equalToConstant: Constants.forecastContainerSize)
        ])

        forecastImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            forecastImageView.centerXAnchor.constraint(equalTo: forecastContainerView.centerXAnchor),
            forecastImageView.topAnchor.constraint(equalTo: forecastContainerView.topAnchor),
            forecastImageView.widthAnchor.constraint(equalToConstant: Constants.forecastImageSize),
            forecastImageView.heightAnchor.constraint(equalToConstant: Constants.forecastImageSize)
        ])

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: forecastContainerView.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: forecastImageView.bottomAnchor, constant: Constants.containerSpacing),
            descriptionLabel.widthAnchor.constraint(equalToConstant: Constants.forecastContainerSize)
        ])

        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.centerXAnchor.constraint(equalTo: forecastContainerView.centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.containerSpacing),
            locationLabel.widthAnchor.constraint(equalToConstant: Constants.forecastContainerSize)
        ])

    }

    private func bindWeatherData() {
        viewModel.$imageURL.sink { [weak self] imageURL in
            self?.forecastImageView.sd_setImage(with: imageURL)
        }.store(in: &subscriptions)
        viewModel.$description
            .assign(to: \.text, onWeak: descriptionLabel)
            .store(in: &subscriptions)
        viewModel.$location
            .assign(to: \.text, onWeak: locationLabel)
            .store(in: &subscriptions)
    }

    private func bindFlow() {
        viewModel.$shouldShowLoader.sink { [weak self] shouldShow in
            if shouldShow {
                self?.loader.startAnimating()
            } else {
                self?.loader.stopAnimating()
            }
        }.store(in: &subscriptions)
        viewModel.$shouldShowForecast.sink { [weak self] shouldShow in
            if shouldShow {
                self?.forecastContainerView.isHidden = false
            } else {
                self?.forecastContainerView.isHidden = true
            }
        }.store(in: &subscriptions)
        viewModel.$shouldShowError.sink { [weak self] shouldShow in
            if shouldShow {
                self?.errorView.isHidden = false
            } else {
                self?.errorView.isHidden = true
            }
        }.store(in: &subscriptions)
        viewModel.$shouldShowLocationPopup.compactMap { $0 }.sink { [weak self] shouldShow in
            self?.showLocationUnavailableAlert()
        }.store(in: &subscriptions)
    }
}

//
//  LoginViewController.swift
//  Weather App
//
//  Created by Alex Kikalia on 23.04.22.
//

import UIKit
import Combine

final class LoginViewController: UIViewController {

    private enum Constants {
        static let containerSpacing: CGFloat = 15.0
        static let containerHeight: CGFloat = 150.0
        static let containerWidth: CGFloat = 200.0
        static let textFieldHeight: CGFloat = 30.0
        static let textFieldWidth: CGFloat = 200.0
        static let buttonHeight: CGFloat = 30.0
        static let buttonWidth: CGFloat = 100.0

    }

    private var subscriptions = Set<AnyCancellable>()

    private lazy var containerView = UIView()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        return label
    }()

    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.backgroundColor = .systemGray6
        textField.borderStyle = .roundedRect
        textField.placeholder = "Username"
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.backgroundColor = .systemGray6
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        return textField
    }()

    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.addTarget(self,
                         action: #selector(submitTap),
                         for: .touchUpInside)
        button.backgroundColor = .systemGray
        button.setTitle("Submit", for: .normal)
        button.layer.cornerRadius = 5.0
        return button
    }()

    private let viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        setupAppearance()
        setupViewHierarchy()
        setupLayout()
    }
}

// MARK: - Private Methods

extension LoginViewController {

    @objc
    private func screenTap() {
        dismissKeyboard()
    }

    @objc
    private func submitTap() {
        dismissKeyboard()
        viewModel.onSubmit()
    }

    private func dismissKeyboard() {
        if usernameTextField.isFirstResponder {
            usernameTextField.resignFirstResponder()
        } else if passwordTextField.isFirstResponder {
            passwordTextField.resignFirstResponder()
        }
    }

    private func setupAppearance() {
        view.backgroundColor = UIColor(named: "background")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenTap))
        view.addGestureRecognizer(tapGesture)
    }

    private func setupViewHierarchy() {
        view.addSubview(containerView)
        containerView.addSubview(usernameTextField)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(submitButton)
        containerView.addSubview(errorLabel)
    }

    private func setupLayout() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: Constants.containerWidth),
            containerView.heightAnchor.constraint(equalToConstant: Constants.containerHeight)
        ])

        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.widthAnchor.constraint(equalToConstant: Constants.textFieldWidth),
            errorLabel.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            errorLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])

        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameTextField.widthAnchor.constraint(equalToConstant: Constants.textFieldWidth),
            usernameTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            usernameTextField.topAnchor.constraint(equalTo: errorLabel.bottomAnchor),
            usernameTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])

        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordTextField.widthAnchor.constraint(equalToConstant: Constants.textFieldWidth),
            passwordTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor,
                                                   constant: Constants.containerSpacing),
            passwordTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])

        submitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            submitButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            submitButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                              constant: Constants.containerSpacing),
            submitButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])

    }

    private func bindData() {
        viewModel.$errorMessage
            .assign(to: \.text, onWeak: errorLabel)
            .store(in: &subscriptions)
    }
}


// MARK: - Delegates

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case usernameTextField:
            viewModel.username = textField.text
        case passwordTextField:
            viewModel.password = textField.text
        default:
            return
        }
    }
}

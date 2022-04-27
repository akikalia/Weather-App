//
//  Publisher+Extensions.swift
//  Weather App
//
//  Created by Alex Kikalia on 26.04.22.
//

import Combine

extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<Root, Output>,
        onWeak object: Root
    ) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}

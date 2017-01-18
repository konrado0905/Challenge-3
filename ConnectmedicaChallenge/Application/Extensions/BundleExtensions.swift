//
//  BundleExtensions.swift
//  ConnectmedicaChallenge
//
//  Created by Konrad Zdunczyk on 18/01/17.
//  Copyright © 2017 Konrad Zdunczyk. All rights reserved.
//

import Foundation

extension Bundle {
    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }

        fatalError("Could not load view with type " + String(describing: type))
    }
}

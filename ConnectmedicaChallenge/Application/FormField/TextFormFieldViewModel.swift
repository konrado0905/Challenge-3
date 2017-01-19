//
//  TextFormFieldViewModel.swift
//  ConnectmedicaChallenge
//
//  Created by Konrad Zdunczyk on 19/01/17.
//  Copyright © 2017 Konrad Zdunczyk. All rights reserved.
//

import Foundation
import RxSwift

class TextFormFieldViewModel: ValueFormFieldViewModel, ValueFormField {
    let value: Variable<String?>
    let modelKey: String
    var modelValue: Any {
        get {
            return value.value ?? ""
        }

        set {
            guard let newValue = newValue as? String else { return }

            self.value.value = newValue
        }
    }

    init(name: String, placeholder: String, text: String?, fullWidthField: Bool, modelKey: String) {
        self.value = Variable<String?>(text)
        self.modelKey = modelKey

        super.init(name: name, placeholder: placeholder, type: .text, fullWidthField: fullWidthField)
    }
}

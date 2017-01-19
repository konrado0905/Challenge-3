//
//  CheckboxFormFieldViewModel.swift
//  ConnectmedicaChallenge
//
//  Created by Konrad Zdunczyk on 19/01/17.
//  Copyright © 2017 Konrad Zdunczyk. All rights reserved.
//

import Foundation
import RxSwift

class CheckboxFormFieldViewModel: CheckboxFormField {
    let text: Variable<String>
    let fullWidthField = true
    let type: FormFieldType = .checkbox
    let checked: Variable<Bool>
    let modelKey: String
    var modelValue: Any {
        get {
            return checked.value
        }

        set {
            guard let newValue = newValue as? Bool else { return }

            self.checked.value = newValue
        }
    }

    init(text: String, checked: Bool, modelKey: String) {
        self.text = Variable<String>(text)
        self.checked = Variable<Bool>(checked)
        self.modelKey = modelKey
    }

    func toggleCheck() {
        checked.value = !checked.value
    }
}

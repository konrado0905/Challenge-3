//
//  ValueFormFieldViewModel.swift
//  ConnectmedicaChallenge
//
//  Created by Konrad Zdunczyk on 19/01/17.
//  Copyright © 2017 Konrad Zdunczyk. All rights reserved.
//

import Foundation
import RxSwift

class ValueFormFieldViewModel {
    let fullWidthField: Bool
    let name: Variable<String>
    let placeholder: Variable<String>
    let type: FormFieldType
    let focused: Variable<Bool>

    init(name: String, placeholder: String, type: FormFieldType, fullWidthField: Bool) {
        self.name = Variable<String>(name)
        self.fullWidthField = fullWidthField
        self.placeholder = Variable<String>(placeholder)
        self.focused = Variable<Bool>(false)
        self.type = type
    }
}

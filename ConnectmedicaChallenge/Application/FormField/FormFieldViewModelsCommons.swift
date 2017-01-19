//
//  FormFieldViewModelsCommons.swift
//  ConnectmedicaChallenge
//
//  Created by Konrad Zdunczyk on 17/01/17.
//  Copyright © 2017 Konrad Zdunczyk. All rights reserved.
//

import Foundation
import RxSwift

enum FormFieldType {
    case text
    case date
    case checkbox
}

protocol FormField {
    var fullWidthField: Bool { get }
    var type: FormFieldType { get }
}

protocol ModelAttributeRepresentation {
    var modelKey: String { get }
    var modelValue: Any { get set }
}

protocol ValueFormField: FormField, ModelAttributeRepresentation {
    associatedtype ValueType

    var name: Variable<String> { get }
    var placeholder: Variable<String> { get }
    var value: Variable<ValueType> { get }
    var focused: Variable<Bool> { get }
}

protocol CheckboxFormField: FormField, ModelAttributeRepresentation {
    var text: Variable<String> { get }
    var checked: Variable<Bool> { get }

    func toggleCheck()
}

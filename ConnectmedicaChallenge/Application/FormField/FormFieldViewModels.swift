//
//  FormFieldViewModels.swift
//  ConnectmedicaChallenge
//
//  Created by Konrad Zdunczyk on 17/01/17.
//  Copyright © 2017 Konrad Zdunczyk. All rights reserved.
//

import Foundation

enum FormFieldType {
    case text
    case date
    case checkbox
}

protocol FormField {
    var fullWidthField: Bool { get }
    var type: FormFieldType { get }
}

protocol ValueFormField: FormField {
    associatedtype ValueType

    var placeholder: String { get }
    var value: ValueType { get set }
    var selected: Bool { get set }
}

protocol CheckboxFormField: FormField {
    var text: String { get }
    var checked: Bool { get set }
}

typealias TextFormFieldViewModel = ValueFormFieldViewModel<String?>
typealias DateFormFieldViewModel = ValueFormFieldViewModel<Date?>

class ValueFormFieldViewModel<ValueType>: ValueFormField {
    let fullWidthField: Bool
    let name: String
    let placeholder: String
    let type: FormFieldType

    var value: ValueType
    var selected: Bool

    fileprivate init(name: String, fullWidthField: Bool, placeholder: String, type: FormFieldType, value: ValueType, selected: Bool) {
        self.name = name
        self.fullWidthField = fullWidthField
        self.placeholder = placeholder
        self.value = value
        self.selected = selected
        self.type = type
    }
}

class CheckboxFormFieldViewModel: CheckboxFormField {
    let text: String
    let fullWidthField: Bool = true
    let type: FormFieldType = .checkbox

    var checked: Bool

    fileprivate init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
    }
}

class FormFieldViewModelFactory {
    class func textFormField(withName name: String, fullWidthField: Bool, placeholder: String, text: String? = nil, selected: Bool = false) -> FormField {
        return TextFormFieldViewModel(name: name, fullWidthField: fullWidthField, placeholder: placeholder, type: .text, value: text, selected: selected)
    }

    class func dateFormField(withName name: String, fullWidthField: Bool, placeholder: String, date: Date? = nil, selected: Bool = false) -> FormField {
        return DateFormFieldViewModel(name: name, fullWidthField: fullWidthField, placeholder: placeholder, type: .date, value: date, selected: selected)
    }

    class func checkboxFormField(withText text: String, checked: Bool = false) -> FormField {
        return CheckboxFormFieldViewModel(text: text, checked: checked)
    }
}

//
//  FormFieldViewModels.swift
//  ConnectmedicaChallenge
//
//  Created by Konrad Zdunczyk on 17/01/17.
//  Copyright © 2017 Konrad Zdunczyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

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

class ValueFormFieldViewModel {
    let fullWidthField: Bool
    let name: Variable<String>
    let placeholder: Variable<String>
    let type: FormFieldType
    let focused: Variable<Bool>

    fileprivate init(name: String, placeholder: String, type: FormFieldType, fullWidthField: Bool) {
        self.name = Variable<String>(name)
        self.fullWidthField = fullWidthField
        self.placeholder = Variable<String>(placeholder)
        self.focused = Variable<Bool>(false)
        self.type = type
    }
}

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

    fileprivate init(name: String, placeholder: String, text: String?, fullWidthField: Bool, modelKey: String) {
        self.value = Variable<String?>(text)
        self.modelKey = modelKey

        super.init(name: name, placeholder: placeholder, type: .text, fullWidthField: fullWidthField)
    }
}

class DateFormFieldViewModel: ValueFormFieldViewModel, ValueFormField {
    let value: Variable<Date?>
    let modelKey: String
    private(set) var rx_formattedDate: Driver<String?>!
    private let dateFormatter: DateFormatter

    var modelValue: Any {
        get {
            return value.value ?? Date(timeIntervalSince1970: 0)
        }

        set {
            guard let newValue = newValue as? Date else { return }

            self.value.value = newValue
        }
    }

    fileprivate init(name: String, placeholder: String, date: Date?, dateFormatter: DateFormatter, fullWidthField: Bool, modelKey: String) {
        self.value = Variable<Date?>(date)
        self.dateFormatter = dateFormatter
        self.modelKey = modelKey

        super.init(name: name, placeholder: placeholder, type: .date, fullWidthField: fullWidthField)

        self.rx_formattedDate = self.value
            .asObservable()
            .map({ [weak self] (date) -> String? in
                guard let weakSelf = self, let date = date else { return nil }

                return weakSelf.dateFormatter.string(from: date)
            })
            .asDriver(onErrorJustReturn: nil)
    }
}

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

    fileprivate init(text: String, checked: Bool, modelKey: String) {
        self.text = Variable<String>(text)
        self.checked = Variable<Bool>(checked)
        self.modelKey = modelKey
    }

    func toggleCheck() {
        checked.value = !checked.value
    }
}

class FormFieldViewModelFactory {
    class func textFormField(withName name: String, placeholder: String, text: String? = nil, fullWidthField: Bool, modelKey: String) -> FormField {
        return TextFormFieldViewModel(name: name, placeholder: placeholder, text: text, fullWidthField: fullWidthField, modelKey: modelKey)
    }

    class func dateFormField(withName name: String, placeholder: String, date: Date? = nil, fullWidthField: Bool, modelKey: String) -> FormField {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        return DateFormFieldViewModel(name: name, placeholder: placeholder, date: date, dateFormatter: dateFormatter, fullWidthField: fullWidthField, modelKey: modelKey)
    }

    class func checkboxFormField(withText text: String, checked: Bool = false, modelKey: String) -> FormField {
        return CheckboxFormFieldViewModel(text: text, checked: checked, modelKey: modelKey)
    }
}

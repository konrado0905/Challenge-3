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

protocol ValueFormField: FormField {
    associatedtype ValueType

    var name: Variable<String> { get }
    var placeholder: Variable<String> { get }
    var value: Variable<ValueType> { get }
    var focused: Variable<Bool> { get }
}

protocol CheckboxFormField: FormField {
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

    fileprivate init(name: String, fullWidthField: Bool, placeholder: String, type: FormFieldType, focused: Bool) {
        self.name = Variable<String>(name)
        self.fullWidthField = fullWidthField
        self.placeholder = Variable<String>(placeholder)
        self.focused = Variable<Bool>(focused)
        self.type = type
    }
}

class TextFormFieldViewModel: ValueFormFieldViewModel, ValueFormField {
    let value: Variable<String?>

    fileprivate init(name: String, fullWidthField: Bool, text: String?, placeholder: String, focused: Bool) {
        self.value = Variable<String?>(text)

        super.init(name: name, fullWidthField: fullWidthField, placeholder: placeholder, type: .text, focused: focused)
    }
}

class DateFormFieldViewModel: ValueFormFieldViewModel, ValueFormField {
    let value: Variable<Date?>
    private(set) var rx_formattedDate: Driver<String?>!
    private let dateFormatter: DateFormatter

    fileprivate init(name: String, fullWidthField: Bool, date: Date?, placeholder: String, focused: Bool, dateFormatter: DateFormatter) {
        self.value = Variable<Date?>(date)
        self.dateFormatter = dateFormatter

        super.init(name: name, fullWidthField: fullWidthField, placeholder: placeholder, type: .date, focused: focused)

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

    fileprivate init(text: String, checked: Bool) {
        self.text = Variable<String>(text)
        self.checked = Variable<Bool>(checked)
    }

    func toggleCheck() {
        checked.value = !checked.value
    }
}

class FormFieldViewModelFactory {
    class func textFormField(withName name: String, fullWidthField: Bool, placeholder: String, text: String? = nil, focused: Bool = false) -> FormField {
        return TextFormFieldViewModel(name: name, fullWidthField: fullWidthField, text: text, placeholder: placeholder, focused: focused)
    }

    class func dateFormField(withName name: String, fullWidthField: Bool, placeholder: String, date: Date? = nil, focused: Bool = false) -> FormField {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        return DateFormFieldViewModel(name: name, fullWidthField: fullWidthField, date: date, placeholder: placeholder, focused: focused, dateFormatter: dateFormatter)
    }

    class func checkboxFormField(withText text: String, checked: Bool = false) -> FormField {
        return CheckboxFormFieldViewModel(text: text, checked: checked)
    }
}

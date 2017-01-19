//
//  FormFieldViewModelFactory.swift
//  ConnectmedicaChallenge
//
//  Created by Konrad Zdunczyk on 19/01/17.
//  Copyright © 2017 Konrad Zdunczyk. All rights reserved.
//

import Foundation

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

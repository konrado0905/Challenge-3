//
//  FormViewModel.swift
//  ConnectmedicaChallenge
//
//  Created by Konrad Zdunczyk on 17/01/17.
//  Copyright © 2017 Konrad Zdunczyk. All rights reserved.
//

import Foundation

class FormViewModel {
    let formName: String
    private var formFields: [FormField]

    var fieldsCount: Int {
        return formFields.count
    }

    init(formName: String, formFields: [FormField]) {
        self.formName = formName
        self.formFields = formFields
    }

    func getFormField(forIndexPath indexPath: IndexPath) -> FormField? {
        guard fieldsCount > 0 else { return nil }
        guard indexPath.row >= 0 && indexPath.row < fieldsCount else { return nil }

        return formFields[indexPath.row]
    }
}

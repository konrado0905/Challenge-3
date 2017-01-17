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
    private(set) var formFields: [FormField]

    init(formName: String, formFields: [FormField]) {
        self.formName = formName
        self.formFields = formFields
    }
}

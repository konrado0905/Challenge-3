//
//  DatePickerAccessoryView.swift
//  ConnectmedicaChallenge
//
//  Created by Konrad Zdunczyk on 18/01/17.
//  Copyright © 2017 Konrad Zdunczyk. All rights reserved.
//

import UIKit

class DatePickerAccessoryView: UIToolbar {
    var doneHandler: (()->())?

    @IBAction func doneDidTap(_ sender: UIBarButtonItem) {
        doneHandler?()
    }
}

//
//  DateFormFieldCell.swift
//  ConnectmedicaChallenge
//
//  Created by Konrad Zdunczyk on 18/01/17.
//  Copyright © 2017 Konrad Zdunczyk. All rights reserved.
//

import UIKit
import RxSwift

class DateFormFieldCell: ValueFormFieldCell {
    private(set) var datePicker: UIDatePicker!
    let date = Variable<Date?>(nil)

    override func awakeFromNib() {
        super.awakeFromNib()

        setupInputView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        date.value = nil
    }

    private func setupInputView() {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date

        let accessoryView = Bundle.loadView(fromNib: "DatePickerAccessoryView", withType: DatePickerAccessoryView.self)
        accessoryView.doneHandler = { [unowned self] in
            self.valueTextField.resignFirstResponder()
            self.date.value = self.datePicker.date
        }

        valueTextField.inputView = datePicker
        valueTextField.inputAccessoryView = accessoryView
    }
}

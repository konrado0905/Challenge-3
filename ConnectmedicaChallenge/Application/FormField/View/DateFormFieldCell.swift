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

    @objc private func datePickerValueChanged(datePicker: UIDatePicker) {
        date.value = datePicker.date
    }

    private func setupInputView() {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(datePicker:)), for: UIControlEvents.valueChanged)

        let accessoryView = Bundle.loadView(fromNib: "DatePickerAccessoryView", withType: DatePickerAccessoryView.self)
        accessoryView.doneHandler = { [unowned self] in
            self.valueTextField.resignFirstResponder()
            self.datePickerValueChanged(datePicker: self.datePicker)
        }

        valueTextField.inputView = datePicker
        valueTextField.inputAccessoryView = accessoryView
    }
}

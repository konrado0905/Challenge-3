//
//  DateFormFieldViewModel.swift
//  ConnectmedicaChallenge
//
//  Created by Konrad Zdunczyk on 19/01/17.
//  Copyright © 2017 Konrad Zdunczyk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

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

    init(name: String, placeholder: String, date: Date?, dateFormatter: DateFormatter, fullWidthField: Bool, modelKey: String) {
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

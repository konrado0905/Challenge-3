//
//  ValueFormFieldCell.swift
//  ConnectmedicaChallenge
//
//  Created by Konrad Zdunczyk on 17/01/17.
//  Copyright © 2017 Konrad Zdunczyk. All rights reserved.
//

import UIKit
import RxSwift

class ValueFormFieldCell: UICollectionViewCell {
    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField! {
        didSet {
            valueTextField?.backgroundColor = UIColor.white

            valueTextField.rx
                .controlEvent(UIControlEvents.editingDidBegin)
                .subscribe(onNext: { [unowned self] in
                    self.rx_isFirstResponder.value = self.valueTextField.isFirstResponder
                })
                .addDisposableTo(privateDisposeBag)

            valueTextField.rx
                .controlEvent(UIControlEvents.editingDidEnd)
                .subscribe(onNext: { [unowned self] in
                    self.rx_isFirstResponder.value = self.valueTextField.isFirstResponder
                })
                .addDisposableTo(privateDisposeBag)

            valueTextField.rx
                .controlEvent(UIControlEvents.editingDidEndOnExit)
                .subscribe(onNext: { [unowned self] in
                    self.valueTextField.resignFirstResponder()
                })
                .addDisposableTo(privateDisposeBag)
        }
    }
    @IBOutlet weak var underlineView: UIView!

    let rx_isFirstResponder: Variable<Bool> = Variable<Bool>(false)

    private let privateDisposeBag = DisposeBag()
    private(set) var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
        valueTextField.text = nil
    }

    func setFocused(focused: Bool) {
        let lineColor: UIColor
        let textColor: UIColor

        if focused {
            lineColor = UIColor(red:0.07, green:0.88, blue:0.56, alpha:1.00)
            textColor = UIColor(red:0.07, green:0.88, blue:0.56, alpha:1.00)
        } else {
            lineColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.00)
            textColor = UIColor.black
        }

        underlineView.backgroundColor = lineColor
        fieldNameLabel.textColor = textColor
    }
}

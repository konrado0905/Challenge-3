//
//  ValueFormFieldCell.swift
//  ConnectmedicaChallenge
//
//  Created by Konrad Zdunczyk on 17/01/17.
//  Copyright © 2017 Konrad Zdunczyk. All rights reserved.
//

import UIKit

class ValueFormFieldCell: UICollectionViewCell {
    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var arrowWidth: NSLayoutConstraint! // 16 0
    @IBOutlet weak var valueTextTrailingSpace: NSLayoutConstraint! // 4 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

//
//  CheckboxFormFieldCell.swift
//  ConnectmedicaChallenge
//
//  Created by Konrad Zdunczyk on 17/01/17.
//  Copyright © 2017 Konrad Zdunczyk. All rights reserved.
//

import UIKit
import RxSwift

class CheckboxFormFieldCell: UICollectionViewCell {
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!

    private(set) var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    func setCheckedStatus(checked: Bool) {
        let image: UIImage
        if checked {
            image = #imageLiteral(resourceName: "CHECK")
        } else {
            image = #imageLiteral(resourceName: "UNCHECK")
        }

        checkImageView.image = image
    }
}

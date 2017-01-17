//
//  FormViewController.swift
//  ConnectmedicaChallenge
//
//  Created by Konrad Zdunczyk on 17/01/17.
//  Copyright © 2017 Konrad Zdunczyk. All rights reserved.
//

import UIKit

let valueFormCellReuseIdentifier = "valueFormCell"
let checkboxFormCellReuseIdentifier = "checkboxFormCell"

class FormViewController: UIViewController {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var formCollectionView: UICollectionView! {
        didSet {
            let valueFormCellNib = UINib(nibName: "ValueFormFieldCell", bundle: nil)
            let checkboxFormCellNib = UINib(nibName: "CheckboxFormFieldCell", bundle: nil)
            formCollectionView?.register(valueFormCellNib, forCellWithReuseIdentifier: valueFormCellReuseIdentifier)
            formCollectionView?.register(checkboxFormCellNib, forCellWithReuseIdentifier: checkboxFormCellReuseIdentifier)

            formCollectionView?.dataSource = self
            formCollectionView?.delegate = self
        }
    }

    lazy var formViewModel: FormViewModel = {
        var fields: [FormField] = []

        fields.append(FormFieldViewModelFactory.textFormField(withName: "Imię", fullWidthField: false, placeholder: "Uzupełnij pole"))
        fields.append(FormFieldViewModelFactory.textFormField(withName: "Nazwisko", fullWidthField: false, placeholder: "Uzupełnij pole"))
        fields.append(FormFieldViewModelFactory.textFormField(withName: "Stanowisko", fullWidthField: false, placeholder: "Uzupełnij pole"))
        fields.append(FormFieldViewModelFactory.textFormField(withName: "Firma", fullWidthField: false, placeholder: "Uzupełnij pole"))
        fields.append(FormFieldViewModelFactory.textFormField(withName: "Adres e-mail", fullWidthField: true, placeholder: "Uzupełnij pole"))
        fields.append(FormFieldViewModelFactory.textFormField(withName: "Telefon", fullWidthField: false, placeholder: "Uzupełnij pole"))
        fields.append(FormFieldViewModelFactory.dateFormField(withName: "Data spotkania", fullWidthField: false, placeholder: "Wybierz datę"))
        fields.append(FormFieldViewModelFactory.checkboxFormField(withText: "Wyrażam zgodę na otrzymywanie od firmy ABCDE Polska Sp. z o.o. ABCDE Polska Dystrybucja Sp. z o.o. oraz ABCDE PLC. informacji handlowych i naukowych drogą elektroniczną na wskazany powyżej adres email.", checked: false))
        fields.append(FormFieldViewModelFactory.checkboxFormField(withText: "Wyrażam zgodę na przetwarzanie swoich danych osobowych, zgodnie z ustawą z dnia 29 sierpnia 1997r. o ochronie danych osobowych (tekst jednolity z dnia 17.06.2002r. Dz. U. Nr 101 poz. 926, z późna. zm.) w celach reklamowych i marketingowych przez firmę ABCDE Polska Sp. z o.o. oraz ABCDE Polska Dystrybucja Sp. z o.o.", checked: false))

        return FormViewModel(formName: "Dane osobowe", formFields: fields)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    func bind() {
        self.title = formViewModel.formName
    }

    // MARK: Helpers
    func reuseIdentifier(forType type: FormFieldType) -> String {
        switch type {
        case .text, .date:
            return valueFormCellReuseIdentifier
        case .checkbox:
            return checkboxFormCellReuseIdentifier
        }
    }

    func setup(cell: UICollectionViewCell, withModel model: FormField) {
        let type = model.type

        switch type {
        case .text, .date:
            if let cell = cell as? ValueFormFieldCell,
                let model = model as? ValueFormFieldViewModel<Any> {
                setupValueCell(cell: cell, withModel: model)
            }
        case .checkbox:
            if let cell = cell as? CheckboxFormFieldCell,
                let model = model as? CheckboxFormFieldViewModel {
                setupCheckboxCell(cell: cell, withModel: model)
            }
        }
    }

    func setupValueCell(cell: ValueFormFieldCell, withModel model: ValueFormFieldViewModel<Any>) {

    }

    func setupCheckboxCell(cell: CheckboxFormFieldCell, withModel model: CheckboxFormFieldViewModel) {

    }
}

extension FormViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return formViewModel.fieldsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let fieldViewModel = formViewModel.getFormField(forIndexPath: indexPath) else { fatalError() }

        let reuseId = reuseIdentifier(forType: fieldViewModel.type)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath)

        setup(cell: cell, withModel: fieldViewModel)

        return cell
    }
}

extension FormViewController: UICollectionViewDelegate {

}

extension FormViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 82)
    }
}

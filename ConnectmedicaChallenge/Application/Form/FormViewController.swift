//
//  FormViewController.swift
//  ConnectmedicaChallenge
//
//  Created by Konrad Zdunczyk on 17/01/17.
//  Copyright © 2017 Konrad Zdunczyk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

let textFormCellReuseIdentifier = "textFormCell"
let dateFormCellReuseIdentifier = "dateFormCell"
let checkboxFormCellReuseIdentifier = "checkboxFormCell"

class FormViewController: UIViewController {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var formCollectionView: UICollectionView! {
        didSet {
            let textFormCellNib = UINib(nibName: "TextFormFieldCell", bundle: nil)
            let dateFormCellNib = UINib(nibName: "DateFormFieldCell", bundle: nil)
            let checkboxFormCellNib = UINib(nibName: "CheckboxFormFieldCell", bundle: nil)
            formCollectionView?.register(textFormCellNib, forCellWithReuseIdentifier: textFormCellReuseIdentifier)
            formCollectionView?.register(dateFormCellNib, forCellWithReuseIdentifier: dateFormCellReuseIdentifier)
            formCollectionView?.register(checkboxFormCellNib, forCellWithReuseIdentifier: checkboxFormCellReuseIdentifier)

            formCollectionView?.dataSource = self
            formCollectionView?.delegate = self
        }
    }

    lazy var formViewModel: FormViewModel = {
        var fields: [FormField] = []

        fields.append(FormFieldViewModelFactory.textFormField(withName: "Imię", placeholder: "Uzupełnij pole", fullWidthField: false, modelKey: "name"))
        fields.append(FormFieldViewModelFactory.textFormField(withName: "Nazwisko", placeholder: "Uzupełnij pole",  fullWidthField: false, modelKey: "lastName"))
        fields.append(FormFieldViewModelFactory.textFormField(withName: "Stanowisko", placeholder: "Uzupełnij pole", fullWidthField: false, modelKey: "position"))
        fields.append(FormFieldViewModelFactory.textFormField(withName: "Firma", placeholder: "Uzupełnij pole", fullWidthField: false, modelKey: "company"))
        fields.append(FormFieldViewModelFactory.textFormField(withName: "Adres e-mail", placeholder: "Uzupełnij pole", fullWidthField: true ,modelKey: "email"))
        fields.append(FormFieldViewModelFactory.textFormField(withName: "Telefon", placeholder: "Uzupełnij pole", fullWidthField: false, modelKey: "phoneNumber"))
        fields.append(FormFieldViewModelFactory.dateFormField(withName: "Data spotkania", placeholder: "Wybierz datę", fullWidthField: false, modelKey: "meetingDate"))
        fields.append(FormFieldViewModelFactory.checkboxFormField(withText: "Wyrażam zgodę na otrzymywanie od firmy ABCDE Polska Sp. z o.o. ABCDE Polska Dystrybucja Sp. z o.o. oraz ABCDE PLC. informacji handlowych i naukowych drogą elektroniczną na wskazany powyżej adres email.", checked: false, modelKey: "commercialInformationAgreement"))
        fields.append(FormFieldViewModelFactory.checkboxFormField(withText: "Wyrażam zgodę na przetwarzanie swoich danych osobowych, zgodnie z ustawą z dnia 29 sierpnia 1997r. o ochronie danych osobowych (tekst jednolity z dnia 17.06.2002r. Dz. U. Nr 101 poz. 926, z późna. zm.) w celach reklamowych i marketingowych przez firmę ABCDE Polska Sp. z o.o. oraz ABCDE Polska Dystrybucja Sp. z o.o.", checked: false, modelKey: "marketingInformationAgreement"))

        return FormViewModel(formName: "Dane osobowe", formFields: fields)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    func bind() {
        self.title = formViewModel.formName
    }

    @IBAction func saveButtonDidTap(_ sender: UIBarButtonItem) {
        formViewModel.saveForm()
    }

    @IBAction func loadLastRecordButtonDidTap(_ sender: UIBarButtonItem) {
        formViewModel.loadLastRecord()
    }

    // MARK: Helpers
    func reuseIdentifier(forType type: FormFieldType) -> String {
        switch type {
        case .text:
            return textFormCellReuseIdentifier
        case .date:
            return dateFormCellReuseIdentifier
        case .checkbox:
            return checkboxFormCellReuseIdentifier
        }
    }

    func setup(cell: UICollectionViewCell, withModel model: FormField) {
        let type = model.type

        switch type {
        case .text, .date:
            if let cell = cell as? ValueFormFieldCell,
                let model = model as? ValueFormFieldViewModel {
                setupValueCell(cell: cell, withModel: model)
            }
        case .checkbox:
            if let cell = cell as? CheckboxFormFieldCell,
                let model = model as? CheckboxFormFieldViewModel {
                setupCheckboxCell(cell: cell, withModel: model)
            }
        }
    }

    func setupValueCell(cell: ValueFormFieldCell, withModel model: ValueFormFieldViewModel) {
        model.name
            .asObservable()
            .bindTo(cell.fieldNameLabel.rx.text)
            .addDisposableTo(cell.disposeBag)

        model.placeholder
            .asObservable()
            .bindNext({ [unowned cell] (placeholder) in
                cell.valueTextField.placeholder = placeholder
            })
            .addDisposableTo(cell.disposeBag)

        model.focused
            .asObservable()
            .bindNext { [unowned cell] (focused) in
                cell.setFocused(focused: focused)
            }
            .addDisposableTo(cell.disposeBag)

        cell.rx_isFirstResponder
            .asObservable()
            .bindTo(model.focused)
            .addDisposableTo(cell.disposeBag)

        switch model.type {
        case .date:
            if let cell = cell as? DateFormFieldCell,
                let model = model as? DateFormFieldViewModel {

                func dateCompareBlock(dateOne: Date?, dateTwo: Date?) throws -> Bool {
                    if (dateOne == nil && dateTwo != nil) || (dateOne != nil && dateTwo == nil) {
                        return false
                    }

                    guard let dateOne = dateOne, let dateTwo = dateTwo else { return true }

                    return dateOne.compare(dateTwo) == .orderedSame
                }

                model.value
                    .asObservable()
                    .distinctUntilChanged(dateCompareBlock)
                    .bindTo(cell.date)
                    .addDisposableTo(cell.disposeBag)

                cell.date
                    .asObservable()
                    .distinctUntilChanged(dateCompareBlock)
                    .bindTo(model.value)
                    .addDisposableTo(cell.disposeBag)

                cell.date
                    .asObservable()
                    .filter { $0 != nil }
                    .subscribe(onNext: { [unowned cell] (date) in
                        cell.datePicker.date = date!
                    })
                    .addDisposableTo(cell.disposeBag)

                model.rx_formattedDate
                    .drive(cell.valueTextField.rx.text)
                    .addDisposableTo(cell.disposeBag)
            }
        case .text:
            if let cell = cell as? TextFormFieldCell,
                let model = model as? TextFormFieldViewModel {
                model.value
                    .twoWayBind(observer: cell.valueTextField.rx.text)
                    .addDisposableTo(cell.disposeBag)
            }
        default:
            break
        }
    }

    func setupCheckboxCell(cell: CheckboxFormFieldCell, withModel model: CheckboxFormFieldViewModel) {
        model.text
            .asObservable()
            .bindTo(cell.textLabel.rx.text)
            .addDisposableTo(cell.disposeBag)

        model.checked
            .asObservable()
            .bindNext { [unowned cell] (checked) in
                cell.setCheckedStatus(checked: checked)
            }
            .addDisposableTo(cell.disposeBag)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)

        guard let model = formViewModel.getFormField(forIndexPath: indexPath) else { return }

        if let model = model as? CheckboxFormField {
            model.toggleCheck()
        }
    }
}

extension FormViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 82)
    }
}

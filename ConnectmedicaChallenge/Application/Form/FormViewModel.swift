//
//  FormViewModel.swift
//  ConnectmedicaChallenge
//
//  Created by Konrad Zdunczyk on 17/01/17.
//  Copyright © 2017 Konrad Zdunczyk. All rights reserved.
//

import Foundation
import CoreData

class FormViewModel {
    let formName: String
    private var formFields: [FormField]
    private var model: NSManagedObject?

    var fieldsCount: Int {
        return formFields.count
    }

    init(formName: String, formFields: [FormField]) {
        self.formName = formName
        self.formFields = formFields
    }

    func getFormField(forIndexPath indexPath: IndexPath) -> FormField? {
        guard fieldsCount > 0 else { return nil }
        guard indexPath.row >= 0 && indexPath.row < fieldsCount else { return nil }

        return formFields[indexPath.row]
    }

    func loadFormFromModel(model: PersonalInfoForm) {
        self.model = model

        for case var field as ModelAttributeRepresentation in formFields {
            if let value = model.value(forKey: field.modelKey) {
                field.modelValue = value
            }
        }
    }

    func loadLastRecord() {
        let fetchRequest = NSFetchRequest<PersonalInfoForm>(entityName: "PersonalInfoForm")

        do {
            let context = CoreDataHelper.context
            let results = try context.fetch(fetchRequest)

            if let lastRecord = results.last {
                loadFormFromModel(model: lastRecord)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    func saveForm() {
        let managedContext = CoreDataHelper.context

        if model == nil {
            let entity =  NSEntityDescription.entity(forEntityName: "PersonalInfoForm", in: managedContext)
            model = NSManagedObject(entity: entity!, insertInto: managedContext)
        }

        if let model = model {
            for case let field as ModelAttributeRepresentation in formFields {
                if model.responds(to: Selector(field.modelKey)) {
                    model.setValue(field.modelValue, forKey: field.modelKey)
                }
            }

            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
}

//
//  PersonalInfoForm+CoreDataProperties.swift
//  
//
//  Created by Konrad Zdunczyk on 18/01/17.
//
//

import Foundation
import CoreData


extension PersonalInfoForm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonalInfoForm> {
        return NSFetchRequest<PersonalInfoForm>(entityName: "PersonalInfoForm");
    }

    @NSManaged public var name: String
    @NSManaged public var lastName: String
    @NSManaged public var position: String
    @NSManaged public var company: String
    @NSManaged public var email: String
    @NSManaged public var phoneNumber: String
    @NSManaged public var meetingDate: NSDate
    @NSManaged public var commercialInformationAgreement: Bool
    @NSManaged public var marketingInformationAgreement: Bool

}

//
//  Contact.swift
//  Contacts
//
//  Created by Jonmichael Cheung on 3/3/22.
//

import UIKit
import CloudKit

struct StringConstants {
    static let recordTypeKey = "Contact"
    fileprivate static let nameKey = "name"
    fileprivate static let phoneKey = "phone"
    fileprivate static let emailKey = "email"
}

class Contact {
    var name: String
    var phone: String
    var email: String
    let recordID: CKRecord.ID
    
    init(name: String, phone: String, email: String, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.phone = phone
        self.email = email
        self.recordID = recordID
    }
    
} //End of class

extension Contact {
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[StringConstants.nameKey] as? String,
              let phone = ckRecord[StringConstants.phoneKey] as? String,
              let email = ckRecord[StringConstants.emailKey] as? String
        else { return nil }
        
        self.init(name: name, phone: phone, email: email, recordID: ckRecord.recordID)
    }
    
}


extension CKRecord {
    convenience init(contact: Contact) {
        self.init(recordType: StringConstants.recordTypeKey, recordID: contact.recordID)
        self.setValuesForKeys([
            StringConstants.nameKey : contact.name,
            StringConstants.phoneKey : contact.phone,
            StringConstants.emailKey : contact.email
        ])
    }
}

extension Contact: Equatable {
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}

//
//  contactController.swift
//  Contacts
//
//  Created by Jonmichael Cheung on 3/3/22.
//

import UIKit
import CloudKit

class ContactController {
    //MARK: Properties
    
    static let shared = ContactController()
    var contacts: [Contact] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    
    
    //MARK: - CRUD
    
    func saveContact(with name: String, phone: String = "", email: String = "", completion: @escaping (Bool) -> Void) {
        let newContact = Contact(name: name, phone: phone, email: email)
        let contactRecord = CKRecord(contact: newContact)
        publicDB.save(contactRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let record = record,
                  let savedContact = Contact(ckRecord: record)
            else { return completion(false)}
            
            print("Saved Contact Successfully")
            self.contacts.insert(savedContact, at: 0)
        }
    }
    
    func updateContact(_ contact: Contact, name: String, phone: String, email: String, completion: @escaping(Bool) -> Void) {
        
        contact.name = name
        contact.phone = phone
        contact.email = email
        
        let recordToUpdate = CKRecord(contact: contact)
        let operation = CKModifyRecordsOperation(recordsToSave: [recordToUpdate])
        
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.queuePriority = .high
        operation.modifyRecordsCompletionBlock = { ( records, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            
            guard let record = records?.first else { return completion(false)}
            print("Updated \(record.recordID.recordName) successfully")
            completion(true)
        }
        
        publicDB.add(operation)
    }
    
    func fetchContact(completion: @escaping(Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: StringConstants.recordTypeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let records = records else { return completion(false) }
            print("Fetched all Contacts")
            
            let fetchedContacts = records.compactMap { Contact(ckRecord: $0) }
            self.contacts = fetchedContacts
             completion(true)
            }
        }
        
    
    func deleteContact(_ contact: Contact, completion: @escaping(Bool) -> Void) {
     
        let operation = CKModifyRecordsOperation(recordIDsToDelete: [contact.recordID])
        
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        
        operation.modifyRecordsCompletionBlock = { (_, recordIDs, error) in
        if let error = error {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            completion(false)
            return
        }
            guard let recordIDs = recordIDs else { return completion(false) }
            print("\(recordIDs) were removed successfully")
            completion(true)
        }
//        operation.modifyRecordsResultBlock = { records in
//            switch records {
//            case.success():
//                return completion(true)
//            case.failure(let error):
//                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
//                return completion(false)
//            }
//        }
        publicDB.add(operation)
    }
    
    
    
} //End of class

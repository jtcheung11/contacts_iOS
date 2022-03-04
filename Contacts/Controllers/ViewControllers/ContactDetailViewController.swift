//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Jonmichael Cheung on 3/3/22.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    //MARK: - Landing Pad
    var contact: Contact?
    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    
    //MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
              let phone = phoneTextField.text,
              let email = emailTextField.text
        else { return }
        
        if let contact = contact {
            ContactController.shared.updateContact(contact, name: name, phone: phone, email: email) { success in
                if success {
                    print("Contact Updated")
                    self.dismiss()
                }
            }
        }else {
            ContactController.shared.saveContact(with: name, phone: phone, email: email) { success in
                if success {
                    self.dismiss()
                }
            }
        }
//        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper Methods
    func updateView() {
        guard let contact = contact else { return }
        nameTextField.text = contact.name
        phoneTextField.text = contact.phone
        emailTextField.text = contact.email
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
} //End of class

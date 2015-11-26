//
//  AddUpdateContactViewController.swift
//  ContactsFrameworkSwift
//
//  Created by TheAppGuruz on 25/11/15.
//  Copyright © 2015 TheAppGuruz. All rights reserved.
//

import UIKit
import Contacts

class AddUpdateContactViewController: UIViewController {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    var updateContact = CNContact()
    var isUpdate: Bool = false

// MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isUpdate == true {
            self.navigationItem.rightBarButtonItem?.title = "Update"
            displayContactData()
        }
    }
    
// MARK: - Display Contact Data Methods
    func displayContactData() {
        txtFirstName.text = updateContact.givenName
        txtLastName.text = updateContact.familyName
        
        for phoneNo in updateContact.phoneNumbers {
            if phoneNo.label == CNLabelPhoneNumberMobile {
                txtPhoneNo.text = (phoneNo.value as! CNPhoneNumber).stringValue
                break
            }
        }
        
        for emailAddress in updateContact.emailAddresses {
            if emailAddress.label == CNLabelHome {
                txtEmail.text = emailAddress.value as? String
                break
            }
        }
    }
    
    func displayAlertMessage(message: String, isAction: Bool) {
        let alertController = UIAlertController(title: "Contacts", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let dismissAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (action) -> Void in
            if isAction == true {
                self.navigationController?.popViewControllerAnimated(true)
                return
            }
        }
        
        alertController.addAction(dismissAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
// MARK: - Action Methods
    @IBAction func btnAddUpdateContactClicked(sender: AnyObject) {
        
        var newContact = CNMutableContact()
        
        if isUpdate == true {
            newContact = updateContact.mutableCopy() as! CNMutableContact
        }
        
        //Set Name
        newContact.givenName = txtFirstName.text!
        newContact.familyName = txtLastName.text!
        
        //Set Phone No
        let phoneNo = CNLabeledValue(label:CNLabelPhoneNumberMobile, value:CNPhoneNumber(stringValue:txtPhoneNo.text!))
        
        if isUpdate == true {
            newContact.phoneNumbers.append(phoneNo)
        } else {
            newContact.phoneNumbers = [phoneNo]
        }
        
        //Set Email
        let homeEmail = CNLabeledValue(label: CNLabelHome, value: txtEmail.text!)
        
        if isUpdate == true {
            newContact.emailAddresses.append(homeEmail)
        } else {
            newContact.emailAddresses = [homeEmail]
        }
        
        var message: String = ""
        
        do {
            let saveRequest = CNSaveRequest()
            if isUpdate == true {
                saveRequest.updateContact(newContact)
                message = "Contact Updated Successfully"
            } else {
                saveRequest.addContact(newContact, toContainerWithIdentifier: nil)
                message = "Contact Added Successfully"
            }
            
            let contactStore = CNContactStore()
            try contactStore.executeSaveRequest(saveRequest)
            
            displayAlertMessage(message, isAction: true)
        }
        catch {
            if isUpdate == true {
                message = "Unable to Update the Contact."
            } else {
                message = "Unable to Add the New Contact."
            }
            
            displayAlertMessage(message, isAction: false)
        }
    }
}
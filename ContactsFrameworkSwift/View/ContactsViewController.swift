//
//  ContactsViewController.swift
//  ContactsFrameworkSwift
//
//  Created by TheAppGuruz on 25/11/15.
//  Copyright © 2015 TheAppGuruz. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ContactsViewController: UIViewController, CNContactPickerDelegate {
    
    var contactStore = CNContactStore()
    var updateContact = CNContact()

// MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        askForContactAccess()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "OpenUpdateContactView" {
            let addUpdateContactViewController = segue.destinationViewController as! AddUpdateContactViewController
            addUpdateContactViewController.updateContact = updateContact
            addUpdateContactViewController.isUpdate = true
        }
    }
    
// MARK: - Action Methods
    @IBAction func btnViewAllContactsClicked(sender: AnyObject) {
        let contactPickerViewController = CNContactPickerViewController()
        presentViewController(contactPickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnUpdateContactClicked(sender: AnyObject) {
        let contactPickerViewController = CNContactPickerViewController()
        
        contactPickerViewController.delegate = self
        
        presentViewController(contactPickerViewController, animated: true, completion: nil)
    }
    
// MARK: - Contact Access Permission Method
    func askForContactAccess() {
        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        
        switch authorizationStatus {
        case .Denied, .NotDetermined:
            self.contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (access, accessError) -> Void in
                if !access {
                    if authorizationStatus == CNAuthorizationStatus.Denied {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            let alertController = UIAlertController(title: "Contacts", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                            
                            let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
                            }
                            
                            alertController.addAction(dismissAction)
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                        })
                    }
                }
            })
            break
        default:
            break
        }
    }
    
// MARK: - Contact Select Method
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        updateContact = contact
        self.dismissViewControllerAnimated(false, completion: nil)
        performSegueWithIdentifier("OpenUpdateContactView", sender: nil)
    }
}
//
//  SearchContactViewController.swift
//  ContactsFrameworkSwift
//
//  Created by TheAppGuruz on 25/11/15.
//  Copyright © 2015 TheAppGuruz. All rights reserved.
//

import UIKit
import Contacts

class SearchContactViewController: UIViewController {

    @IBOutlet weak var sbContacts: UISearchBar!
    @IBOutlet weak var tbContacts: UITableView!
    
    var marrContacts = NSMutableArray()
    
// MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
// MARK: - UITableView Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marrContacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell")
        let contact = marrContacts.objectAtIndex(indexPath.row) as! CNContact
        cell!.textLabel?.text = "\(contact.givenName) \(contact.familyName)"
        cell!.detailTextLabel?.text = ""
        for phoneNo in contact.phoneNumbers {
            if phoneNo.label == CNLabelPhoneNumberMobile {
                cell!.detailTextLabel?.text = (phoneNo.value as! CNPhoneNumber).stringValue
                break
            }
        }
        
        return cell!
    }
    
// MARK: - UISearchBar Delegate Methods
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchContactDataBaseOnName(searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        marrContacts.removeAllObjects()
        tbContacts.reloadData()
    }
    
// MARK: - Search Contact Methods
    func searchContactDataBaseOnName(name: String) {
        marrContacts.removeAllObjects()
        
        let predicate = CNContact.predicateForContactsMatchingName(name)
        
        //Fetch Contacts Information like givenName and familyName, phoneNo, address
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactUrlAddressesKey]
        
        let store = CNContactStore()
        
        do {
            let contacts = try store.unifiedContactsMatchingPredicate(predicate,
                keysToFetch: keysToFetch)
            
            for contact in contacts {
                marrContacts.addObject(contact)
            }
            tbContacts.reloadData()
        }
        catch{
            print("Can't Search Contact Data")
        }
    }
}
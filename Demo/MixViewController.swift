//
//  MixViewController.swift
//  MSFormCell
//
//  Created by 須藤 将史 on 2017/02/20.
//  Copyright © 2017年 masashi_sutou. All rights reserved.
//

import UIKit
import MSFormCell

private struct User {
    
    var name: String!
    var email: String!
    var tel: String!
    
    init(name: String, email: String, tel: String) {
        self.name = name
        self.email = email
        self.tel = tel
    }
}

private extension Selector {
    static let saveButtonTapped = #selector(MixViewController.saveButtonTapped(_:))
}

final class MixViewController: MSFormTableViewController {
    
    private var user: User = User(name: "", email: "", tel: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Mix-Forms"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: .saveButtonTapped)
        self.tableView = UITableView.init(frame: self.view.frame, style: .grouped)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "user name"
        case 1:
            return "user email"
        case 2:
            return "user phone number"
        default:
            break
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            let cell = MSFormCell(maxTextCount: 10, textChanged: { (text) in
                self.user.name = text
            }, didReturn: {
                if let cell = tableView.cellForRow(at: indexPath) as? MSFormCell {
                    cell.textField.resignFirstResponder()
                }
            })
            
            cell.textField.keyboardType = .default
            cell.textField.placeholder = "enter your name"
            cell.textField.text = self.user.name
            return cell
            
        case 1:
            
            let cell = MSFormCell(pregError: ("Invalid format mail address", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"), textChanged: { (text) in
                self.user.email = text
            }, didReturn: {
                if let cell = tableView.cellForRow(at: indexPath) as? MSFormCell {
                    cell.textField.resignFirstResponder()
                }
            })
            
            cell.textField.keyboardType = .emailAddress
            cell.textField.placeholder = "enter your email"
            cell.textField.text = self.user.email
            return cell
            
        case 2:
            
            let cell = MSFormCell(maxTextCount: 11, isOptional: true, pregError: ("Invalid format phone number in Japan", "^[0-9]{10,11}$"), textChanged: { (text) in
                self.user.tel = text
            }, didReturn: {
                if let cell = tableView.cellForRow(at: indexPath) as? MSFormCell {
                    cell.textField.resignFirstResponder()
                }
            })
            
            cell.textField.keyboardType = .numberPad
            cell.textField.placeholder = "enter your phone number"
            cell.textField.text = self.user.tel
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func saveButtonTapped(_ sender: UIBarButtonItem) {

        self.view.endEditing(true)

        if let inValidCellIndexPath = self.inValidCellFirstIndexPath() {
            let alert = UIAlertController(title: "Result", message: "error", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_) -> Void in
                self.tableView.scrollToRow(at: inValidCellIndexPath, at: .top, animated: true)
            }))
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Result", message: "save", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
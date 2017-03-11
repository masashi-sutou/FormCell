//
//  MandatoryViewController.swift.swift
//  FormCell
//
//  Created by 須藤 将史 on 2017/02/19.
//  Copyright © 2017年 masashi_sutou. All rights reserved.
//

import UIKit
import FormCell

private struct User {
    
    var name: String?
    var nameKana: String?
    var email: String?
    var tel: String?
    var errorMessages: [IndexPath: String] = [:]
}

final class MandatoryViewController: UITableViewController {
    
    private var user: User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "All-Mandatory-Forms"
        self.tableView = UITableView.init(frame: self.view.frame, style: .grouped)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(MandatoryViewController.saveTapped(_:)))
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
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
        
        switch section {
        case 0:
            return 2
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            
            switch indexPath.row {
            case 0:

                let cell = FormFieldCell(lengthError: (3, 0))
                cell.editField(textChanged: { (text, error) in
                    self.user.name = text

                    if let cell: FormFieldCell = tableView.cellForRow(at: indexPath) as? FormFieldCell {
                        if cell.textField.markedTextRange == nil {
                            self.user.nameKana = self.user.name?.katakanaFurigana()
                            let nameKanaIndex: IndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                            tableView.reloadRows(at: [nameKanaIndex], with: .none)
                        }
                    }
                    
                }, didReturn: {

                    let nextRow: IndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                    if let cell: FormFieldCell = tableView.cellForRow(at: nextRow) as? FormFieldCell {
                        cell.textField.becomeFirstResponder()
                    }
                })
                
                cell.textField.keyboardType = .default
                cell.textField.placeholder = "enter your name"
                cell.textField.text = self.user.name
                return cell

            case 1:
                
                let cell = FormFieldCell(lengthError: (3, 0), pregError: (.kana, nil))
                cell.editField(textChanged: { (text, _) in
                
                    self.user.nameKana = text

                }, didReturn: {
                    if let cell = tableView.cellForRow(at: indexPath) as? FormFieldCell {
                        cell.textField.resignFirstResponder()
                    }
                })
                
                cell.textField.keyboardType = .default
                cell.textField.placeholder = "enter your name kana"
                cell.textField.text = self.user.nameKana
                return cell

            default:
                return UITableViewCell()
            }
            
        case 1:

            let cell = FormFieldCell(pregError: (.email, nil))
            cell.editField(textChanged: { (text, _) in

                self.user.email = text

            }, didReturn: {
                if let cell = tableView.cellForRow(at: indexPath) as? FormFieldCell {
                    cell.textField.resignFirstResponder()
                }
            })
            
            cell.textField.keyboardType = .emailAddress
            cell.textField.placeholder = "enter your email"
            cell.textField.text = self.user.email
            return cell

        case 2:
            
            let cell = FormFieldCell(lengthError: (0, 11), pregError: (.phone, nil))
            cell.editField(textChanged: { (text, _) in

                self.user.tel = text

            }, didReturn: {
                
                if let cell = tableView.cellForRow(at: indexPath) as? FormFieldCell {
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
    
    func saveTapped(_ sender: UIBarButtonItem) {

        var message: String = ""
        if self.user.errorMessages.isEmpty {
            message = "success to save"
        } else {
            
            for (_, s) in self.user.errorMessages {
                message += s + "\n"
            }
        }
        
        self.showAlertDialog("Result", message: message, buttonTitle: "OK") {
        }
    }
}

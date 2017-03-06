//
//  ViewController.swift
//  FormCell
//
//  Created by 須藤 将史 on 2017/02/20.
//  Copyright © 2017年 masashi_sutou. All rights reserved.
//


import UIKit

extension UIViewController {
    func showAlertDialog(_ title: String, message: String, buttonTitle: String, okFunc: @escaping () -> ()) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .default) { action in
            okFunc()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

final class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = "FormCell-Demo"
        self.tableView = UITableView.init(frame: self.view.frame, style: .grouped)
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "All-Mandatory"
        case 1:
            cell.textLabel?.text = "All-Optional"
        case 2:
            cell.textLabel?.text = "Mix"
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(MandatoryViewController(), animated: true)
        case 1:
            self.navigationController?.pushViewController(OptionalViewController(), animated: true)
        case 2:
            self.navigationController?.pushViewController(MixViewController(), animated: true)
        default:
            break
        }
    }
}

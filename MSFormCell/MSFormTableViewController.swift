//
//  MSFormTableViewController.swift
//  MSFormCell
//
//  Created by 須藤 将史 on 2017/02/20.
//  Copyright © 2017年 masashi_sutou. All rights reserved.
//

import UIKit

open class MSFormTableViewController: UITableViewController {
    
    final public func inValidCells() -> (indexPaths: [IndexPath], cells: [MSFormCell]) {
                
        var inValidCells: [MSFormCell] = []
        var inValidIndexPaths: [IndexPath] = []
        
        let sections: Int = self.tableView.numberOfSections
        for i in 0..<sections {
            let rows: Int = self.tableView.numberOfRows(inSection: i)
            for t in 0..<rows {
                let idx: IndexPath = IndexPath(row: t, section: i)
                if let cell = tableView.cellForRow(at: idx) as? MSFormCell {
                    if !cell.isValid {
                        cell.showLabel()
                        inValidCells.append(cell)
                        inValidIndexPaths.append(idx)
                    }
                }
            }
        }
        
        return (inValidIndexPaths, inValidCells)
    }
    
    // Return nil is no inValidCell.
    
    final public func inValidCellFirstIndexPath() -> IndexPath? {
        
        return self.inValidCells().indexPaths.first
    }
}

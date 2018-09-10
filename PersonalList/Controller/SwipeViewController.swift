//
//  SwipeViewController.swift
//  PersonalList
//
//  Created by Petar Lemajic on 9/10/18.
//  Copyright © 2018 Metalic_archaea. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell

        cell.delegate = self

        return cell
    }

    fileprivate func categoryDelete(with indexPath: IndexPath) {
        self.updateModel(at: indexPath)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.categoryDelete(with: indexPath)
        }

        deleteAction.image = UIImage(named: "delete_icon")
        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }

    func updateModel(at indexPath: IndexPath) { }
}

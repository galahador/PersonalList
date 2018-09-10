//
//  TodoTableViewController.swift
//  PersonalList
//
//  Created by Petar Lemajic on 9/4/18.
//  Copyright © 2018 Metalic_archaea. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class TodoTableViewController: SwipeViewController {
    var todoItems: Results<Item>?
    let realm = try! Realm()

    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items Added"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        writeToRealmDoneChack(with: indexPath)
    }

    override func updateModel(at indexPath: IndexPath) {
        deleteItem(with: indexPath)
    }

    fileprivate func deleteItem(with indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Deleteing errror \(error)")
            }
        }
    }

    fileprivate func writeToRealmDoneChack(with indexPath: IndexPath) {
        if let items = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    items.done = !items.done
                }
            } catch {
                print("We have a problem \(error)")
            }
        }
        //        saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    fileprivate func writeToRealmNewItem(textField: UITextField) {
        if let currentCategory = self.selectedCategory {
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dataCreated = Date()
                    currentCategory.items.append(newItem)
                }
            } catch {
                print("Error saving new item \(error)")
            }
            self.tableView.reloadData()
        }
    }

    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    fileprivate func setupAlertWithTextField() {
        var textField = UITextField()
        let alertVC = UIAlertController(title: "add new?", message: "Do you wont to add new?", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add item", style: .default) { (action) in
            self.writeToRealmNewItem(textField: textField)
        }
        alertVC.addTextField(configurationHandler: { (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        })
        alertVC.addAction(alertAction)
        present(alertVC, animated: true, completion: nil)
    }

    @IBAction func addNewItems(_ sender: UIBarButtonItem) {
        setupAlertWithTextField()
    }
}

extension TodoTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

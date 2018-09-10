//
//  CategoryViewController.swift
//  PersonalList
//
//  Created by Petar Lemajic on 9/4/18.
//  Copyright © 2018 Metalic_archaea. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeViewController {

    var categoryArray: Results<Category>?
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        tableView.rowHeight = 100
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categorys yet"
//        cell.delegate = self

        return cell
    }

    //MARK - Table View Delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }

    //MARK - Data Manipulation method

    fileprivate func saveCategory(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Realm fail to save \(error) \(#function)")
        }
    }

    fileprivate func loadCategory() {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }

    //MARK: - Motion
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        setupAlertController()
    }

    //MARK: - Seting up Alert Controller logic
    fileprivate func setupAlertController() {
        var textFiled = UITextField()
        let alertController = UIAlertController(title: "Add", message: "Wont to add new?", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in

            let newCategory = Category()
            newCategory.name = textFiled.text!

            self.saveCategory(category: newCategory)
            self.tableView.reloadData()
        }
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new ?"
            textFiled = alertTextField
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }

    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDelition = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDelition)
                }
            } catch {
                print("Problem with delete \(error)")
            }
        }
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        setupAlertController()
    }
}

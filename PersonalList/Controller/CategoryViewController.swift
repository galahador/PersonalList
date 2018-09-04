//
//  CategoryViewController.swift
//  PersonalList
//
//  Created by Petar Lemajic on 9/4/18.
//  Copyright © 2018 Metalic_archaea. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    //MARK - Table View Delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    fileprivate func saveCategory() {
        do {
            try context.save()
        } catch {
            print("save error \(error) \(#function)")
        }
    }
    
    fileprivate func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error with loading category \(error) \(#function)")
        }
    }
    
    //MARK - Data Manipulation method
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textFiled = UITextField()
        let alertController = UIAlertController(title: "Add", message: "Wont to add new?", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textFiled.text!
            self.saveCategory()
            self.categoryArray.append(newCategory)
            self.tableView.reloadData()
        }
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new ?"
            textFiled = alertTextField
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteTapped(_ sender: UIBarButtonItem) {
        
    }
}

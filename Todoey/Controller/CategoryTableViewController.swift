//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by huashen liang on 2019-05-20.
//  Copyright © 2019 huashen liang. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
    }

    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let alertInput = UIAlertController(title: "Error", message: "Category cannot be empty", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            //what will happen when the user click add in alert
            if textField.text?.count == 0 {
                self.present(alertInput, animated: true, completion: nil)
            }else{
                //create new NS managed object, newCategory
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                
                //add newCategory ro the array
                self.categoryArray.append(newCategory)
                
                self.saveCategory()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new category"
            textField = alertTextField
        }
        
        alertInput.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertInputAction) in
            alertInput.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    
    }
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategory(){
        do {
            try context.save()
        } catch  {
            print("Saving error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory(){
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch  {
            print("Loading error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //will be triggered just before perform the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
}

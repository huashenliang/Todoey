//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by huashen liang on 2019-05-20.
//  Copyright © 2019 huashen liang. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipTableViewController {

    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
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
                
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.cellColour = UIColor.randomFlat.hexValue()
                self.save(category: newCategory)
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
        
        //this going to return the cell that gets created inside superView, take that cell and modify more
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row]{
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.cellColour) else {fatalError()}
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor , returnFlat: true)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return categories?.count ?? 1
    }
    
    //MARK: - Data Manipulation Methods
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch  {
            print("Saving error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory(){
        
        //will pull out all of the items inside realm that are Category object
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    //MARK: - Dlete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let deleteCategory = self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(deleteCategory)
                }
            }catch{
                print("Deleting error: \(error)")
            }
        }
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //will be triggered just before perform the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
           destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}

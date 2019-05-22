//
//  ViewController.swift
//  Todoey
//
//  Created by huashen liang on 2019-05-06.
//  Copyright © 2019 huashen liang. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category?{
        //get called when selectedCategory gets set a value
        didSet{
            loadItems()
        }
    }
    
    //FileManager -> the object that provides an interface to the file system
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //UIApplication -> tapping into UIApplication class
    //shared -> shared singleton object which corresponds to the current app as an object
    //delegate -> tapping into its delegate, which has the data type of an optional UIApplicationDelegate
    //as! AppDelegate -> casting it into our class 'AppDelegate'
    //now have access to AppDelegate as an object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        print(dataFilePath!)
    }
    
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator
        // value = condition ? valueIfTure : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
       
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print("\(indexPath.row) : \(itemArray[indexPath.row])")
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK - Add New Items
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let alertInput = UIAlertController(title: "Error", message: "Item cannot be empty", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (alertAction) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            if(textField.text == ""){
                self.present(alertInput, animated: true, completion: nil)
            }else{
            
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                
                //parentCategory is the relationships created in datamodel for 'Item' entity
                newItem.parentCategory = self.selectedCategory
                
                self.itemArray.append(newItem)
                
                self.saveItems()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(alertAction)
        
        alertInput.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            alertInput.dismiss(animated: true, completion: nil)
        }))
        
        //show the alert
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func saveItems(){

        do {
           try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        
            tableView.reloadData()
    }
    
    //Item.fetchRequest() is the default value
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //if predicate is not nil
        if let additionalPredicate = predicate {
            //set the predicate as NSCompoundPredicate, which will search for parenetCategory.name and item.title
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            
            request.predicate = categoryPredicate
        }
                
        //new constant 'request',  type as NSFetchRequest, going to return an array of type'item'
        //A description of search criteria used to retrieve data from a persistent store.
        //blank request that pulls back everthing that's currently inside our persistent container
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("request error: \(error)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK: - Search bar function
extension TodoListViewController: UISearchBarDelegate{

//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        //structed the query
//        //add query to the request
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@",searchBar.text!)
//
//        //sort the result in alphabetical order
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
//
//        loadItems(with: request)
//
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                }
            }else{
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            //search for item title name
            let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
            
            request.predicate = predicate
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request, predicate: predicate)
        }
    }
}


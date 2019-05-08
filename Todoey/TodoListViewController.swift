//
//  ViewController.swift
//  Todoey
//
//  Created by huashen liang on 2019-05-06.
//  Copyright © 2019 huashen liang. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
   
    var itemArray = ["Workout","Swift","Guitar"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print("\(indexPath.row) : \(itemArray[indexPath.row])")
        
        //grabbing a reference to the cell that is at a particular indexpath
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
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
                self.itemArray.append(textField.text!)
                
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                
                self.tableView.reloadData()
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
    
}


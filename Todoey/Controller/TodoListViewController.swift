//
//  ViewController.swift
//  Todoey
//
//  Created by huashen liang on 2019-05-06.
//  Copyright © 2019 huashen liang. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipTableViewController {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category?{
        //get called when selectedCategory gets set a value
        didSet{
           loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    }
    
    //app life cycle method
    //gets called lated than viewDidLoad, just right before the view is going to show up on the screen
    override func viewWillAppear(_ animated: Bool) {
        
         title = selectedCategory?.name
        
        guard let colorHex = selectedCategory?.cellColour else{ fatalError() }
        
        updateNavBar(withHexCode: colorHex)
        
    }
    
    //app life cycle method
    //gets called when the view is just about to be removed from the view hierarchy or navigation stack
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D98F6")
    }
    
    
    //MARK: - Nav Bar setup Methods
    func updateNavBar(withHexCode colorHexCode: String){
         guard let navBar = navigationController?.navigationBar else{fatalError("Navigation controller does not exist")}
        
        guard let navBarColor = UIColor(hexString: colorHexCode)else{ fatalError() }
        
        navBar.barTintColor = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
        
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.cellColour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            //Ternary operator
            // value = condition ? valueIfTure : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //indexPath.row -> click on the row
        //look into todoItem List, find the particular item at that index
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                   
                }
            }catch{
                print("Writing error: \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Dlete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let deleteItem = self.todoItems?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(deleteItem)
                }
            }catch{
                print("Deleting error: \(error)")
            }
        }
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
                
                if let currnetCategory = self.selectedCategory{
                    do{
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.creadtedDate = Date()
                            currnetCategory.items.append(newItem)
                        }
                    }catch{
                        print("Error saving new items, \(error)")
                    }
                }
            
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

    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}


extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


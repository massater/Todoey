//
//  ViewController.swift
//  Todoey
//
//  Created by ravizza on 5/27/18.
//  Copyright © 2018 ravizza. All rights reserved.
//

import UIKit
import CoreData


class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        print(item)
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    // MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item(context: self.context)
            newItem.title = textField.text
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            //self.defaults.setValue(self.itemArray, forKey: "TodoListArray")
            self.saveItems()
           
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        //let encoder = PropertyListEncoder()
        do{
            
           try self.context.save()
        } catch{
            print("Error saving context \(error)")
        }
        
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
    }
    
}

extension ToDoListViewController : UISearchBarDelegate {
    //MARK: - Search Bar Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
       
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        print("Searching...")
        loadItems(with: request, predicate: predicate)
     
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






//
//  ViewController.swift
//  Got To Do
//
//  Created by lu she on 2018-04-11.
//  Copyright © 2018 lu she. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    var itemArray: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // set the number of rows of table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    // set cell to display itemArray
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       
        if let item = itemArray?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    // give a checkmark for a cell that is clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        if let item = itemArray?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // add
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                        
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
//    func saveItems(){
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context \(error)")
//        }
//        self.tableView.reloadData()
//    }
    
    func loadItems() {

        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    
    
}

extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
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


//
//  CoreDataManager.swift
//  EmptyFridge
//
//  Created by Flore Gridaine on 2023-02-21.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    // MARK: - Static Properties
    static let container = (UIApplication.shared.delegate as! AppDelegate).getPersistentContainer()
    static let context = container.viewContext
    
    // MARK: - Static Methods
    static func saveDataList(withName name: String) {
        let list = NSEntityDescription.insertNewObject(forEntityName: "List", into: context) as! List
        list.listName = name
        do {
            try context.save()
            print("List saved successfully.")
        } catch {
            print("Error saving list: \(error.localizedDescription)")
        }
    }
    
    static func saveDataItem(withName name: String, quantity: Int, inList list: List) {
    
        let items = Item(context: context)
        items.itemName = name
        items.itemQuantity = Int16(quantity)
        items.lists = list
        do {
            try context.save()
            print("Item saved successfully.")
        } catch {
            print("Error saving list: \(error.localizedDescription)")
        }
    }
    
    static func fetchDataList() -> [List]? {
        // renvoi un tableau de la subclass de l'entite
        let fetchRequest: NSFetchRequest<List> = List.fetchRequest() // nom de l'entité
        
        do {
            let lists = try context.fetch(fetchRequest)
            print("fetch\(lists)")
            return lists
        } catch {
            print("Error fetching lists: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func fetchDataItem(_ selectedList: List?) -> [Item]? {
        
        guard let selectedList = selectedList else { return nil }
        
        // On crée une requête pour récupérer les items de la liste sélectionnée
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "lists == %@", selectedList)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "itemName", ascending: true)
        ]
        do {
            let items = try context.fetch(fetchRequest)
            print("fetch\(items)")
            return items
        } catch {
            print("Error fetching lists: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func updateData(withName name: String, quantity: Int, inList list: List) {
        //recupere item existant en fonction de la liste et du nom de l'item
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "itemName == %@ AND lists == %@", name, list)
        
        do {
            let results = try context.fetch(request)
            //update la quantite de l'objet existant recuperer lors du fetch
            if let existingItem = results.first {
                existingItem.itemQuantity = Int16(quantity)
                try context.save()
                print("Item updated successfully.")
            } else {
                //creer un nouvel item si le fetch est nul
                let newItem = Item(context: context)
                newItem.itemName = name
                newItem.itemQuantity = Int16(quantity)
                newItem.lists = list
                try context.save()
                print("Item saved successfully.")
            }
        } catch {
            print("Error saving list: \(error.localizedDescription)")
        }
    }
    
    static func deleteData(data: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(data)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("error when deleting data \(error)")
        }
    }
    
    static func deleteDataItem(withName itemName: String, inList list: List) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "itemName == %@ AND lists == %@", itemName, list)
        
        do {
            let items = try context.fetch(request)
            for item in items {
                context.delete(item)
            }
            
            try context.save()
            print("Item deleted successfully.")
        } catch {
            print("Error deleting item: \(error.localizedDescription)")
        }
    }
}

//
//  ItemTableController.swift
//  EmptyFridge
//
//  Created by Flore Gridaine on 2023-02-11.
//

import UIKit
import CoreData

final class ItemTableViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet var tableViewItem: UITableView!
    
    // MARK: - Properties
    private var items = [Item]()
  //  private var itemArray = [Product]()
    var selectedList: List?
    
    // MARK: - Cycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let data = JSON.readJSONFromFile(forName: "itemList") else { return }
        JSON.parse(jsonData: data)
        loadDataItem()
   
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationWhenDismiss), name: NSNotification.Name("dismissModal"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataItem()
    }
    
    private func loadDataItem() {
        guard let items = CoreDataManager.fetchDataItem(selectedList) else { return }
        self.items = items
        tableViewItem.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionSegue" {
            let destinationVC = segue.destination as! ItemCollectionViewController
            destinationVC.selectedList = selectedList
        }
    }
    
    
    @objc func handleNotificationWhenDismiss() {
        loadDataItem()
    }
    
    func getImageName(itemName: String) -> String {
            for product in itemArray where itemName == product.name  {
                return product.imageName
             }
             return "default"
                }
}

// MARK: - extension UICollectionViewDataSource UICollectionViewDelegate
extension ItemTableViewController:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell else { return UITableViewCell() }
        
        let itemName = items[indexPath.row].itemName ?? ""
        let itemQuantity = items[indexPath.row].itemQuantity
        let imageName: String = getImageName(itemName: itemName)
        cell.configureItemCell(label: itemName, itemQuantity: "\(itemQuantity)", imageName: imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataManager.deleteData(data: items[indexPath.row])
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - Data Methods
extension ItemTableViewController: PassData {
    func didPassData() {
        loadDataItem()
        tableViewItem.reloadData()
    }
}

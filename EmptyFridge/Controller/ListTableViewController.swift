//
//  ListTableViewController.swift
//  EmptyFridge
//
//  Created by Flore Gridaine on 2023-02-11.
//

import Foundation
import UIKit
import CoreData

final class ListTableViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableViewList: UITableView!
    
    // MARK: - Properties
    private var listArray = [List]()
    private var selectedList: List?
    private var didSelectList: ((List) -> Void)?
    
    // MARK: - CycleView
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataInList()
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? AddListViewController {
            destinationVC.delegate = self
        } else if let destinationVC = segue.destination as? ItemTableViewController {
            if let selectedIndexPath = tableViewList.indexPathForSelectedRow {
                let selectedList = listArray[selectedIndexPath.row]
                destinationVC.selectedList = selectedList
            }
        }
    }
    
    // MARK: - Private Methods
    private func loadDataInList() {
        guard let lists = CoreDataManager.fetchDataList() else { return }
        self.listArray = lists
        tableViewList.reloadData()
    }
    
    func didSelectList(_ list: List) {
        selectedList = list
        performSegue(withIdentifier: "ShowItems", sender: self)
    }
}
    
    // MARK: - extension UICollectionViewDataSource UICollectionViewDelegate
    extension ListTableViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return listArray.count
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
            let listName: String = listArray[indexPath.row].value(forKey: "listName") as? String ?? ""
            cell.configureCell(list: listName )
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //savoir quel liste on a cliqué
            let selectedList = listArray[indexPath.row]
            //creer un UIcontroller
            guard let itemViewController = storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as? ItemTableViewController else { return }
            itemViewController.selectedList = selectedList
            //variable du new VC = variable du VC actuel
            didSelectList?(selectedList)
            print(selectedList)
            show(itemViewController, sender: nil)
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                CoreDataManager.deleteData(data: listArray[indexPath.row])
                listArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    extension ListTableViewController : PassData {
        // MARK: - Data Methods
        func didPassData() {
            dismiss(animated: true, completion: nil)
            presentAlert(title: "Your new grocery list has been created", message: "")
            loadDataInList()
            tableViewList.reloadData()
        }
        
        // MARK: - Alert Methods
        private func presentAlert(title: String, message: String) {
            // Create a new alert
            let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            //Add OK button to an Alert object
            dialogMessage.addAction(ok)
            // Present alert to user
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }

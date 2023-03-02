//
//  ViewController.swift
//  EmptyFridge
//
//  Created by Flore Gridaine on 2023-02-11.
//

import UIKit
import CoreData

class AddListViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var listNameTextField: UITextField!
    private var listArray = [List]()
    private var groceryListName = [GroceryList]()
    var delegate: PassData!
    
    // MARK: - cycleView
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func tappedOKButton(_ sender: Any) {
        guard let listName = listNameTextField.text, !listName.isEmpty else { return }
        CoreDataManager.saveDataList(withName: listName)
        //MARK: - ajouter verification que le nom de la liste n'existe pas
        dismiss(animated: true, completion: nil)
        delegate?.didPassData()
    }
}

// MARK: - Keyboard
extension AddListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func dismiss(_ sender: UITapGestureRecognizer) {
        listNameTextField.resignFirstResponder()
    }
}

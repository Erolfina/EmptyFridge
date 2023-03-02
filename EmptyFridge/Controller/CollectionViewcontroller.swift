//
//  CollectionViewcontroller.swift
//  EmptyFridge
//
//  Created by Flore Gridaine on 2023-02-18.
//
import UIKit
import CoreData

class ItemCollectionViewController: UIViewController {
    
    //MARK: - Properties
    var itemsDictionary:[String: Int] = [:]
    var selectedList: List?
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - CycleView
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataInCollectionView()
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismiss(animated: true)
                                NotificationCenter.default.post(name: NSNotification.Name("dismissModal"), object: nil)
        }
    
    //MARK: - Actions
    @IBAction func didTapStepper(_ sender: Any) {
        if let stepper = sender as? UIStepper {
            // Récupération de l'index path de la cellule concernée
            //cette ligne convertit les coordonnées du point de la vue du stepper à la vue de la collection view
            let point = stepper.convert(stepper.bounds.origin, to: collectionView)
            //l'indexPath correspond au point convertit du sender
            guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
            //on cast la customcollectioncell pour recuperer les infos des outlets
            guard let cell = collectionView.cellForItem(at: indexPath) as? ItemCollectionViewCell else { return }
            
            if let list = selectedList {
                guard let itemName = cell.labelCell.text else { return }
                let oldQuantity = itemsDictionary[itemName] ?? 0
                let newQuantity = Int(stepper.value)
                manageData(itemName: itemName, list: list, oldQuantity: oldQuantity, newQuantity: newQuantity )
                collectionView.reloadData()
            }
        }
    }
    //MARK: - Private Methods
    
    private func loadDataInCollectionView() {
        if let list = selectedList {
            guard let itemsToFetch = CoreDataManager.fetchDataItem(list) else { return }
           
            for item in itemsToFetch {
                if let name = item.itemName {
                    itemsDictionary[name] = Int(item.itemQuantity)
                }
            }
        }
    }
    
    private func manageData(itemName: String, list: List, oldQuantity: Int, newQuantity: Int ) {
          if newQuantity == 0 {
             itemsDictionary[itemName] = nil
             CoreDataManager.deleteDataItem(withName: itemName, inList: list)
         } else if newQuantity != oldQuantity {
             itemsDictionary[itemName] = newQuantity
             CoreDataManager.updateData(withName: itemName, quantity: newQuantity, inList: list)
         }
     }
}

// MARK: - extension UICollectionViewDataSource UICollectionViewDelegate
extension ItemCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCollectionCell", for: indexPath) as? ItemCollectionViewCell else { return UICollectionViewCell() }
        
        
        let itemName = itemArray[indexPath.row].name
        let imageName = itemArray[indexPath.row].imageName
        var quantity = 0

        if itemsDictionary.contains(where: { $0.key == itemName }) {
            quantity = itemsDictionary[itemName] ?? 0
        }
        
        cell.configureItemCell(label: itemName, quantity: quantity, imageName:imageName)
        cell.stepper.value = Double(itemsDictionary[itemName] ?? 0)
        return cell
    }
    
}
extension ItemCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfSplit = 3
        let borderConstraint = 14 //define in storyBoard
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        
        let screenWidth: Int  = Int(UIScreen.main.bounds.width) - (2 * borderConstraint)
        let cellWidth = (CGFloat(screenWidth) - layout.minimumInteritemSpacing * CGFloat(numberOfSplit-1) ) / CGFloat(numberOfSplit)
        
        let cellHeight: CGFloat = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

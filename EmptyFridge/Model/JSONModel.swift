//
//  JSONModel.swift
//  EmptyFridge
//
//  Created by Flore Gridaine on 2023-02-18.
//

import Foundation

//MARK: - Public Properties
var itemArray = [Product]() //Json

class JSON {
    //MARK: - JSON Methods
    static func readJSONFromFile(forName fileName: String) -> Data? {  // lire le fichier json
        do {
            if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
                let jsonData = try String(contentsOfFile: path).data(using: .utf8)
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    static func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode(Items.self, from: jsonData)
            for category in decodedData.categories {
                for item in category.items{
                    getItemName(name: item.name, imageName: item.imageName)
                    sortedAlphabatically()
                }
            }
        } catch {
            print("error: \(error)")
        }
    }
    
    //MARK: - Public Methods
    static func getItemName(name: String, imageName: String) {
        let product = Product(name: name, imageName: imageName)
        itemArray.append(product)
        print(itemArray)
    }
    
    //MARK: - Private Methods
    static func sortedAlphabatically() {
        itemArray.sort { $0.name < $1.name }
    }
}

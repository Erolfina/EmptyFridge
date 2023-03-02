//
//  Items.swift
//  EmptyFridge
//
//  Created by Flore Gridaine on 2023-02-12.
//


import Foundation

// MARK: - Items
struct Items: Codable {
    let categories: [Category]
}

// MARK: - Category
struct Category: Codable {
    let name: String
    let items: [Product]
}

// MARK: - Product
struct Product: Codable {
    let name : String
    let imageName: String
}

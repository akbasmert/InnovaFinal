//
//  CoreDataManager.swift
//  InnovaFinal
//
//  Created by Mert AKBAŞ on 8.10.2024.
//

import CoreData
import UIKit
import InnovaFinalAPI

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    func saveProductData(
        id: Int,
        name: String,
        price: Int,
        image: String,
        brand: String,
        category: String,
        productNumber: Int
    ) {

        DispatchQueue.main.async {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            let newProduct = NSEntityDescription.insertNewObject(
                forEntityName: "ProductsEntity",
                into: context
            )
            
            newProduct.setValue(id, forKey: "id")
            newProduct.setValue(name, forKey: "productName")
            newProduct.setValue(brand, forKey: "productBrand")
            newProduct.setValue(category, forKey: "productCategory")
            newProduct.setValue(id, forKey: "productId")
            newProduct.setValue(image, forKey: "productImage")
            newProduct.setValue(price, forKey: "productPrice")
          
            
            do {
                
                try context.save()
                
            } catch let error as NSError {
                print("Failed to save audio data: \(error), \(error.userInfo)")
            }
        }
    }
    
    func fetchProductData() -> [ProductsEntity] {

        var productEntities: [ProductsEntity] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return productEntities
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ProductsEntity> = ProductsEntity.fetchRequest()
        
        do {
            
            productEntities = try context.fetch(fetchRequest)

        } catch let error as NSError {
            print("Failed to fetch audio data: \(error), \(error.userInfo)")
        }
        return productEntities
    }
    
    func deleteProductData(withID id: Int) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<ProductsEntity> = ProductsEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            
            do {
                let result = try context.fetch(fetchRequest)
                try context.save()
                for object in result {
                    context.delete(object)
                }
                try context.save()
            } catch let error as NSError {
                print("Failed to delete audio data: \(error), \(error.userInfo)")
            }
        }
    }
}


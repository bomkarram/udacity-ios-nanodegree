//
//  MemeData.swift
//  MemeMe 2.0
//
//  Created by Abdulrahman Alamoudi on 2/13/19.
//  Copyright © 2019 Abdulrahman Alamoudi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MemeData {


    let appDelegate: AppDelegate
    let context: NSManagedObjectContext
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
//      for debugging to remove current saved data
//        self.clearMemeList()
    }
    
    func addMeme(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        let entity = NSEntityDescription.entity(forEntityName: "SentMemes", in: context)
        let newMeme = NSManagedObject(entity: entity!, insertInto: context)
        
        newMeme.setValue(topText, forKey: "topText")
        newMeme.setValue(bottomText, forKey: "bottomText")
        newMeme.setValue(originalImage, forKey: "originalImage")
        newMeme.setValue(memedImage, forKey: "memedImage")

        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func getMemeList() -> [NSManagedObject] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "SentMemes")
        do {
            return try context.fetch(request)
        } catch {
            print("Failed")
        }
        return [NSManagedObject]()
    }
    
    func clearMemeList() {
        let request = NSFetchRequest<NSManagedObject>(entityName: "SentMemes")
        do {
            if let result = try? context.fetch(request) {
                for object in result {
                    context.delete(object)
                }
            }
            try context.save()
        } catch {
            print("Failed")
        }
    }
}

//
//  SentMemes+CoreDataProperties.swift
//  MemeMe 2.0
//
//  Created by Abdulrahman Alamoudi on 2/14/19.
//  Copyright © 2019 Abdulrahman Alamoudi. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

extension SentMemes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SentMemes> {
        return NSFetchRequest<SentMemes>(entityName: "SentMemes")
    }

    @NSManaged public var topText: String?
    @NSManaged public var bottomText: String?
    @NSManaged public var originalImage: UIImage?
    @NSManaged public var memedImage: UIImage?

}

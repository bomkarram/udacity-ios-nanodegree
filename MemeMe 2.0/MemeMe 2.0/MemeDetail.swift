//
//  MemeDetail.swift
//  MemeMe 2.0
//
//  Created by Abdulrahman Alamoudi on 2/11/19.
//  Copyright © 2019 Abdulrahman Alamoudi. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailView: UIViewController {
    
    @IBOutlet weak var memeView: UIImageView!
    var memeImage: UIImage! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        memeView.image = memeImage
    }
}

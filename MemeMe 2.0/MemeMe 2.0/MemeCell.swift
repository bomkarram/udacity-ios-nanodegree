//
//  MemoCell.swift
//  MemeMe 2.0
//
//  Created by Abdulrahman Alamoudi on 1/19/19.
//  Copyright © 2019 Abdulrahman Alamoudi. All rights reserved.
//

import UIKit

class MemeCell: UITableViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeLabel: UILabel!
    
    func setMeme(meme: Meme) {
        memeImageView.image = meme.memedImage
        memeLabel.text = meme.topText + " ... " + meme.bottomText
    }
    
}


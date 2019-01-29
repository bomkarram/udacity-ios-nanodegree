//
//  MemeView.swift
//  MemeMe 2.0
//
//  Created by Abdulrahman Alamoudi on 1/19/19.
//  Copyright © 2019 Abdulrahman Alamoudi. All rights reserved.
//

import UIKit

// NOTE TO MYSELF: In storyboard DON'T FORGET to set the outlet for the table outlets (dataSource + delegate)
class MemeTableView: UITableViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UIApplication.shared.delegate as! AppDelegate).memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let memes = (UIApplication.shared.delegate as! AppDelegate).memes
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell") as! MemeCell
        cell.setMeme(meme: meme)

        return cell
    }
}

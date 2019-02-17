//
//  SentMemes.swift
//  MemeMe 2.0
//
//  Created by Abdulrahman Alamoudi on 1/19/19.
//  Copyright © 2019 Abdulrahman Alamoudi. All rights reserved.
//

import UIKit
import CoreData

class MemeTableViewController: UITableViewController{
    
    override func viewWillAppear(_ animated: Bool) {
        // refresh view after adding new meme
        self.tableView.reloadData()
    }
    
    @IBAction func addMeme(_ sender: Any) {
        // show SentMemes page
        let storyBoard = UIStoryboard(name: "MemeEditor", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "MemeEditor") as! MemeEditor
        self.present(controller, animated: true, completion: nil)
    }
    
    /* Table */
    // NOTE TO MYSELF: In storyboard DON'T FORGET to set the outlet for the table outlets (dataSource + delegate)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let memeData = MemeData()
        let memeList = memeData.getMemeList()
        return memeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let memeData = MemeData()
        let memeList = memeData.getMemeList()

        let topText = memeList[indexPath.row].value(forKey: "topText") as! String
        let bottomText = memeList[indexPath.row].value(forKey: "bottomText") as! String
        let memedImage = memeList[indexPath.row].value(forKey: "memedImage") as! UIImage

        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as! MemeTableViewCell
        cell.setMeme(topText: topText, bottomText: bottomText, memedImage: memedImage)
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MemeDetailView", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as! Int
        
        let memeData = MemeData()
        let memeList = memeData.getMemeList()
        let memeImage =  memeList[index].value(forKey: "memedImage") as! UIImage
        
        let vc = segue.destination as! MemeDetailView
        vc.memeImage = memeImage
    }
}

/* Collection */
class MemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeLabel: UILabel!
    
    func setMeme(topText: String, bottomText: String, memedImage: UIImage) {
        memeImageView.image = memedImage
        memeLabel.text = topText + " ... " + bottomText
    }
    
}

class MemeCollectionViewController: UICollectionViewController{
    override func viewWillAppear(_ animated: Bool) {
        // refresh view after adding new meme
        self.collectionView.reloadData()
    }
    
    @IBAction func addMeme(_ sender: Any) {
        // show SentMemes page
        let storyBoard = UIStoryboard(name: "MemeEditor", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "MemeEditor") as! MemeEditor
        self.present(controller, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let memeData = MemeData()
        let memeList = memeData.getMemeList()
        return memeList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let memeData = MemeData()
        let memeList = memeData.getMemeList()

        let memedImage = memeList[indexPath.row].value(forKey: "memedImage") as! UIImage

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        cell.setMeme(memedImage: memedImage)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MemeDetailView", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as! Int
        
        let memeData = MemeData()
        let memeList = memeData.getMemeList()
        let memeImage =  memeList[index].value(forKey: "memedImage") as! UIImage
        
        let vc = segue.destination as! MemeDetailView
        vc.memeImage = memeImage
    }
}

class MemeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var memeImageView: UIImageView!
    
    func setMeme(memedImage: UIImage) {
        memeImageView.image = memedImage
    }
}

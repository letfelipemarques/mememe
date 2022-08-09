//
//  SentMemesTableView.swift
//  memeMe
//
//  Created by Felipe Marques on 02/04/22.
//

import UIKit

let tableDequeueID = "TableViewCell"

final class MemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memesRepo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableDequeueID, for: indexPath) as! TableViewCell
        let meme: Meme = appDelegate.memesRepo[indexPath.row]
        cell.cellImageView.image = meme.theMeme
        cell.cellTextLabel.text = meme.memetopText + " / " + meme.memebottomText
        cell.cellTextLabel.isEnabled = false
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            if let cell = sender as? TableViewCell {
                let detailView = segue.destination as? MemeDetailViewController
                detailView?.detailMeme = appDelegate.memesRepo[(tableView.indexPath(for: cell)?.row)!]
            }
        }
    }
}

//
//  SentMemesCollectionView.swift
//  memeMe
//
//  Created by Felipe Marques on 02/04/22.
//

import UIKit

let collectionDequeueID = "CollectionViewCell"

final class MemesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var holderView: UIView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        setupLayout(view: holderView, collection: collectionView)
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memesRepo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionDequeueID, for: indexPath) as! CollectionViewCell
        let meme: Meme = appDelegate.memesRepo[indexPath.row]
        cell.cellImageView!.image = meme.theMeme
        return cell
    }
    
    private func setupLayout(view: UIView, collection: UICollectionView) {
        
        let screenWidth: CGFloat! = view.frame.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/4, height: screenWidth/4)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            if let cell = sender as? CollectionViewCell {
                let detailView = segue.destination as! MemeDetailViewController
                detailView.detailMeme = appDelegate.memesRepo[(collectionView?.indexPath(for: cell)?.row)!]
            }
        }
    }
}

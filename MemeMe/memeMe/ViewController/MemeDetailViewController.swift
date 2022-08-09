//
//  MemeDetailViewController.swift
//  memeMe
//
//  Created by Felipe Marques on 13/04/22.
//

import UIKit

final class MemeDetailViewController: UIViewController {

    var detailMeme: Meme!
    @IBOutlet var memeImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.image = detailMeme.theMeme
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

//
//  DetailsViewController.swift
//  Flickso
//
//  Created by user on 9/12/17.
//  Copyright © 2017 YSH. All rights reserved.
//

import UIKit
import SVProgressHUD

class DetailsViewController: UIViewController {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    var movie:[String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsLabel.sizeToFit()
        
        titleLabel.text = movie["title"] as? String
        detailsLabel.text = movie["overview"] as? String
        
        if let path = movie["poster_path"] as? String {

            let smallBaseUrl = "http://image.tmdb.org/t/p/w45"
            let largeBaseUrl = "http://image.tmdb.org/t/p/original"
            
            movieImage.setImageWithTwoURLS(smallImageURL: smallBaseUrl+path, largeImagURL: largeBaseUrl+path)

        }
        
        SVProgressHUD.dismiss()
    }
}

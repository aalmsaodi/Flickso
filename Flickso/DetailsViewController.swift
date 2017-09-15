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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var infoView: UIView!
    
    var movie:[String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        titleLabel.text = movie["title"] as? String
        
        detailsLabel.text = movie["overview"] as? String
        
        detailsLabel.sizeToFit()
                
        SVProgressHUD.dismiss()
        
        var posterUrl: URL!
        if let path = movie["poster_path"] as? String {
            let baseUrl = "http://image.tmdb.org/t/p/w500/"
            posterUrl = URL(string: baseUrl + path)!
        }
        
        movieImage.setImageWith(posterUrl)
    }


}

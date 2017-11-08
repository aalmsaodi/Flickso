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
  
  var movie:Movie!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    detailsLabel.sizeToFit()
    
    titleLabel.text = movie.title
    detailsLabel.text = movie.synopsis
    
    if let path = movie.imageURL {
      
      let smallBaseUrl = "http://image.tmdb.org/t/p/w45"
      let largeBaseUrl = "http://image.tmdb.org/t/p/original"
      
      DispatchQueue.main.async {
        self.movieImage.setImageWithTwoURLS(smallImageURL: smallBaseUrl+path, largeImagURL: largeBaseUrl+path)
      }
    }
  }
}

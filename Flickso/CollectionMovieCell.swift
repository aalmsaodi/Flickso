//
//  CollectionMovieCell.swift
//  Flickso
//
//  Created by user on 9/14/17.
//  Copyright © 2017 YSH. All rights reserved.
//

import UIKit

class CollectionMovieCell: UICollectionViewCell {
  
  @IBOutlet weak var movieCover: UIImageView!
  
  var movie: Movie! {
    didSet {
      if let path = movie.imageURL {
        
        let BaseUrl = "http://image.tmdb.org/t/p/w154"
        if let url = URL(string: BaseUrl+path) {
          movieCover.setImageWith(url)
        }
      } else {
        movieCover.image = UIImage(named: "movie_no_cover")
      }
    }
  }
}

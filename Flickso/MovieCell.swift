//
//  MovieCell.swift
//  Flickso
//
//  Created by user on 9/12/17.
//  Copyright © 2017 YSH. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var synopsisLabel: UILabel!
  @IBOutlet weak var movieImage: UIImageView!
  
  var movie:Movie! {
    didSet{
      
      if let name = movie.title {
        titleLabel.text = name
      }
      
      if let synopsis = movie.synopsis {
        synopsisLabel.text = synopsis
      }
      
      if let path = movie.imageURL {
        
        let smallBaseUrl = "http://image.tmdb.org/t/p/w45"
        let largeBaseUrl = "http://image.tmdb.org/t/p/w342"
        
        DispatchQueue.main.async {
          self.movieImage.setImageWithTwoURLS(smallImageURL: smallBaseUrl+path, largeImagURL: largeBaseUrl+path)
        }
      } else {
        movieImage.image = UIImage(named: "movie_no_cover")
      }
    }
  }
}

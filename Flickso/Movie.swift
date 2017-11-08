//
//  Movie.swift
//  Flickso
//
//  Created by user on 9/17/17.
//  Copyright © 2017 YSH. All rights reserved.
//

import Foundation

class Movie {
  var title:String!
  var synopsis:String!
  var imageURL:String?
  
  init(dictionary: NSDictionary) {
    self.title = dictionary["title"] as! String
    self.synopsis = dictionary["overview"] as! String
    self.imageURL = dictionary["poster_path"] as? String
  }
  
}

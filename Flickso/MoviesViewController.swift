//
//  MoviesViewController.swift
//  Flickso
//
//  Created by user on 9/12/17.
//  Copyright © 2017 YSH. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var networkError: UITextField!
    
    var movies:[[String:Any]] = [[String:Any]]()
    let refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(fetchMovies), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        
        fetchMovies()
    }
    
    func fetchMovies() {
        
        SVProgressHUD.show()
        
        let apiKey = "e6ff789f432f9f18b3fa4a4af73563c2"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task:URLSessionDataTask = session.dataTask(with: request, completionHandler: {
            (dataOrNil, response, error) in
            
            if let err = error {
                
                print(err)
                self.networkError.isHidden = false
                SVProgressHUD.dismiss()
                
            } else {
                
                self.networkError.isHidden = true
                
                if let data = dataOrNil {
                    if let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                                                
                        self.movies = dictionary["results"] as! [[String:Any]]
                        self.tableView.reloadData()
                        
                        SVProgressHUD.dismiss()
                        
                        self.refreshControl.endRefreshing()
                    }
                }
            }
        })
        
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieCell
            
        let movie = movies[indexPath.row]
        let title = movie["title"] as? String
        let synopsis = movie["overview"] as? String
        
        var posterUrl: URL!
        if let path = movie["poster_path"] as? String {
            let baseUrl = "http://image.tmdb.org/t/p/w500/"
            posterUrl = URL(string: baseUrl + path)!
        }
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        cell.movieImage.setImageWith(posterUrl)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        SVProgressHUD.show()
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies[indexPath!.row]
        
        let detailsViewController = segue.destination as! DetailsViewController
        
        detailsViewController.movie = movie 
        
    }

}

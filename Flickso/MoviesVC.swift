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


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var networkError: UITextField!
    
    var movies: [[String:Any]] = [[String:Any]]()
    var filteredMovies: [[String:Any]] = [[String:Any]]()
    var endPoint:String = ""
    
    let searchController = UISearchController(searchResultsController: nil)
    let segmentViewStyle: UISegmentedControl = UISegmentedControl(items: ["Grid View", "List View"])
    
    let refreshControlTable = UIRefreshControl()
    let refreshControlCollection = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchBar()
        configureSegementView()
        configurePullToReferch()
        configureTopBarApperance()
        
        assignDelegets()

        showSegment()
        fetchMovies()
    }
    

// MARK: - Searchbar and Filtering ****************************************************************
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String) {
        
        filteredMovies.removeAll()
        
        for movie in movies {
        
            if (movie["title"] as! String).lowercased().contains(searchText.lowercased()) {
                
                filteredMovies.append(movie)
            }
        }
        
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    
// MARK: - Fetching Movies ************************************************************************
    func fetchMovies() {
        
        SVProgressHUD.show()
        
        let apiKey = "e6ff789f432f9f18b3fa4a4af73563c2"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")
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
                        self.collectionView.reloadData()
                        
                        SVProgressHUD.dismiss()

                    }
                }
            }
        })
        
        task.resume()
        
        self.refreshControlCollection.endRefreshing()
        self.refreshControlTable.endRefreshing()
    }

    
// MARK: - Collection Views ***********************************************************************
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""  {
            
            return filteredMovies.count
            
        } else {
            
            return movies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionMovieCell", for: indexPath) as! CollectionMovieCell
        
        var movie:[String:Any]!
        
        if searchController.isActive && searchController.searchBar.text != ""  {
            
            movie = filteredMovies[indexPath.row]
            
        } else {
            
            movie = movies[indexPath.row]
        }
        
        var posterUrl: URL!
        if let path = movie["poster_path"] as? String {
            let baseUrl = "http://image.tmdb.org/t/p/w500/"
            
            posterUrl = URL(string: baseUrl + path)!
            let imageRequest = URLRequest(url: posterUrl)
            
            cell.movieCover.setImageWith(
                imageRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        cell.movieCover.alpha = 0.0
                        cell.movieCover.image = image
                        UIView.animate(withDuration: 0.5, animations: { () -> Void in
                            cell.movieCover.alpha = 1.0
                        })
                    } else {
                        cell.movieCover.image = image
                    }
            },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
            
        } else {
            cell.movieCover.image = UIImage(named: "movie_no_cover")
        }
        
        return cell
    }
    
    
// MARK: - Table Views ***************************************************************************

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != ""  {
            
            return filteredMovies.count
        
        } else {
            
            return movies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieCell
        cell.selectionStyle = .none
        
        var movie:[String:Any]!
        
        if searchController.isActive && searchController.searchBar.text != ""  {
        
            movie = filteredMovies[indexPath.row]

        } else {
           
            movie = movies[indexPath.row]
        }
        
        let title = movie["title"] as? String
        let synopsis = movie["overview"] as? String
        
        var posterUrl: URL!
        if let path = movie["poster_path"] as? String {
            let baseUrl = "http://image.tmdb.org/t/p/w500"
            
            posterUrl = URL(string: baseUrl + path)!
            let imageRequest = URLRequest(url: posterUrl)
            
            cell.movieImage.setImageWith(
                imageRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        cell.movieImage.alpha = 0.0
                        cell.movieImage.image = image
                        UIView.animate(withDuration: 0.5, animations: { () -> Void in
                            cell.movieImage.alpha = 1.0
                        })
                    } else {
                        cell.movieImage.image = image
                    }
            },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
        
        } else {
            cell.movieImage.image = UIImage(named: "movie_no_cover")
        }
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        return cell
    }
    
    
// MARK: - Segue *******************************************************************************
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let movie:[String:Any]!
        let indexPath:IndexPath!
        
        SVProgressHUD.show()
        
        if segue.identifier == "fromTableCell" {
            
            let cell = sender as! UITableViewCell
            indexPath = tableView.indexPath(for: cell)
            
        } else {
            
            let cell = sender as! UICollectionViewCell
            indexPath = collectionView.indexPath(for: cell)
        }
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            movie = filteredMovies[indexPath!.row]
            searchController.isActive = false
            
        } else {
            
            movie = movies[indexPath!.row]
        }
        
        let detailsViewController = segue.destination as! DetailsViewController
        
        detailsViewController.movie = movie
    }
}
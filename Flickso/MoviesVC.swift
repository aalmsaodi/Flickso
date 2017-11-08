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


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var networkError: UITextField!
  
  var movies: [Movie] = []
  var filteredMovies: [Movie] = []
  var endPoint: String = ""
  var moviePageNum: Int = 0
  var isMoreDataLoading = false
  
  let searchController = UISearchController(searchResultsController: nil)
  let segmentViewStyle: UISegmentedControl = UISegmentedControl(items: ["Grid View", "List View"])
  
  let refreshControlTable = UIRefreshControl()
  let refreshControlCollection = UIRefreshControl()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initialConfiguration()
    showSegment()
    refreshMoview()
  }
  
  
  // MARK: - Searchbar and Filtering ****************************************************************
  func updateSearchResults(for searchController: UISearchController) {
    
    filterContentForSearchText(searchText: searchController.searchBar.text!)
  }
  
  func filterContentForSearchText(searchText: String) {
    
    filteredMovies.removeAll()
    
    for movie in movies {
      
      if movie.title.lowercased().contains(searchText.lowercased()) {
        
        filteredMovies.append(movie)
      }
    }
    
    tableView.reloadData()
    collectionView.reloadData()
  }
  
  
  // MARK: - Fetching Movies ************************************************************************
  
  func refreshMoview(){
    
    SVProgressHUD.show()
    
    moviePageNum = 1
    fetchData(search: "", page: String(moviePageNum))
    
  }
  
  func loadMoreMovies(){
    
    moviePageNum += 1
    fetchData(search: "", page: String(moviePageNum))
  }
  
  func fetchData(search:String, page:String) {
    
    let apiKey = "e6ff789f432f9f18b3fa4a4af73563c2"
    let url = URL(string: "https://api.themoviedb.org/3\(search)/movie/\(endPoint)?api_key=\(apiKey)&page=\(page)")
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
            
            if page == "1" {
              self.movies = (dictionary["results"] as! [NSDictionary]).map { Movie(dictionary: $0) }
            } else {
              self.movies.append(contentsOf: (dictionary["results"] as! [NSDictionary]).map { Movie(dictionary: $0) })
            }
            
            self.tableView.reloadData()
            self.collectionView.reloadData()
            
            SVProgressHUD.dismiss()
            
            self.refreshControlCollection.endRefreshing()
            self.refreshControlTable.endRefreshing()
            
            self.isMoreDataLoading = false
          }
        }
      }
    })
    
    task.resume()
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    if (!isMoreDataLoading) {
      
      let scrollViewContentHeight = tableView.contentSize.height
      let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
      let scrollViewContentHeight_2 = collectionView.contentSize.height
      let scrollOffsetThreshold_2 = scrollViewContentHeight_2 - collectionView.bounds.size.height
      
      if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) || (scrollView.contentOffset.y > scrollOffsetThreshold_2 && collectionView.isDragging) {
        
        isMoreDataLoading = true
        
        loadMoreMovies()
      }
    }
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
    
    if searchController.isActive && searchController.searchBar.text != ""  {
      
      cell.movie = filteredMovies[indexPath.row]
      
    } else {
      
      cell.movie = movies[indexPath.row]
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let height = self.view.frame.height
    let width = self.view.frame.width
    
    return CGSize(width: width/3.2, height: height/4)
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
    
    
    if searchController.isActive && searchController.searchBar.text != ""  {
      
      cell.movie = filteredMovies[indexPath.row]
      
    } else {
      
      cell.movie = movies[indexPath.row]
    }
    
    return cell
  }
  
  
  // MARK: - Segue *******************************************************************************
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    let movie:Movie!
    let indexPath:IndexPath!
    
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
  
  
  // MARK: - Initital configuration and helper functions ******************************************
  
  func initialConfiguration(){
    tableView.delegate = self
    tableView.dataSource = self
    collectionView.delegate = self
    collectionView.dataSource = self
    searchController.searchResultsUpdater = self
    
    searchController.hidesNavigationBarDuringPresentation = false;
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.barTintColor = UIColor(red: 0x33/0xFF, green:0x35/0xFF, blue: 0x33/0xFF, alpha: 1)
    
    segmentViewStyle.sizeToFit()
    segmentViewStyle.tintColor = UIColor(colorLiteralRed: 0xF5/0xFF, green: 0xCB/0xFF, blue: 0x5C/0xFF, alpha: 1)
    segmentViewStyle.backgroundColor = UIColor(colorLiteralRed: 0x33/0xFF, green: 0x35/0xFF, blue: 0x33/0xFF, alpha: 1)
    segmentViewStyle.selectedSegmentIndex = 0;
    segmentViewStyle.addTarget(self, action: #selector(viewStyle), for: UIControlEvents.valueChanged)
    
    refreshControlTable.addTarget(self, action: #selector(refreshMoview), for: UIControlEvents.valueChanged)
    refreshControlCollection.addTarget(self, action: #selector(refreshMoview), for: UIControlEvents.valueChanged)
    tableView.insertSubview(refreshControlTable, at: 0)
    collectionView.insertSubview(refreshControlCollection, at: 0)
    collectionView.alwaysBounceVertical = true
    
    UIApplication.shared.statusBarStyle = .lightContent
    UIBarButtonItem.appearance().tintColor = UIColor.white
  }
  
  func viewStyle() {
    
    if segmentViewStyle.selectedSegmentIndex == 1 { //list view selected
      tableView.isHidden = false
      
    } else { //grid view selected
      tableView.isHidden = true
    }
  }
  
  func showSearchBar() {
    self.navigationItem.titleView = searchController.searchBar
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu-style"), style: .plain, target: self, action: #selector(showSegment))
  }
  
  func showSegment() {
    self.navigationItem.titleView = segmentViewStyle
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
  }
}


//
//  MoviesVC+InitConfiguration.swift
//  Flickso
//
//  Created by user on 9/14/17.
//  Copyright © 2017 YSH. All rights reserved.
//

import UIKit

extension MoviesViewController {
    
    func assignDelegets(){
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        searchController.searchResultsUpdater = self
    }
    
    func configureSearchBar() {
        searchController.hidesNavigationBarDuringPresentation = false;
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor(red: 0x33/0xFF, green:0x35/0xFF, blue: 0x33/0xFF, alpha: 1)
    }
    
    func configureSegementView() {
        segmentViewStyle.sizeToFit()
        segmentViewStyle.tintColor = UIColor(colorLiteralRed: 0xF5/0xFF, green: 0xCB/0xFF, blue: 0x5C/0xFF, alpha: 1)
        segmentViewStyle.backgroundColor = UIColor(colorLiteralRed: 0x33/0xFF, green: 0x35/0xFF, blue: 0x33/0xFF, alpha: 1)
        segmentViewStyle.selectedSegmentIndex = 0;
        segmentViewStyle.addTarget(self, action: #selector(viewStyle), for: UIControlEvents.valueChanged)
    }
    
    func configurePullToReferch() {
        refreshControlTable.addTarget(self, action: #selector(fetchMovies), for: UIControlEvents.valueChanged)
        refreshControlCollection.addTarget(self, action: #selector(fetchMovies), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControlTable, at: 0)
        collectionView.insertSubview(refreshControlCollection, at: 0)
        
        collectionView.alwaysBounceVertical = true
    }
    
    func configureTopBarApperance() {
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

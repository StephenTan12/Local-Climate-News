//
//  ViewController.swift
//  FinalProject
//
//  Created by Stephen Tan on 3/4/21.
//  Copyright © 2021 Syn1. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UITableViewController {
    var articlesArray = [Article]()
    var isMoreDataLoading = false
    var page = 1
    var zipcode: String! {
        didSet {
            getUserLocation(zipcode: zipcode)
        }
    }
    var userLocation: CLPlacemark! {
        didSet {
            title = "\(userLocation.locality!) News"
            apiCall(city: userLocation.locality!, state: userLocation.administrativeArea!)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "Article")
        tableView.rowHeight = 200
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func getUserLocation(zipcode: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(zipcode) {
            [weak self] (placemarks, error) in
            
            if let placemark = placemarks?[0] {
                self?.userLocation = placemark
            }
        }
    }
    
    func apiCall(city: String, state: String) {
        let newCity = city.replacingOccurrences(of: " ", with: "%20")
        let newState = state.replacingOccurrences(of: " ", with: "%20")
        
        API.getArticles(page: page, city: newCity, state: newState) { (articles) in
            guard let articles = articles else {return}

            self.articlesArray = articles
            self.isMoreDataLoading = false
            self.tableView.reloadData()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Article", for: indexPath) as! ArticleCell
        let article = articlesArray[indexPath.row]
        
        cell.article = article

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articlesArray[indexPath.row]
        let vc = WebController()
        vc.article = article
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (!isMoreDataLoading) {
//            // Calculate the position of one screen length before the bottom of the results
//            let scrollViewContentHeight = tableView.contentSize.height
//            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
//            
//            // When the user has scrolled past the threshold, start requesting
//            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
//                isMoreDataLoading = true
//                
//                page += 1
//                apiCall(city: userLocation.locality!, state: userLocation.administrativeArea!)
//            }
//        }
    }
}


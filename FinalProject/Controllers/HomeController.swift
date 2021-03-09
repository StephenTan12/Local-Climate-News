//
//  HomeController.swift
//  FinalProject
//
//  Created by Stephen Tan on 3/5/21.
//  Copyright © 2021 Syn1. All rights reserved.
//

import UIKit
import CoreLocation

class HomeController: UIViewController {
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var searchBar: UISearchBar!
    var submitButton: UIButton!
    var autoButton: UIButton!
    var titleLabel: UILabel!
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        searchBar = UISearchBar()
        searchBar.keyboardType = .numberPad
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        submitButton = UIButton()
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.backgroundColor = .green
        submitButton.layer.cornerRadius = 10
        submitButton.setTitle("Explore", for: .normal)
        view.addSubview(submitButton)
        
        autoButton = UIButton()
        autoButton.translatesAutoresizingMaskIntoConstraints = false
        autoButton.backgroundColor = .green
        autoButton.layer.cornerRadius = 10
        autoButton.setTitle("Get Current Zipcode", for: .normal)
        view.addSubview(autoButton)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "ClimateNews"
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            searchBar.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            submitButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 132),
            titleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 60),
            autoButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            autoButton.widthAnchor.constraint(equalTo: submitButton.widthAnchor, constant: 50),
            autoButton.heightAnchor.constraint(equalTo: submitButton.heightAnchor),
            autoButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor)
        ])
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        
        if let zipcode = defaults.string(forKey: "zipcode") {
            transitionView(zipcode: zipcode)
        }
        else {
            showAlert()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        autoButton.addTarget(self, action: #selector(getLocation(alert:)), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(submitZipCode(_:)), for: .touchUpInside)
        searchBar.placeholder = "Enter your zipcode"
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchBar.text = ""
    }
    
    func showAlert() {
        let ac = UIAlertController(title: "Choose for location", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Get Current Location", style: .default, handler: getLocation))
        ac.addAction(UIAlertAction(title: "Enter Manually", style: .destructive))
        present(ac, animated: true)
    }
    
    @objc func getLocation(alert: UIAlertAction) {
        locationManager = CLLocationManager()
        
        locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLocation = locationManager.location
        }
        else {
            showLocationAlert()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func submitZipCode(_ sender: UIButton) {
        let zipcode = searchBar.text
        if let enteredText = zipcode {
            if validateZipcode(input: enteredText) {
                let defaults = UserDefaults.standard
                defaults.set(zipcode, forKey: "zipcode")
                transitionView(zipcode: enteredText)
            }
            else {
                showIncorrectZipcodeAlert()
            }
        }
        else {
            showEmptyAlert()
        }
    }
    
    func validateZipcode(input: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", "^[0-9]{5}(-[0-9]{4})?$").evaluate(with: input.uppercased())
    }
    
    func showEmptyAlert() {
        let ac = UIAlertController(title: "Error", message: "Cannot search for an empty zipcode", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .destructive))
        present(ac, animated: true)
    }
    func showIncorrectZipcodeAlert() {
        let ac = UIAlertController(title: "Error", message: "No Such Zipcode", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .destructive))
        present(ac, animated: true)
    }
    
    func showLocationAlert() {
        let ac = UIAlertController(title: "Location Error", message: "Cannot get location", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: reshowAlert))
        ac.addAction(UIAlertAction(title: "Do Manually", style: .destructive))
        present(ac, animated: true)
    }
    
    func reshowAlert(alert: UIAlertAction) {
        showAlert()
    }
    
    func transitionView(zipcode: String) {
        let vc = ViewController()
        vc.zipcode = zipcode
        navigationController?.pushViewController(vc, animated: true)
    }
}

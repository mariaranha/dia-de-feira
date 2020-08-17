//
//  ViewController.swift
//  DiaDeFeira
//
//  Created by Marina Miranda Aranha on 13/01/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBar()
        setMapButtons()
        
        checkLocationPermission()
        
        locationManager.delegate = self

    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       let location = locations.first!
       let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
       mapView.setRegion(coordinateRegion, animated: true)
       locationManager.stopUpdatingLocation()
    }
    
    
    /// Sets seachr bar into the navigation bar
    fileprivate func setSearchBar() {
        let searchBar = UISearchBar()
        self.navigationItem.titleView = searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Buscar Feiras"
    }
    
    
    /// Sets user tracking button and compass
    fileprivate func setMapButtons() {
        
        let trackingButton = MKUserTrackingButton(mapView: mapView)
        trackingButton.tintColor = AppColors.green
        trackingButton.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
        trackingButton.layer.borderColor = UIColor(white: 1, alpha: 0.8).cgColor
        trackingButton.layer.cornerRadius = 5
        trackingButton.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.addSubview(trackingButton)
        
        NSLayoutConstraint.activate([
                   trackingButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 16),
                   trackingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)])
        
        mapView.showsCompass = false
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
        compass.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(compass)
        compass.translatesAutoresizingMaskIntoConstraints = false
        compass.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10).isActive = true
        compass.topAnchor.constraint(equalTo: trackingButton.bottomAnchor, constant: 8).isActive = true
    }
    
    
    // MARK: - Permissions
    func checkLocationPermission() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

}


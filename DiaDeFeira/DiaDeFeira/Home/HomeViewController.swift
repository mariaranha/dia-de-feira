//
//  ViewController.swift
//  DiaDeFeira
//
//  Created by Marina Miranda Aranha on 13/01/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let locationManager = CLLocationManager()
    weak var searchDelegate: SearchResultDelegate?
    var searchController: UISearchController? = nil
    var marketsArray: [MarketModel]!
    var mapAnnotations: [MKAnnotation] = []
    var selectedFilteredDistance: Int? = nil
    var isDistanceFilterAplied: Bool = false
    var isDayFilterAplied: Bool = false
    
    
    override func viewWillAppear(_ animated: Bool) {
        if isDistanceFilterAplied {
            filterDistance(distance: selectedFilteredDistance!)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBar()
        setMapButtons()
        
        checkLocationPermission()
        
        locationManager.delegate = self
        
        // Registering custom annotations on mapview
        mapView.register(MarketAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        addMarketsAnnotations()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       let location = locations.first!
       let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
       mapView.setRegion(coordinateRegion, animated: true)
       locationManager.stopUpdatingLocation()
    }
    
    
    /// Sets seachr bar into the navigation bar
    fileprivate func setSearchBar() {
        
        if let resultViewController = self.storyboard?.instantiateViewController(withIdentifier:                                             "SearchController") as? SearchTableViewController {
            
            searchController = UISearchController(searchResultsController: resultViewController)
            searchDelegate = resultViewController
            searchController?.delegate = self
            searchController?.searchResultsUpdater = self
            searchController?.obscuresBackgroundDuringPresentation = false
            searchController?.searchBar.placeholder = "Buscar feiras"
            searchController?.hidesNavigationBarDuringPresentation = false
            searchController?.searchBar.searchBarStyle = .minimal
            searchController?.searchBar.tintColor = #colorLiteral(red: 0.1411764706, green: 0.5411764706, blue: 0.2392156863, alpha: 1)
            navigationItem.titleView = searchController?.searchBar
            definesPresentationContext = true
        }
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
    
    
    /// Adds all markets loaded from json file to the mapview
    func addMarketsAnnotations() {
        
        self.marketsArray = JSONManager.loadJSON()
        
        for market in marketsArray {
            let annotation = MKPointAnnotation()
            annotation.title = market.street
            annotation.coordinate = CLLocationCoordinate2D(latitude: market.latitude, longitude: market.longitude)
            self.mapAnnotations.append(annotation)
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "marketPin")
        annotationView.image =  UIImage(named: "marketAnnotation")
        annotationView.canShowCallout = true
        return annotationView
    }
    
    
    // MARK: - Filter
    func filterDistance(distance: Int) {
        var haversineResult: Double = 0
        self.mapView.removeAnnotations(mapAnnotations)
        self.mapAnnotations = []
        
        for market in marketsArray {
            haversineResult = haversineDinstance(userLat: locationManager.location!.coordinate.latitude,
                                                 userLong: locationManager.location!.coordinate.longitude,
                                                 marketLat: market.latitude,
                                                 marketLong: market.longitude)
            
            if Int(haversineResult) < distance {
                let annotation = MKPointAnnotation()
                annotation.title = market.street
                annotation.coordinate = CLLocationCoordinate2D(latitude: market.latitude,
                                                               longitude: market.longitude)
                self.mapAnnotations.append(annotation)
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    
    /// Mathematical formula to calculate distance between two coordinates
    func haversineDinstance(userLat: Double, userLong: Double, marketLat: Double, marketLong: Double) -> Double {
        
        var result: Double = 0
        // Converts from degrees to radians
        let degreesToRadians = { (angle: Double) -> Double in
            return (angle / 360) * 2 * .pi
        }
        
        let userLatRadians = degreesToRadians(userLat)
        let userLongRadians = degreesToRadians(userLong)
        let markerLatRadians = degreesToRadians(marketLat)
        let marketLongRadians = degreesToRadians(marketLong)
        
        // Earth radius, in meters
        let radius: Double = 6367444.7
        
        let haversin = { (angle: Double) -> Double in
            return (1 - cos(angle))/2
        }
        
        let ahaversin = { (angle: Double) -> Double in
            return 2*asin(sqrt(angle))
        }
        
        result =  (radius * ahaversin(haversin(markerLatRadians - userLatRadians) + cos(userLatRadians) * cos(markerLatRadians) * haversin(marketLongRadians - userLongRadians)))/1000
        
        
        return round(result)
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
    
    
    // MARK: - Navigation
    
    @IBAction func unwindFilter(_ seg: UIStoryboardSegue) {
    }

}

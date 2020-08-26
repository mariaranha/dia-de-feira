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
    
    let locationManager = CLLocationManager()
    var marketsArray: [MarketModel]!
    
    /// Card
    enum CardState {
        case expanded
        case collapsed
    }
    
    var cardViewPresenter = CardViewPresenter()
    var cardViewInteractor = CardViewInteractor()
    var cardViewController: CardViewController!
    
    let blackView = UIView()
    let cardHandleAreaHeight: CGFloat = 140
    let cardHeight: CGFloat = 340
    
    var cardVisible = false
    
    var nextCardState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted: CGFloat = 0
    
    var selectedPinCoordinate = CLLocationCoordinate2D()
    var viewLauncherCard: UIView!
    var selectedMarket: [MarketModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBar()
        setMapButtons()
        
        checkLocationPermission()
        
        locationManager.delegate = self
        mapView.delegate = self
        
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
    
    
    /// Loads json information and transforms it on a MarketsModel array
    private func loadJSON() {
        
        do {
            if let bundlePath = Bundle.main.path(forResource: "feiras-sp", ofType: "json") {
                let data = try String(contentsOfFile: bundlePath).data(using: .utf8)
                let jsonData = try JSONDecoder().decode([MarketModel].self, from: data!)
                self.marketsArray = jsonData
            }
        } catch {
            print(error)
        }
    }
    
    
    /// Adds all markets loaded from json file to the mapview
    func addMarketsAnnotations() {
        
        loadJSON()
        
        for market in self.marketsArray {
            let annotation = MKPointAnnotation()
            annotation.title = market.street
            annotation.coordinate = CLLocationCoordinate2D(latitude: market.latitude, longitude: market.longitude)
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MarketAnnotationView()
        annotationView.image =  UIImage(named: "marketAnnotation")
        annotationView.canShowCallout = true
        return annotationView
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

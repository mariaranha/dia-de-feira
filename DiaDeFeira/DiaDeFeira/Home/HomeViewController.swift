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
    var marketsArray: [MarketModel]!
    
    /// Card
    enum CardState {
        case expanded
        case collapsed
    }
    
    var cardViewController: CardViewController!
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
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "marketPin")
        annotationView.image =  UIImage(named: "soccerball")
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
    
    // MARK: - Card
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if selectedPinCoordinate.latitude != view.annotation!.coordinate.latitude && selectedPinCoordinate.longitude != view.annotation!.coordinate.longitude &&
            cardViewController != nil {
            viewLauncherCard.removeFromSuperview()
        }
        
        if view.annotation?.coordinate != nil{
            self.selectedPinCoordinate = view.annotation!.coordinate
        } else {
            self.selectedPinCoordinate.latitude = selectedMarket[0].latitude
            self.selectedPinCoordinate.longitude = selectedMarket[0].longitude
        }
        
//        setUpCardInfo()
        
        //Center pin in the map
        let pinLatitude = selectedPinCoordinate.latitude
        let pinLongitude = selectedPinCoordinate.longitude
        let pinLocation = CLLocation(latitude: pinLatitude, longitude: pinLongitude)
        
        //function center on map location modified
        let coordinateRegion = MKCoordinateRegion(center: pinLocation.coordinate,
                                                  latitudinalMeters: 1500,
                                                  longitudinalMeters: 1500)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    func setupCard() {
        cardViewController = CardViewController(nibName: "CardViewController", bundle: nil)
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        
        cardViewController.view.frame = CGRect(x: 0,
                                               y: self.view.frame.height - cardHandleAreaHeight,
                                               width: self.view.bounds.width,
                                               height: cardHeight)
        
        cardViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(HomeViewController.handleCardPan(recognizer:)))
        
        cardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        cardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handleCardTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            animateTransitionIfNeeded(state: nextCardState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextCardState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: self.cardViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
        
    }
    
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                
                for animation in self.runningAnimations {
                    animation.pauseAnimation()
                    animation.stopAnimation(true)
                }
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.cardViewController.view.layer.cornerRadius = 12
                case .collapsed:
                    self.cardViewController.view.layer.cornerRadius = 0
                }
            }
            
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
        }
    }
    
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }

}

//
//  MarketCardViewController.swift
//  DiaDeFeira
//
//  Created by Julia Conti Mestre on 25/08/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol CloseCardDelegate: NSObjectProtocol {
    func handleDismiss(closeButtonTapped: Bool)
}

protocol RouteDelegate: NSObjectProtocol {
    func openInMaps()
}

protocol FavoriteDelegate: NSObjectProtocol {
    func getSelectedMarket() -> MarketModel
    func addOrRemoveFavorite(market: MarketModel)
}

extension HomeViewController: CloseCardDelegate, RouteDelegate, FavoriteDelegate {
    //Select Market
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
        
        setUpCardInfo()
        
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
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        handleDismiss(closeButtonTapped: false)
    }

    func openInMaps() {
        let regionDistance:CLLocationDistance = 1000
        
        let regionSpan = MKCoordinateRegion(center: self.selectedPinCoordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placeMark = MKPlacemark(coordinate: self.selectedPinCoordinate)
        let mapItem = MKMapItem(placemark: placeMark)
        
        for market in marketsArray {
            if market.latitude == self.selectedPinCoordinate.latitude &&
                market.longitude == self.selectedPinCoordinate.longitude{
                mapItem.name = "Feira \(market.neighborhood)"
            }
        }
        
        mapItem.openInMaps(launchOptions: options)
    }
    
    func getSelectedMarket() -> MarketModel {
        var selectedMarket: MarketModel!
        
        for market in marketsArray {
            if market.latitude == self.selectedPinCoordinate.latitude &&
                market.longitude == self.selectedPinCoordinate.longitude {
                selectedMarket = market
                break
            }
        }
        
        return selectedMarket
    }
    
    func addOrRemoveFavorite(market: MarketModel) {
        let decoded = UserDefaultsStruct.FavoriteMarkets.favorites
        var userFavorites: [MarketModel] = []
        var alreadyFavorite: Bool = false
        
         do {
            userFavorites = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! [MarketModel]
             
             
            for item in userFavorites {
                if item.latitude == selectedPinCoordinate.latitude &&
                    item.longitude == selectedPinCoordinate.longitude {
                    guard let index = userFavorites.firstIndex(of: item) else { return }
                    userFavorites.remove(at: index)
                    
                    alreadyFavorite = true
                }
            }
            
            if !alreadyFavorite {
                userFavorites.append(market)
            }
            
         } catch {
             print("Error decoding user defaults data")
         }
         
         do {
             let encodedData: Data = try NSKeyedArchiver.archivedData(withRootObject: userFavorites, requiringSecureCoding: false)
             
             UserDefaultsStruct.FavoriteMarkets.favorites = encodedData
         } catch {
             print("Error encoding user defaults data")
         }
    }
    
    func setUpCardInfo() {
        //creates an empty card
        showCard()
        
        let market = getSelectedMarket()
        let marketDistance = cardViewInteractor.haversineDinstance(la1: locationManager.location?.coordinate.latitude ?? 0,
                                                                   lo1: locationManager.location?.coordinate.longitude ?? 0,
                                                                   la2: market.latitude,
                                                                   lo2: market.longitude)
        
        let formatedCard = cardViewPresenter.formatCard(market: market,
                                                        distance: marketDistance)
        
        cardViewController.configureCard(cardModel: formatedCard)

    }
    
    func showCard() {
        
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            viewLauncherCard = setupCard()
            window.addSubview(viewLauncherCard)
        }
    }
    
    func setupCard() -> UIView {
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
        
        cardViewController.closeDelegate = self
        cardViewController.routeDelegate = self
        cardViewController.favoriteDelegate = self
        
        return cardViewController.view
    }
    
    @objc func handleDismiss(closeButtonTapped: Bool) {
        //Back to not expanded card if close button tapped
        if closeButtonTapped == true && viewLauncherCard != nil {
            cardViewController.view.frame = CGRect(x: 0,
                                                   y: self.view.frame.height - cardHandleAreaHeight,
                                                   width: self.view.bounds.width,
                                                   height: cardHeight)
        }
        
        if viewLauncherCard != nil {
            viewLauncherCard.removeFromSuperview()
        }
        
        //Remove selection from a pin
        let selectedPins = mapView.selectedAnnotations
        
        for pin in selectedPins {
            mapView.deselectAnnotation(pin, animated: true)
        }
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

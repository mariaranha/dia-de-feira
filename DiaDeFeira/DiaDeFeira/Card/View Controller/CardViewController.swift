//
//  CardViewController.swift
//  DiaDeFeira
//
//  Created by Julia Conti Mestre on 17/08/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    
    @IBOutlet weak var handleArea: UIView!
    
    @IBOutlet weak var marketName: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var weekDaysTitle: UILabel!
    @IBOutlet weak var weekDay: UILabel!
    @IBOutlet weak var addressTitle: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var neighborhood: UILabel!
    @IBOutlet weak var city: UILabel!
    
    @IBOutlet weak var routeButton: VerticalButton!
    @IBOutlet weak var favoriteButton: VerticalButton!
    
    weak var closeDelegate: CloseCardDelegate?
    weak var routeDelegate: RouteDelegate?
    weak var favoriteDelegate: FavoriteDelegate?
    
    let interactor = CardViewInteractor()
    let homeViewController = HomeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup static labels
        weekDaysTitle.text = "Dias da semana"
        addressTitle.text = "Endereço"
        routeButton.setTitle("Rota", for: .normal)
        routeButton.tintColor = AppColors.green
        favoriteButton.tintColor = AppColors.green
    }
    
    func configureCard(cardModel: CardViewPresenter.CardViewModel) {
        marketName.text = cardModel.marketTitle
        distance.text = cardModel.distance
        weekDay.text = cardModel.weekdays
        street.text = cardModel.street
        neighborhood.text = cardModel.neighborhood
        city.text = cardModel.city
    }
    
    func configureFavoriteButton(buttonModel: CardViewPresenter.FavoriteButtonModel) {
        favoriteButton.setTitle(buttonModel.label, for: .normal)
        favoriteButton.tintColor = buttonModel.color
        favoriteButton.setTitleColor(buttonModel.color, for: .normal)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.closeDelegate?.handleDismiss(closeButtonTapped: true)
    }
    
    @IBAction func routeButtonTapped(_ sender: UIButton) {
        self.routeDelegate?.openInMaps()
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        let selectedMarket = (self.favoriteDelegate?.getSelectedMarket())!
        self.favoriteDelegate?.addOrRemoveFavorite(market: selectedMarket)
    }

}

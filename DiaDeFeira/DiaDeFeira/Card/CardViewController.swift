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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup static labels
        weekDaysTitle.text = "Dias da semana"
        addressTitle.text = "Endereço"
        routeButton.titleLabel?.text = "Rota"
    }

}

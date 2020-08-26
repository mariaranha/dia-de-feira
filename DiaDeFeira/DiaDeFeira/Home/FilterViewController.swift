//
//  FilterViewController.swift
//  DiaDeFeira
//
//  Created by Matheus Oliveira on 25/08/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    var selectedDistance: Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func sliderValue(_ sender: UISlider) {
        
        let currentValue = Int(sender.value)
        self.selectedDistance = currentValue
        distanceLabel.text = "\(currentValue) km"
    }
    
    
    @IBAction func filterButton(_ sender: Any) {
        performSegue(withIdentifier: "filterToHome", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filterToHome" {
                if let newVC = segue.destination as? HomeViewController {
                    newVC.selectedFilteredDistance = self.selectedDistance
                    newVC.isDistanceFilterAplied = true
                }
        }
    }

}

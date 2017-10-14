//
//  WeatherViewController.swift
//  WeatherAppRx
//
//  Created by Magfurul Abeer on 10/13/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    let locationTextField:  UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.clear
        tf.textColor = UIColor.white
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        return tf
    }()

    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = UIViewContentMode.scaleAspectFit
        return iv
    }()
    
    let temperatureLabel: UILabel = {
        let tl = UILabel()
        tl.text = "N/A"
        tl.textColor = UIColor.white
        tl.font = UIFont(name: "AvenirNext-UltraLight", size: 80)
        return tl
    }()
    
    let descriptionLabel: UILabel = {
        let tl = UILabel()
        tl.text = "N/A"
        tl.textColor = UIColor.white
        tl.font = UIFont(name: "Avenir-Book", size: 17)
        return tl
    }()
    
    let humidityTitleLabel: UILabel = {
        let tl = UILabel()
        tl.text = "Humidity"
        tl.textColor = UIColor.white
        tl.font = UIFont(name: "Avenir-Book", size: 20)
        return tl
    }()
    
    let pressureTitleLabel: UILabel = {
        let tl = UILabel()
        tl.text = "Pressure"
        tl.textColor = UIColor.white
        tl.font = UIFont(name: "Avenir-Book", size: 20)
        return tl
    }()
    
    let humidityLabel: UILabel = {
        let tl = UILabel()
        tl.text = "n/a"
        tl.textColor = UIColor.white
        tl.font = UIFont(name: "Avenir-Book", size: 20)
        return tl
    }()
    
    let pressureLabel: UILabel = {
        let tl = UILabel()
        tl.text = "n/a"
        tl.textColor = UIColor.white
        tl.font = UIFont(name: "Avenir-Book", size: 20)
        return tl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WeatherLayoutManager.layout(vc: self)
        
        
        
        
        

        // Do any additional setup after loading the view.
    }

    

}

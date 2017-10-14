//
//  WeatherViewController.swift
//  WeatherAppRx
//
//  Created by Magfurul Abeer on 10/13/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class WeatherViewController: UIViewController {

    let disposeBag = DisposeBag()
    var viewModel = WeatherViewModel()
    
    let locationTextField:  UITextField = {
        let tf = UITextField()
        tf.text = ""
        tf.backgroundColor = UIColor.clear
        tf.textColor = UIColor.white
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        tf.textAlignment = NSTextAlignment.center
        return tf
    }()

    let iconImageView: CachedImageView = {
        let iv = CachedImageView()
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
        bindViewModel()
    }

    func bindViewModel() {
        locationTextField.rx.text.asDriver()
            .throttle(3)
            .drive(viewModel.query)
            .addDisposableTo(disposeBag)
        
        viewModel.temperature.asDriver(onErrorJustReturn: "ERROR")
            .drive(temperatureLabel.rx.text.asObserver())
            .addDisposableTo(disposeBag)
        
        viewModel.humidity.asDriver(onErrorJustReturn: "n/a")
            .drive(humidityLabel.rx.text.asObserver())
            .addDisposableTo(disposeBag)
        
        viewModel.pressure.asDriver(onErrorJustReturn: "n/a")
            .drive(pressureLabel.rx.text.asObserver())
            .addDisposableTo(disposeBag)
        
        viewModel.descriptionText.asDriver(onErrorJustReturn: "")
            .drive(descriptionLabel.rx.text.asObserver())
            .addDisposableTo(disposeBag)
        
        viewModel.iconUrl
            .subscribe(onNext: { [weak self] url in
                guard let strongSelf = self else { return }
                
                guard let url = url else {
                    strongSelf.iconImageView.image = UIImage()
                    return
                }
                
                strongSelf.iconImageView.setImage(url: url)
            })
            .addDisposableTo(disposeBag)
        
    }
}

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
        locationTextField.text = UserDefaults.standard.string(forKey: Constants.lastSearchedKey)
    }

    func bindViewModel() {
        locationTextField.rx.controlEvent(UIControlEvents.editingDidEndOnExit).asDriver()
            .drive(viewModel.didPressDone)
            .addDisposableTo(disposeBag)
        
        locationTextField.rx.text.asDriver()
            .throttle(3)
            .drive(viewModel.query)
            .addDisposableTo(disposeBag)
        
        // FIXME: When changing text, it changes it to what was there before the editing
        // As with most of this project, I would put more focus on this if given the time
        viewModel.name.asDriver(onErrorJustReturn: nil)
            .drive(locationTextField.rx.text.asObserver())
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
                    // I had an interesting issue where setting the image to nil did not change what was displayed
                    // Assuming I had more time, I probably would have tried to fix this though it would be low priority
                    strongSelf.iconImageView.isHidden = true
                    return
                }
                
                strongSelf.iconImageView.setImage(url: url)
            })
            .addDisposableTo(disposeBag)
        
    }
}

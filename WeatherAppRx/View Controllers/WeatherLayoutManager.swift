//
//  WeatherLayoutManager.swift
//  WeatherAppRx
//
//  Created by Magfurul Abeer on 10/14/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

// Note: For sake of ease and quick coding, I'm using plenty of constants to constrain the views.
// Given time and some consulting from a designer, it would be preferred to use more multipliers instead
// as now with the release of iPhone X, there is a larger variety of sizes to account for
class WeatherLayoutManager {

    public class func layout(vc: WeatherViewController) {
        let layout = WeatherLayoutManager()
        layout.vc = vc
        layout.configureTemperatureLabel()
        layout.configureLocationTextField()
        layout.configureIconImageView()
        layout.configureDescriptionLabel()
        layout.configureHumidityTitle()
        layout.configurePressureTitle()
        layout.configureHumidityLabel()
        layout.configurePressureLabel()
    }
    
    private var vc: WeatherViewController!
    
    // In a personal project, I would use the Sourcery cocoapod to generate computed properties that would
    // allow for calling view controller properties as its own. For e.g.
    // var temperature label: UIView { return self.vc.temperatureLabel }
    // This way the configurations can be first done in the VC and then easily moved to a layout manager
    private var view: UIView {
        return self.vc.view
    }
    
    private func configureTemperatureLabel() {
        view.addSubview(vc.temperatureLabel)
        vc.temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        vc.temperatureLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        vc.temperatureLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    private func configureLocationTextField() {
        view.addSubview(vc.locationTextField)
        vc.locationTextField.translatesAutoresizingMaskIntoConstraints = false
        vc.locationTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        vc.locationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        vc.locationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        vc.locationTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureIconImageView() {
        view.addSubview(vc.iconImageView)
        vc.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        vc.iconImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        vc.iconImageView.widthAnchor.constraint(equalTo: vc.iconImageView.heightAnchor).isActive = true
        vc.iconImageView.topAnchor.constraint(equalTo: vc.locationTextField.bottomAnchor, constant: 60).isActive = true
        vc.iconImageView.bottomAnchor.constraint(equalTo: vc.temperatureLabel.topAnchor, constant: -60).isActive = true
    }
    
    private func configureDescriptionLabel() {
        view.addSubview(vc.descriptionLabel)
        vc.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        vc.descriptionLabel.topAnchor.constraint(equalTo: vc.iconImageView.bottomAnchor, constant: 8).isActive = true
        vc.descriptionLabel.centerXAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    private func configureHumidityTitle() {
        view.addSubview(vc.humidityTitleLabel)
        vc.humidityTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        vc.humidityTitleLabel.trailingAnchor.constraint(equalTo: vc.view.centerXAnchor, constant: -5).isActive = true
        vc.humidityTitleLabel.topAnchor.constraint(equalTo: vc.temperatureLabel.bottomAnchor, constant: 15).isActive = true
    }
    
    private func configurePressureTitle() {
        view.addSubview(vc.pressureTitleLabel)
        vc.pressureTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        vc.pressureTitleLabel.trailingAnchor.constraint(equalTo: vc.humidityTitleLabel.trailingAnchor).isActive = true
        vc.pressureTitleLabel.topAnchor.constraint(equalTo: vc.humidityTitleLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func configureHumidityLabel() {
        view.addSubview(vc.humidityLabel)
        vc.humidityLabel.translatesAutoresizingMaskIntoConstraints = false
        vc.humidityLabel.leadingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.centerXAnchor, constant: 5).isActive = true
        vc.humidityLabel.centerYAnchor.constraint(equalTo: vc.humidityTitleLabel.centerYAnchor).isActive = true
    }
    
    private func configurePressureLabel() {
        view.addSubview(vc.pressureLabel)
        vc.pressureLabel.translatesAutoresizingMaskIntoConstraints = false
        vc.pressureLabel.leadingAnchor.constraint(equalTo: vc.humidityLabel.leadingAnchor).isActive = true
        vc.pressureLabel.centerYAnchor.constraint(equalTo: vc.pressureTitleLabel.centerYAnchor).isActive = true
    }
}

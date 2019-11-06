//
//  ViewController.swift
//  moonphase
//
//  Created by Rex Peng on 2019/11/6.
//  Copyright © 2019 Rex Peng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var moonView: MoonPhase!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupMonPhaseView()
        setupDatePicker()
    }

    func setupMonPhaseView() {
        moonView = MoonPhase(frame: .zero)
        moonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(moonView)
        
        moonView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        moonView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        moonView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: 0).isActive = true
        moonView.widthAnchor.constraint(equalTo: moonView.heightAnchor).isActive = true
    }
    
    func setupDatePicker() {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(picker)
        picker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        picker.heightAnchor.constraint(equalToConstant: 200).isActive = true
        picker.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        moonView.date = sender.date
    }
}


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
    var picker: UIDatePicker!
    var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupMonPhaseView()
        setupDatePicker()
        setupTimer()
    }

    func setupMonPhaseView() {
        moonView = MoonPhase(frame: .zero)
        moonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(moonView)
        
        moonView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        moonView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        moonView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25, constant: 0).isActive = true
        moonView.widthAnchor.constraint(equalTo: moonView.heightAnchor).isActive = true
        
        moonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleTimer)))
    }
    
    func setupDatePicker() {
        picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
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
    
    func setupTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            let date = self.picker.date
            self.moonView.date = date
            self.picker.date = date.addingTimeInterval(86400)
        })
    }
    
    @objc func toggleTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        } else {
            setupTimer()
        }
    }
}


//
//  OwnerInsureViewController.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 4..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit
import MapKit

class OwnerInsureViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
    var delegate: SearchAlertDelegate? = nil

    var withCount = 0
    var time = Date()
    var message = ""
    
    var firstPin: MKPlacemark? = nil
    var secondPin: MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func skip(_ sender: UIButton) {
        mainView.isHidden = true
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH : mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let tiemString = formatter.string(from: time)
        
        Network().postOwnerMatching(time: tiemString, firstPin: firstPin!, secondPin: secondPin!, with: withCount, message: message) { (result, data) in
            if let data = data {
                if data.status {
                    UserDefaults.standard.set(data.result!.matching_idx, forKey: "matching_idx")
                    self.dismiss(animated: true, completion: {
                    self.delegate?.onFinishRegister()
                    })
                }
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    @IBAction func next(_ sender: UIButton) {
        
    }
}

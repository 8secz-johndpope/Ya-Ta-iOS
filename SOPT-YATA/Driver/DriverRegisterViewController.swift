//
//  DriverRegisterViewController.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 5..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DriverRegisterViewController: UIViewController {

    @IBOutlet weak var messageView: UITextView!
    @IBOutlet weak var withLabel: UILabel!
    
    
    let withCount = Variable(1)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        withCount.asObservable().map {
            return "\($0)명"
            }.bind(to: withLabel.rx.text)
            .addDisposableTo(disposeBag)
    }

    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeCount(_ sender: UIButton) {
        if sender.tag == 0 {
            withCount.value = withCount.value + 1
        } else {
            if withCount.value > 1 {
                withCount.value = withCount.value - 1
            }
        }
    }
    
    @IBAction func register(_ sender: UIButton) {
        self.dismiss(animated: true) { 
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismiss(animated: true, completion: nil)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.alpha = 0.0
    }
    

}

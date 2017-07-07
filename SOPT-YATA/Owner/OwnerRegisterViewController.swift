//
//  OwnerRegisterViewController.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 4..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class OwnerRegisterViewController: UIViewController {
    
    @IBOutlet weak var messageView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var withLabel: UILabel!

    var delegate: SearchAlertDelegate? = nil
    
    let withCount = Variable(1)
    let time = Variable(Date())
    let disposeBag = DisposeBag()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        withCount.asObservable().map {
            return "\($0)명"
            }.bind(to: withLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        
        time.asObservable().map {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH : mm a"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            return "\(formatter.string(from: $0))"
            }.bind(to: timeLabel.rx.text)
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
    
    
    @IBAction func changeDate(_ sender: UIButton) {
        if sender.tag == 0 {
            time.value = time.value.addingTimeInterval(300)
        } else {
            if time.value > Date() {
                time.value = time.value.addingTimeInterval(-300)
            }
        }
    }
    
    @IBAction func next(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.nextPresent(time: self.time.value, withCount: self.withCount.value, message: self.messageView.text)
        }
    }
}

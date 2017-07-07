//
//  MainLoginViewController.swift
//  SOPT-YATA
//
//  Created by 안가현 on 2017. 7. 1..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit

class MainLoginViewController: UIViewController {
    
    private var myArray = [#imageLiteral(resourceName: "mainpage_01"), #imageLiteral(resourceName: "mainpage_02"),#imageLiteral(resourceName: "mainpage_03"), #imageLiteral(resourceName: "mainpage_04")]
    private var index = 0
    
    @IBOutlet var viewPager: UIImageView!
    @IBOutlet var viewIndicator: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewPager.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let bar:UINavigationBar! =  self.navigationController?.navigationBar
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }
    
    
    @IBAction func swipeDetected(_ sender: UISwipeGestureRecognizer) {
        let updateIndex = sender.direction == .left ? 1 : -1
        index += updateIndex
        
        if index >= myArray.count {
            // Went past the array bounds. start over
            index = 0
        } else if index < 0 {
            // Jump to the back of the array
            index = myArray.count - 1
        }
        
        let picture = myArray[index]
        self.viewPager.image = picture
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "join":
            let navigation = segue.destination as! UINavigationController
            let viewcontroller = navigation.viewControllers.first! as! JoinViewController
            viewcontroller.delegate = self
        case "login":
            let navigation = segue.destination as! UINavigationController
            let viewcontroller = navigation.viewControllers.first! as! LoginViewController
            viewcontroller.delegate = self
        default:
            break
        }
    }
}

extension MainLoginViewController: PresentDelegate {
    func presentJoin() {
        self.performSegue(withIdentifier: "join", sender: self)
    }
    
    func presentLogin() {
        self.performSegue(withIdentifier: "login", sender: self)
    }
}

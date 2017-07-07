//
//  DriverListViewController.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 2..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit

class DriverListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInit()
    }
    
    private func setInit() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DriverListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "owner", for: indexPath)
        return cell
    }
}

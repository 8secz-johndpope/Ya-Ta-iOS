//
//  OwnerSearchDetailViewController.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 3..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit
import MapKit

class OwnerSearchDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var resultSearchController: UISearchController!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()

    var handleMapSearchDelegate: HandleMapSearch? = nil
    var type = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInit()
    }
    
    private func setInit() {
        tableView.delegate = self
        tableView.dataSource = self
        searchCompleter.delegate = self

        resultSearchController = UISearchController(searchResultsController: nil)
        
        resultSearchController.searchBar.tintColor = UIColor.black
        
        resultSearchController.searchResultsUpdater = self
        resultSearchController.searchBar.delegate = self
        resultSearchController.hidesNavigationBarDuringPresentation = false
        
        resultSearchController.dimsBackgroundDuringPresentation = false
        
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
        
        definesPresentationContext = true
        resultSearchController.searchBar.sizeToFit()
        
        self.navigationItem.titleView = resultSearchController.searchBar
    }
}

extension OwnerSearchDetailViewController : UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        searchCompleter.queryFragment = searchController.searchBar.text!
    }
}

extension OwnerSearchDetailViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {

        searchResults = completer.results
        print("\(searchResults.count)")
        self.tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension OwnerSearchDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "search", for: indexPath)
        let selectedItem = searchResults[indexPath.row]
        cell.textLabel?.text = "This"
        cell.textLabel?.attributedText = highlightedText(selectedItem.title, inRanges: selectedItem.titleHighlightRanges, size: 17.0)
        cell.detailTextLabel?.attributedText = highlightedText(selectedItem.subtitle, inRanges: selectedItem.subtitleHighlightRanges, size: 12.0)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let placemark = response?.mapItems[0].placemark
            print(String(describing: placemark))
            self.handleMapSearchDelegate?.dropPinZoomIn(placemark: placemark!, type: self.type, title: completion.title)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     Highlights the matching search strings with the results
     - parameter text: The text to highlight
     - parameter ranges: The ranges where the text should be highlighted
     - parameter size: The size the text should be set at
     - returns: A highlighted attributed string with the ranges highlighted
     */
    func highlightedText(_ text: String, inRanges ranges: [NSValue], size: CGFloat) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: text)
        let regular = UIFont.systemFont(ofSize: size)
        attributedText.addAttribute(NSFontAttributeName, value:regular, range:NSMakeRange(0, text.characters.count))
        
        let bold = UIFont.boldSystemFont(ofSize: size)
        for value in ranges {
            attributedText.addAttribute(NSFontAttributeName, value:bold, range:value.rangeValue)
        }
        return attributedText
    }
}

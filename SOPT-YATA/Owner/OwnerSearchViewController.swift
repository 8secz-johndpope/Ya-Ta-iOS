//
//  OwnerSearchViewController.swift
//  sopt-yata
//
//  Created by Chang Woo Son on 2017. 7. 1..
//  Copyright © 2017년 YATA. All rights reserved.
//

import UIKit
import MapKit
import RxCocoa
import RxSwift

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark, type: Int, title: String)
}

protocol SearchAlertDelegate {
    func nextPresent(time: Date, withCount: Int, message: String)
    func onFinishRegister()
}

class OwnerSearchViewController: UIViewController {
    
    var selectedPin: MKPlacemark? = nil
    var continueLocationUpdate = false

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    var firstPin: MKPlacemark? = nil
    var secondPin: MKPlacemark? = nil

    
    var startString = Variable("")
    var endString = Variable("")
    let disposeBag = DisposeBag()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(toSearchView(_:)))
        startLabel.isUserInteractionEnabled = true
        startLabel.addGestureRecognizer(gesture1)
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(toSearchView(_:)))
        endLabel.isUserInteractionEnabled = true
        endLabel.addGestureRecognizer(gesture2)

        addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userDefaults = UserDefaults.standard
        self.confirmButton.isHidden = userDefaults.bool(forKey: "registerOwner")
    }
    
    func addObserver() {
        startString.asObservable().map {
            if $0.isEmpty {
                self.startLabel.textColor = UIColor(red: 190.0 / 255.0, green: 190.0 / 255.0, blue: 190.0 / 255.0, alpha: 1.0)
                return "출발지 입력"
            }
            self.startLabel.textColor = .black
            return $0
            }.bind(to: self.startLabel.rx.text)
            .addDisposableTo(self.disposeBag)

        
        endString.asObservable().map {
            if $0.isEmpty {
                self.endLabel.textColor = UIColor(red: 190.0 / 255.0, green: 190.0 / 255.0, blue: 190.0 / 255.0, alpha: 1.0)
                return "도착지 입력"
            }
            self.endLabel.textColor = .black
            return $0
            }.bind(to: self.endLabel.rx.text)
            .addDisposableTo(self.disposeBag)
        
        Observable.combineLatest(startString.asObservable(), endString.asObservable()) { !$0.isEmpty && !$1.isEmpty }
            .subscribe(onNext: {
                self.confirmButton.isEnabled = $0
            }).disposed(by: disposeBag)
    }
    
    func toSearchView(_ sender: UITapGestureRecognizer) {
        let tag = sender.view?.tag
        
        self.performSegue(withIdentifier: "toSearch", sender: tag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "toSearch":
            let destination = segue.destination as! OwnerSearchDetailViewController
            destination.handleMapSearchDelegate = self
            destination.type = sender as! Int
        default:
            break
        }
    }


    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
    @IBAction func switchAction(_ sender: UIButton) {
        let start = startString.value
        let end = endString.value
        startString.value = end
        endString.value = start
    }
    
    @IBAction func presentCustomAlert(_ sender: UIButton) {
        let viewController = OwnerRegisterViewController(nibName: "OwnerRegisterViewController", bundle: nil)
        viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        self.tabBarController?.present(viewController, animated: true, completion: nil)
    }
}

extension OwnerSearchViewController: HandleMapSearch, SearchAlertDelegate {
    func dropPinZoomIn(placemark: MKPlacemark, type: Int, title: String){
        // cache the pin
        selectedPin = placemark
        if type == 0 {
            firstPin = placemark
        } else {
            secondPin = placemark
        }
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        
        if type == 0 {
            startString.value = title
        } else {
            endString.value = title
        }
    }
    
    func nextPresent(time: Date, withCount: Int, message: String) {
        let viewController = OwnerInsureViewController(nibName: "OwnerInsureViewController", bundle: nil)
        viewController.delegate = self
        viewController.time = time
        viewController.withCount = withCount
        viewController.message = message
        viewController.firstPin = firstPin
        viewController.secondPin = secondPin
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        self.tabBarController?.present(viewController, animated: true, completion: nil)
    }
    
    func onFinishRegister() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "registerOwner")
        self.confirmButton.isHidden = true
        self.tabBarController?.selectedIndex = 1
    }
}


extension OwnerSearchViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        if !continueLocationUpdate {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(#imageLiteral(resourceName: "kakaotalk"), for: .normal)
        button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}

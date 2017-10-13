//
//  ViewController.swift
//  HelloIndoor
//
//  Created by Shobha V J on 2017-10-04.
//  Copyright © 2017 Shobha V J. All rights reserved.
//

import UIKit


class ViewController: UIViewController , EILIndoorLocationManagerDelegate{
    
    var location : EILLocation!
    let locationManager = EILIndoorLocationManager()
    
    @IBOutlet var locationView: EILIndoorLocationView!
    @IBOutlet weak var positionView: UIView!
    @IBOutlet weak var positionImage: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.locationManager.delegate = self
        
        ESTConfig.setupAppID("three-point-turn--inc--s-h-90g", andAppToken: "fcc81c41de8e8cf03ce26aedba01c884")

        let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "small-location")
        fetchLocationRequest.sendRequest { (location, error) in
            
            if  location != nil {
                self.location = location!
                self.locationView.showTrace = true
                self.locationView.rotateOnPositionUpdate = false
                self.locationView.drawLocation(location!)
                self.locationView.locationBorderColor = UIColor.red
                self.locationView.locationBorderThickness = 2
                self.locationView.traceColor = UIColor.yellow
                self.locationView.traceThickness = 2
                self.locationView.doorColor = UIColor.green
                self.locationView.doorThickness = 2
                self.locationManager.startPositionUpdates(for: self.location)
                
                
            } else {
                print("can't fetch location: \(String(describing: error))")
            }
        }
        
    }
    
    private func indoorLocationManager(manager: EILIndoorLocationManager!,
                                       didFailToUpdatePositionWithError error: NSError!) {
        print("failed to update position: \(error)")
    }
    
    func indoorLocationManager(_ manager: EILIndoorLocationManager,
                               didUpdatePosition position: EILOrientedPoint,
                               with positionAccuracy: EILPositionAccuracy,
                               in location: EILLocation) {
        
        var accuracy: String!
        switch positionAccuracy {
        case .veryHigh: accuracy = "+/- 1.00m"
        case .high:     accuracy = "+/- 1.62m"
        case .medium:   accuracy = "+/- 2.62m"
        case .low:      accuracy = "+/- 4.24m"
        case .veryLow:  accuracy = "+/- ? :-("
        case .unknown:  accuracy = "unknown"
        }
        
        print(String(format: "x: %5.2f, y: %5.2f, orientation: %3.0f, accuracy: %@",
                     position.x, position.y, position.orientation, accuracy))
        self.locationView.updatePosition(position)
    }
    
    
    
    
}



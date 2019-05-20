//
//  MapStuff.swift
//  MarketPlaceMedium
//
//  Created by Christian Burke on 2/21/19.
//  Copyright © 2019 Christian Burke. All rights reserved.
//

import Foundation
import MapKit


class MapCircle:MKCircle{
    var outlineColor:UIColor
    var fillColor:UIColor
    var circle:MKCircle
    
    init(_location:CLLocation, _radius:Double, _outline:UIColor, _fill:UIColor){
        self.outlineColor = _outline
        self.fillColor = _fill
        self.circle = MKCircle(center: _location.coordinate, radius: _radius as CLLocationDistance)
    }
}

extension MKMapView{
    func addRadiusCircle(_location: CLLocation, _radius:Double, _outline:UIColor = .cyan, _fill:UIColor = .blue){
        let circle = MapCircle(_location: _location, _radius: _radius, _outline: .blue, _fill: .cyan)
        self.addOverlay(circle)
    }
}

class BurkesLocator{
    //REQUIREMENT: You must update the PLIST file to ask the user for location permissions
    
    var locManager = CLLocationManager()

    func getCurrentLocation()->CLLocation?{
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            if let appleLocation = locManager.location{
                return appleLocation
            }
        }else{
            print("user has not authorized location management")
            locManager.requestWhenInUseAuthorization()
            sleep(1)
            return getCurrentLocation()
        }
        return nil
    }
    
    func locationToZip(location:CLLocation, zipCode: @escaping (String)->()){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            // City
            if let city = placeMark.subAdministrativeArea {
                print(city)
            }
            // Zip code
            if let zip = placeMark.postalCode {
                print(zip)
                zipCode(zip)
            }
            // Country
            if let country = placeMark.country {
                print(country)
            }
        })
    }
}

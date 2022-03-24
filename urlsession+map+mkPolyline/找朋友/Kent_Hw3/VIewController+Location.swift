import CoreLocation
import Foundation
import MapKit

extension findMyFriendVC :  CLLocationManagerDelegate {
    
    func friensLocarion(lat:Double,lon:Double,friendName:String){
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        objectAnnotation.title = friendName
        objectAnnotation.subtitle = "123"
        mainMapView.addAnnotation(objectAnnotation)
        print(lat,lon)
    }
    
    func locationManager(_ manager : CLLocationManager,didUpdateLocations locations:[CLLocation]){
        
        guard let location = locations.last else{
            assertionFailure("Invalid locations.")
            return
        }
        let coordinate = location.coordinate
        print("Lat: \(coordinate.latitude),Lon:\(coordinate.longitude)")

        //Move and Zoom the map
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mainMapView.setRegion(region, animated: true)
    }
    
}

extension findMyFriendVC : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let regin = mapView.region
        let center = regin.center
        print("Region Updated: \(center.latitude), \(center.longitude)")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil //傳回初始值（維持藍色點）
        }
        let storeID = "store"
        var result = mapView.dequeueReusableAnnotationView(withIdentifier: storeID)
        if result == nil {
            result = MKAnnotationView(annotation: annotation, reuseIdentifier: storeID)

        }else{
            result?.annotation = annotation
        }
        result?.canShowCallout = true
        
        let image = UIImage(named: "pointRed.png")
        result?.image = image
        
        //Left callout accessory view
        result?.leftCalloutAccessoryView = UIImageView(image:image)
        
        //right callout accessory view
        let button = UIButton(type: .detailDisclosure)
        button.addTarget(self, action: #selector(infoBtnPressed(sender: )),for:.touchUpInside)
        result?.rightCalloutAccessoryView = button
        
        return result
    }
    
    
    @objc func infoBtnPressed(sender: UIButton){
        let alert = UIAlertController(title: "123", message: "導航前往", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func navigateTo(lat:Double,lon:Double,lat2:Double,lon2:Double){
        let sourceLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let destinationLocation = CLLocationCoordinate2D(latitude: lat2, longitude: lon2)
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        let directions = MKDirections(request: directionRequest)
        
    }
    
    
}


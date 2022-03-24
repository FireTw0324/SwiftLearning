//
//  findMyFriendVC.swift
//  Kent_Hw3
//
//  Created by student on 2022/1/17.
//
import UIKit
import CoreLocation
import MapKit

class findMyFriendVC: UIViewController {
    let locationManager = CLLocationManager()
    var geodesicPolyline:MKGeodesicPolyline?
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() == false{
        }

        locationManager.requestAlwaysAuthorization()

        //Start updating location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
        locationManager.delegate = self
        locationManager.startUpdatingLocation()

//        locationManager.allowsBackgroundLocationUpdates  = true
//        locationManager.pausesLocationUpdatesAutomatically   = false
        mainMapView.delegate = self
        mainMapView.showsUserLocation = true
        
        
    }
    @IBAction func uploadLocation(_ sender: Any) {
        let Lat = locationManager.location?.coordinate.latitude
        let Lon = locationManager.location?.coordinate.longitude
        print(Lat!,Lon!)
        let urlStr = "https://class.softarts.cc/FindMyFriends/updateUserLocation.php?GroupName=MAPD36&UserName=17&Lat=\(Lat!)&Lon=\(Lon!)"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response , error in
                if let data = data {
                    do {
                        print("success")
                    } catch  {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    @IBOutlet weak var mainMapView: MKMapView!
    
    
    @IBAction func get(_ sender: Any) {
        let urlStr = "https://class.softarts.cc/FindMyFriends/queryFriendLocations.php?GroupName=MAPD36"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response , error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let friendsData = try decoder.decode(Post.self, from: data)
                        let startLat = self.locationManager.location?.coordinate.latitude
                        let startLon = self.locationManager.location?.coordinate.longitude
                        self.mainMapView.removeOverlays(self.mainMapView.overlays)
                        for i in 0...friendsData.friends.count-1{
                            if friendsData.friends[i].friendName == "17"{
                                continue
                            }else{
                            print(friendsData.friends[i].id)
                            let lat = Double("\(friendsData.friends[i].lat)")!
                            let lon = Double("\(friendsData.friends[i].lon)")!
                            let friendName = friendsData.friends[i].friendName
                            self.friensLocarion(lat: lat, lon: lon, friendName: friendName)
                            
                            DispatchQueue.main.async {
                                // Update UI
                                self.paintLine(startLat: startLat!, startLon: startLon!, endLat: lat, endLon: lon)
                            }
                            }
                        }
                    } catch  {
                        print(error)
                    }
                }
            }.resume()
        }
    }

    func paintLine(startLat:Double,startLon:Double,endLat:Double,endLon:Double) {
        let start = CLLocationCoordinate2D(latitude: startLat, longitude: startLon)
        let end  = CLLocationCoordinate2D(latitude: endLat, longitude: endLon)
        let coords = [start,end]
        geodesicPolyline = MKGeodesicPolyline(coordinates: coords, count: 2)
        
        mainMapView.addOverlay(geodesicPolyline!)
        
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let PolyLine = overlay as? MKPolyline else{
            return MKOverlayRenderer()
        }
        let rander = MKPolylineRenderer(polyline: PolyLine)
        rander.lineWidth = 3.0
        rander.alpha = 0.5
        rander.strokeColor = UIColor.blue
        return rander
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ViewController.swift
//  FIND MY WAY
//
//  Created by Simran Chakkal on 2020-01-14.
//  Copyright © 2020 Simran Chakkal. All rights reserved.
//

import UIKit
import MapKit

//class custompin: NSObject,MKAnnotation {
//    var coordinate:CLLocationCoordinate2D
//    var title:String?
//    var subtitle: String?
//
//     init(pintitle:String,pinsubtitle:String,location
//        :CLLocationCoordinate2D) {
//        self.title = pintitle
//        self.subtitle = pinsubtitle
//        self.coordinate = location
//
//    }
//
//}

class ViewController: UIViewController,CLLocationManagerDelegate  {
    var locationmanager = CLLocationManager()
    var zoomingIn = false
    
    
    
    @IBOutlet var mapview: MKMapView!
    
    
    @IBOutlet var zoomoutbutton: UIButton!
    
    
    @IBOutlet var segmentcontroller: UISegmentedControl!
    
   // var transportType = MKDirectionsTransportType()
    var places = [Place]()

    
    @IBOutlet var buttonfindmyway: UIButton!
    var tappingnumbers = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       mapview.showsUserLocation = true
        mapview.delegate = self
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.delegate = self
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest

       // addpolyline()
//        let pin  = custompin(pintitle: "", pinsubtitle: "", location: CLLocationCoordinate2DMake(43.64, -79.38))
//        self.mapview.addAnnotation(pin)
        let tapping = UITapGestureRecognizer(target: self, action: #selector(tappinggesture))
        tapping.numberOfTapsRequired = 2
               mapview.addGestureRecognizer(tapping)
       
        // Do any additional setup after loading the view.
    }
   
    
//    func addpolyline(){
//    let locations = places.map{$0.coordinate}
//
//    let polyline = MKPolyline(coordinates: locations, count: locations.count)
//        mapview.addOverlay(polyline)
//
//    }
    
    
    
    
    func getdirection(destination:CLLocationCoordinate2D){
    let destinationcoordinate = MKDirections.Request()
    
    let sourcecoordinate = mapview.userLocation.coordinate
    
    let source = CLLocationCoordinate2DMake(sourcecoordinate.latitude, sourcecoordinate.longitude)
    let destination = CLLocationCoordinate2DMake(destination.latitude, destination.longitude)
    
    print(source)
    print(destination)
    
    let sourceplacemark = MKPlacemark(coordinate: source)
    let destinationplacemark = MKPlacemark(coordinate: destination)
    
    
    let finalsource = MKMapItem(placemark: sourceplacemark)
    let finaldestination = MKMapItem(placemark: destinationplacemark)
    destinationcoordinate.source = finalsource
    destinationcoordinate.destination =  finaldestination
    
        switch segmentcontroller.selectedSegmentIndex {
        case 0 :
            destinationcoordinate.transportType = .automobile
print("automobile")
        case 1 :
            destinationcoordinate.transportType = .walking
            

print("walking")
        case 2:
                destinationcoordinate.transportType = .transit
                
            print("transit")
        default:
            break
            
        }
   // destinationcoordinate.transportType = .automobile
    
    let direction = MKDirections(request: destinationcoordinate)
    direction.calculate{(response, error) in
        guard let response = response else{
            if let error = error{
                print(error)
            }
            return
        }
        let route = response.routes[0]
        self.mapview.addOverlay(route.polyline,level:.aboveRoads)
        self.mapview.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
    @objc func longpress(gesture:UIGestureRecognizer){
        let zoomout = gesture.location(in: mapview)
        let coordinate = mapview.convert(zoomout, toCoordinateFrom: mapview)
        
    
    }
    
    
    @IBAction func zoomout(_ sender: Any) {
//        func zoomInOnPin(annotation:MKAnnotation) {
//            var  zoomingAnnotation : MKAnnotation
//            let zoomOutRegion = MKCoordinateRegion(center: mapview.region.center, span: MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09))
//            zoomingIn = true
//        zoomingAnnotation = annotation
//
//
//            mapview.setRegion(zoomOutRegion, animated: true)
//
//        }
        
        
//        let latitude:CLLocationDegrees = 43.64
//        let longitute:CLLocationDegrees = -79.38
//
//        let latdelta:CLLocationDegrees = 00000*2
//        let londelta:CLLocationDegrees = 00000*2
//
//        let span = MKCoordinateSpan(latitudeDelta: latdelta, longitudeDelta: londelta)
//
//        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitute)
//
//        let region = MKCoordinateRegion(center: location, span: span)
//        mapview.setRegion(region, animated: true)
        
        let coordinatezoomin = mapview.userLocation.coordinate
        let region = MKCoordinateRegion(center: coordinatezoomin, latitudinalMeters: 9000000*2, longitudinalMeters: 9000000*2)
        mapview.setRegion(region, animated: true)
////
    }
    
    
    
    
    
    
    @objc func tappinggesture(gesture:UITapGestureRecognizer){
           
        for anno in mapview.annotations{
            
            mapview.removeAnnotation(anno)
        }
       for overlay in mapview.overlays{
           
           mapview.removeOverlay(overlay)
       }
           let tap = gesture.location(in: mapview)
          // let tap1 = tap
           let coordinate = mapview.convert(tap, toCoordinateFrom: mapview)
           
           let annotation = MKPointAnnotation()
          // annotation.title
           annotation.coordinate = coordinate
           
        mapview.addAnnotation(annotation)
           // tappingnumbers += 1
            
            let destinationcoordinates = Place(coordinate: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude))
            
            places.append(destinationcoordinates)
            print(places[0].coordinate)
        
        
//        else{
//            let tap = gesture.location(in: mapview)
//                  // let tap1 = tap
//                   let coordinate = mapview.convert(tap, toCoordinateFrom: mapview)
//
//                   let annotation = MKPointAnnotation()
//                  // annotation.title =
//
//
//                   annotation.coordinate = coordinate
//
//
//
//                mapview.removeAnnotation(annotation)
//                    tappingnumbers += 1
//        }
       // mapview.removeAnnotation(annotation)
        
    }
    
    @IBAction func findmyway(_ sender: Any) {
        
        mapview.showsUserLocation = true
        getdirection(destination: places.last!.coordinate)
        
        
    }
    
    


}
extension ViewController:MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        if annotation is MKUserLocation{
            return nil
        }
        else{
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationidentifier")
            pin.animatesDrop = true
            pin.tintColor = .orange
//            let annotationview = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView ()
//            annotationview.image = UIImage(named: "ic_place_2x")
            //showing the location name when click on location
//            annotationview.canShowCallout = true
            //showing the add information regarding location when click on location
//            annotationview.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return pin
        }
            
    
        
    }
    
    
    //this func is needed to add overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
      //  for shiowing location between two location we have to  add if overlay and else if overlay
        
      if overlay is MKPolyline{
//        let rendrer = MKCircleRenderer (overlay: overlay)
//        rendrer.fillColor = UIColor.black.withAlphaComponent(0.5)
//        rendrer.strokeColor = UIColor.green
//        rendrer.lineWidth = 2
//        return rendrer
            
//        } else if overlay is MKPolyline{
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 3
            return renderer
            
       }
        //for making polygon of by adding one line
//        else if overlay is MKPolygon{
//            let renderer = MKPolygonRenderer(overlay: overlay)
//            renderer.strokeColor = UIColor.red
//            renderer.lineWidth = 2
//            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
//
//            return renderer
// }
       return MKOverlayRenderer()
}
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        <#code#>
//    }
    
    
    
        
        
    }
 




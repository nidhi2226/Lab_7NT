//
//  TripViewController.swift
//  Lab_7NT
//
//  Created by user237779 on 3/18/24.
//
import UIKit
import MapKit
import CoreLocation
class TripViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentSpeed.text = "00.00 km/h"
        maxSpeed.text = "00.00 km/h"
        avgSpeed.text = "00.00 km/h"
        distance.text = "00.00 km"
        maxAcceleration.text = "00.00 (m/s²)"
        
        // Do any additional setup after loading the view.
    }

    
    @IBOutlet weak var currentSpeed: UILabel!
    
    @IBOutlet weak var maxSpeed: UILabel!
    
    @IBOutlet weak var avgSpeed: UILabel!
    
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var maxAcceleration: UILabel!
    
    @IBOutlet weak var speedAlert: UILabel!
    
    @IBOutlet weak var userLocationMap: MKMapView!
    
    @IBOutlet weak var tripAlert: UILabel!
    
    var tempAverageSpeed: Double = 0
    var tempMaXSpeed: Double = 0
    var locationOfStarting:CLLocation!
    var totalDistance:Double = 0
    var currentTimeSeconds:Date!
    var startTimeSeconds: Date!
    
    
    @IBAction func startTrip(_ sender: UIButton) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationOfStarting = locationManager.location
        startTimeSeconds = locationManager.location?.timestamp
        tripAlert.backgroundColor = UIColor.green
        
    }
    
    @IBAction func endTrip(_ sender: UIButton) {
        locationManager.stopUpdatingLocation()
        currentTimeSeconds = locationManager.location?.timestamp
        
        let interval = currentTimeSeconds.timeIntervalSince(startTimeSeconds) + 1
        maxAccelerationCalculate(interval)
        locationManager.stopUpdatingHeading()
        tripAlert.backgroundColor = UIColor.gray
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

           if let location = locations.first {
               
               manager.startUpdatingLocation()
               
               render(location)
                        

           }

       }
    func render (_ location: CLLocation) {
        
        let coordinate = CLLocationCoordinate2D (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude )
        
        //span settings determine how much to zoom into the map - defined details
        
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        
        let tempSpeed: Double = round(((location.speed * 3.6) * 100)/100)
        
        currentSpeed.text = "\(tempSpeed)  km/h"
        avgSpeedCalculate(location.speed)
        
        // HERE 3.6 IS THE CONVERTER BETWEEN KM AND METER BECAUSE SPEED IS IN METERE IF WE WANT TO
        // CONVERT IT IN KM THEN 1 KM = X METER * 3.6
        
        avgSpeed.text = "\(round((tempAverageSpeed * 3.6) * 100)/100) km/h"
        
        maxSpeedCalculate(tempSpeed)
        
        
        maxSpeed.text = "\(tempMaXSpeed) km/h"
        
        
        if let currentLocation = locationManager.location {
            totalDistance = (round(((currentLocation.distance(from: locationOfStarting))/1000)*100)/100)
            distance.text = "\(totalDistance) km"
        } else {
            print("Location data is not available")
        }
        
        // Check if tempSpeed is greater than 115
        if tempSpeed > 115 {
            speedAlert.backgroundColor = UIColor.red
        } else {
            speedAlert.backgroundColor = UIColor.lightGray
        }
        
        print(location.timestamp)
        
        userLocationMap.setRegion(region, animated: true)
        self.userLocationMap.showsUserLocation = true
    }
    func avgSpeedCalculate(_ speed:Double){
        tempAverageSpeed = (speed + tempAverageSpeed) / 2
    }
    
    
    func maxSpeedCalculate(_ speed:Double){
        
        if(tempMaXSpeed < speed){
            tempMaXSpeed = speed
        }
        
    }
    
    func maxAccelerationCalculate(_ interval:Double){
        
        let maxAcc = round((((tempAverageSpeed / 3.6) / interval) * 100) / 100)
        maxAcceleration.text = "\(maxAcc) m/s"
    }
    
}



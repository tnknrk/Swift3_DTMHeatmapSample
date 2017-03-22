//
//  ViewController.swift
//  DTHeatmapSwift3
//
//  Created by Noriko TANAKA on 22/03/2017.
//  Copyright © 2017 apps0309. All rights reserved.
//

import UIKit
import DTMHeatmap
import SwiftyJSON

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

	@IBOutlet weak var mapView: MKMapView!
	var locmanager = CLLocationManager()
	var heatMap = DTMHeatmap()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		self.mapView.delegate = self
		self.locmanager.delegate = self
		
		let center = CLLocationCoordinate2D(latitude: 35.367863, longitude: 136.637349)
		let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
		self.mapView.setRegion(region, animated: true)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func initMapView() {
		self.mapView.showsUserLocation = true
		self.locmanager.startUpdatingLocation()
		
		var heatmapdata:[NSObject: Double] = [:]
		let path = Bundle.main.path(forResource: "indiemap", ofType: "json")
		do{
			let jsonStr = try String(contentsOfFile: path!)
			let json =  JSON.init(parseJSON: jsonStr)
			for(index: _, subJson: dic) in json {
				let coordinate = CLLocationCoordinate2D(latitude: dic["lat"].double!, longitude: dic["lon"].double!)
				var point = MKMapPointForCoordinate(coordinate)
				let type = "{MKMapPoint=dd}"
				let value = NSValue(bytes: &point, objCType: type)
				heatmapdata[value] = 1.0
			}
			self.heatMap.setData(heatmapdata as [NSObject : AnyObject])
			self.mapView.add(self.heatMap)
		} catch{
		}
	}
	
	// MARK: - LocationManager Delegate
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .notDetermined:
			self.locmanager.requestWhenInUseAuthorization()
		case .restricted, .denied:
			break
		case .authorizedAlways, .authorizedWhenInUse:
			self.initMapView()
			break
		}
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
	}
	
	// MARK: - MapView Delegate
	func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
	}

	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		return DTMHeatmapRenderer.init(overlay: overlay)
	}
}

